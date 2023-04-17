import argparse
import os
from pyuvdata import UVData, utils, UVFlag
import time
import numpy as np

t = time.time()
print(time.strftime('%Y-%m-%d %H:%M %Z', time.localtime(t)))
parser = argparse.ArgumentParser()
parser.add_argument("-o", "--obsid", help="The obsid of the file in question")
parser.add_argument("-d", "--outdir", help="The output directory")
parser.add_argument("-u", "--uvd", nargs="*", help="List of gpubox files to read")
parser.add_argument("-s", "--ssins", help="Path to ssins flag file")
parser.add_argument(
    "-p", "--phase", action="store_true", help="Option to phase to pointing center"
)
parser.add_argument(
    "-g", "--gains", action="store_true", help="Option to remove digital gains"
)
parser.add_argument(
    "-b", "--bandpass", action="store_true", help="Option to remove pfb bandpass"
)
parser.add_argument(
    "-v", "--vanvleck", action="store_true", help="Option to apply van vleck correction"
)
parser.add_argument(
    "-c", "--dcflags", action="store_true", help="Option to flag dc channel"
)
parser.add_argument(
    "-e", "--edge_flags", default=0, type=int, help="Width of edge channels to flag"
)
parser.add_argument(
    "-t", "--time_avg", default=0, type=int, help="Number of times to average together",
)
parser.add_argument(
    "-a",
    "--freq_avg",
    default=0,
    type=int,
    help="Number of frequencies to average together",
)
parser.add_argument("-k", "--select", help="Option to select autos or crosses")
parser.add_argument(
    "-f", "--output_format", default="uvfits", help="Format of output file"
)
parser.add_argument("-x", "--flagzero", action="store_true", help="Option to flag zeroeth fine channels")
args = parser.parse_args()

if not os.path.exists(args.outdir):
    os.makedirs(args.outdir)

print(f"The filelist is {args.uvd}")

if args.output_format != "uvfits" and args.output_format != "uvh5":
    raise ValueError("Output file type must be 'uvfits' or 'uvh5'")

if args.phase is False and args.output_format == "uvfits":
    raise ValueError(
        "Cannot write unphased data to uvfits files. Resubmit with -o 'uvh5'."
    )

uvd = UVData()
uvd.read(
    args.uvd,
    phase_to_pointing_center=args.phase,
    remove_dig_gains=args.gains,
    remove_coarse_band=args.bandpass,
    correct_van_vleck=args.vanvleck,
    flag_dc_offset=args.dcflags,
    edge_width=args.edge_flags,
)

print('finished reading file')
t = time.time()
print(time.strftime('%Y-%m-%d %H:%M %Z', time.localtime(t)))
if args.flagzero:
    zero_flags = np.arange(0,768, 32)
    uvd.flag_array[:, :, zero_flags, :] = True
if args.ssins is not None:
    uvf = UVFlag()
    uvf.read(args.ssins + "/" + args.obsid + "_SSINS_flags.h5")
    utils.apply_uvflag(uvd, uvf, inplace=True)
print('finished applying ssins')
t = time.time()
print(time.strftime('%Y-%m-%d %H:%M %Z', time.localtime(t)))
if args.select is not None:
    uvd.select(ant_str=args.select)
if args.time_avg > 0:
    uvd.downsample_in_time(n_times_to_avg=args.time_avg)
if args.freq_avg > 0:
    uvd.frequency_average(args.freq_avg)
print('finished averaging')
t = time.time()
print(time.strftime('%Y-%m-%d %H:%M %Z', time.localtime(t)))
file_string = ""
if args.ssins is not None:
    file_string += "_ssins"
if args.phase:
    file_string += "_phased"
if args.gains:
    file_string += "_gains"
if args.bandpass:
    file_string += "_bandpass"
if args.vanvleck:
    file_string += "_vv"
if args.dcflags:
    file_string += "_dc"
if args.edge_flags != 0:
    file_string += "_" + "edges" + str(args.edge_flags / 1000) + "kHz"
file_string += "_" + str(uvd.integration_time[0]) + "sec"
try:
    file_string += "_" + str(int(uvd.channel_width[0] / 1000)) + "kHz"
except Exception:
    file_string += "_" + str(int(uvd.channel_width / 1000)) + "kHz"
if args.flagzero:    
    file_string += "_flagzero"
if args.select is not None:
    file_string += "_" + str(args.select)
if file_string[0] == "_":
    file_string = file_string[1:]
try:
    os.mkdir(args.outdir + "/" + file_string)
except Exception:
    print('folder exists')

os.environ['py_folder'] = file_string

print('writing file')
print(f"{args.outdir}/" + file_string + "/" + f"{args.obsid}.uvfits")
if args.output_format == "uvfits":
    uvd.write_uvfits(
        f"{args.outdir}/" + file_string + "/" + f"{args.obsid}.uvfits", spoof_nonessential=True
    )
elif args.output_format == "uvh5":
    uvd.write_uvh5(f"{args.outdir}/" + file_string + "/" +  f"{args.obsid}.uvh5", clobber=True)
elif args.output_format == "ms":
    uvd.write_ms(f"{args.outdir}/" + file_string + "/" + f"{args.obsid}.ms")
elif args.output_format == "mir":
    uvd.write_mir(f"{args.outdir}/" + file_string + "/" + f"{args.obsid}.mir")
print('finished writing file')
t = time.time()
print(time.strftime('%Y-%m-%d %H:%M %Z', time.localtime(t)))
