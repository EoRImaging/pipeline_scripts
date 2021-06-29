#! /usr/bin/env python

from SSINS import SS, INS, version, MF, util
from SSINS import Catalog_Plot as cp
from SSINS.data import DATA_PATH
from functools import reduce
import numpy as np
import argparse
from pyuvdata import UVData, UVFlag
import yaml
from hera_mc import cm_hookup

parser = argparse.ArgumentParser()
parser.add_argument("-f", "--filename",
                    help="The visibility file(s) to process")
parser.add_argument("-s", "--streak_sig", type=float, default=20,
                    help="The desired streak significance threshold")
parser.add_argument("-o", "--other_sig", type=float, default=5,
                    help="The desired significance threshold for other shapes")
parser.add_argument("-p", "--prefix",
                    help="The prefix for output files")
parser.add_argument("-a", "--xants",
                    help="The path to a yml file containing a list of antennas to exclude")
parser.add_argument("-d", "--shape_dict",
                    help="The path to a yml file containing a dict of shapes to use")
parser.add_argument("-t", "--tb_aggro", type=float,
                    help="The tb_aggro parameter for the match filter.")
parser.add_argument("-c", "--clobber", action='store_true',
                    help="Whether to overwrite files that have already been written")
parser.add_argument("-x", "--no_diff", action='store_false',
                    help="Flag to turn off differencing. Use if files are already time-differenced.")
parser.add_argument("-N", "--num_baselines", type=int, default=0,
                    help="The number of baselines to read in at a time")
parser.add_argument("-I", "--internode_only", type=int, default=0,
                    help="The number of baselines to read in at a time")
parser.add_argument("-S", "--intersnap_only", type=int, default=0,
                    help="The number of baselines to read in at a time")
args = parser.parse_args()

print(args.no_diff)

print('ARGS:')
print(args)
print('\n')

f = open(args.filename, "r")
file_names = f.read().split('\n')

for i,f1 in enumerate(file_names[::10]):
    print(f'Running on {file_names[i]}')
    name = f1.split('/')[-1][0:-5]
    prefix = f'{args.prefix}/{name}'
    print(f'Prefix: {prefix}')

    version_info_list = [f'{key}: {version.version_info[key]}, ' for key in version.version_info]
    version_hist_substr = reduce(lambda x, y: x + y, version_info_list)

    # Make the uvflag object for storing flags later, and grab bls for partial I/O
    uvd = UVData()
    uvd.read(file_names[i*10:i*10+10], read_data=False)

    # Exclude flagged antennas
    with open(args.xants, 'r') as xfile:
        xants = yaml.safe_load(xfile)
    use_ants = [ant for ant in uvd.antenna_numbers if ant not in xants]
    uvd.select(antenna_nums=use_ants)
    
    if args.internode_only==1 or args.intersnap_only==1:
        if i==0:
            int_bls = []
            snap_bls = []
            for a1 in use_ants:
                for a2 in use_ants:
                    if a1<a2:
                        h = cm_hookup.Hookup()
                        x = h.get_hookup('HH')
                        key1 = 'HH%i:A' % (a1)
                        n1 = x[key1].get_part_from_type('node')[f'N<ground'][1:]
                        s1 = x[key1].hookup[f'N<ground'][-1].downstream_input_port[-1]
                        key2 = 'HH%i:A' % (a2)
                        n2 = x[key2].get_part_from_type('node')[f'N<ground'][1:]
                        s2 = x[key2].hookup[f'N<ground'][-1].downstream_input_port[-1]
                        if n1 != n2:
                            int_bls.append((a1,a2))
                            snap_bls.append((a1,a2))
                        elif n1==n2 and s1!=s2:
                            snap_bls.append((a1,a2))
        if args.internode_only==1:
            print('###### Excluding all intranode baselines ######')
            uvd.select(bls=int_bls)
        else:
            print('###### Excluding all intrasnap baselines ######')
            uvd.select(bls=snap_bls)

    bls = uvd.get_antpairs()
    uvf = UVFlag(uvd, waterfall=True, mode='flag')
    del uvd

    # Make the SS object
    ss = SS()
    if args.num_baselines > 0:
        ss.read(file_names[i*10:i*10+10], bls=bls[:args.num_baselines],
                diff=args.no_diff)
        ins = INS(ss)
        Nbls = len(bls)
        for slice_ind in range(args.num_baselines, Nbls, args.num_baselines):
            ss = SS()
            ss.read(file_names[i*10:i*10+10], bls=bls[slice_ind:slice_ind + args.num_baselines],
                    diff=args.no_diff)
            new_ins = INS(ss)
            ins = util.combine_ins(ins, new_ins)
    else:
        ss.read(file_names[i*10:i*10+10], diff=args.no_diff, antenna_nums=use_ants)
        if args.internode_only == 1:
            ss.select(bls=int_bls)
        elif args.intersnap_only == 1:
            ss.select(bls=snap_bls)
        ss.select(ant_str='cross')
        
        ins = INS(ss)

    # Clear some memory
    del ss

    # Write the raw data and z-scores to h5 format
    ins.write(prefix, sep='.', clobber=args.clobber)
    ins.write(prefix, output_type='z_score', sep='.', clobber=args.clobber)

    # Write out plots
    cp.INS_plot(ins, f'{prefix}_RAW', vmin=0, vmax=20000, ms_vmin=-5, ms_vmax=5)

    # Flag FM radio
    where_FM = np.where(np.logical_and(ins.freq_array > 87.5e6, ins.freq_array < 108e6))
    ins.metric_array[:, where_FM] = np.ma.masked
    ins.metric_ms = ins.mean_subtract()
    ins.history += "Manually flagged the FM band. "

    # Make a filter with specified settings
    with open(args.shape_dict, 'r') as shape_file:
        shape_dict = yaml.safe_load(shape_file)

    sig_thresh = {shape: args.other_sig for shape in shape_dict}
    sig_thresh['narrow'] = args.other_sig
    sig_thresh['streak'] = args.streak_sig
    mf = MF(ins.freq_array, sig_thresh, shape_dict=shape_dict, tb_aggro=args.tb_aggro)

    # Do flagging
    mf.apply_match_test(ins, time_broadcast=True)
    ins.history += f"Flagged using apply_match_test on SSINS {version_hist_substr}."

    cp.INS_plot(ins, f'{prefix}_FLAGGED', vmin=0, vmax=20000, ms_vmin=-5, ms_vmax=5)

    # Write outputs
    ins.write(prefix, output_type='mask', sep='.', clobber=args.clobber)
    uvf.history += ins.history
    # "flags" are not helpful if no differencing was done
    if args.no_diff:
        ins.write(prefix, output_type='flags', sep='.', uvf=uvf, clobber=args.clobber)
    ins.write(prefix, output_type='match_events', sep='.', clobber=args.clobber)
