import numpy as np

import argparse
import os
import os.path
from os import path
from pyuvdata import UVData
import subprocess
import yaml

parser = argparse.ArgumentParser()
parser.add_argument('obs_file', help='The path to a txt file containing the path to all uvfits files to be executed on')
parser.add_argument('outdir', help='Output directory')
parser.add_argument('version_str', help='A string to include in the name of all outputs indicating the run version')
parser.add_argument('PBS_ARRAYID', help='The index of the array job to run')
parser.add_argument('band', help='Options are low,mid,high,full - determines frequency band')
parser.add_argument('exants', help='A yml file containing a list of flagged antennas')
args = parser.parse_args()

print('obs_file is:')
print(str(args.obs_file))
print('outdir is:')
print(str(args.outdir))
print('version_str is:')
print(str(args.version_str))
print('Array ID is:')
print(str(args.PBS_ARRAYID))
print('band is:')
print(str(args.band))

overwrite = False

xants = []
# if args.exants=="None":
# 	xants = []
# else:
# 	with open(args.exants, 'r') as xfile:
# 		xants = yaml.safe_load(xfile)

if not os.path.exists(args.outdir):
    os.makedirs(args.outdir)

ind = int(args.PBS_ARRAYID)-1
if ind > 0:
	print(f'ind is {ind}')
	f = open(args.obs_file, "r")
	file_names = f.read().split('\n')
	filepath = file_names[ind]
	#print(file_names[ind*4:ind*4+4])
	print(file_names[ind])

	uv = UVData()
	#uv.read(file_names[ind*4:ind*4+4])
	uv.read(file_names[ind])
	ants = uv.antenna_numbers
	if len(xants)>0:
		use_ants = [ant for ant in ants if ant not in xants]
		uv.select(antenna_nums=use_ants)
	unique = np.unique(uv.time_array)
	for i in range(0,2):
		use_times = unique[i*10:i*10+10]
		uv2 = uv.select(times=use_times,inplace=False)
		phaseCenter = np.median(use_times)
		if args.band=='low':
			# 60-85 MHz
			uv2.select(frequencies=uv2.freq_array[0][108:312])
		elif args.band=='mid':
			# 150-180 MHz
			uv2.select(frequencies=uv2.freq_array[0][845:1090])
		elif args.band=='high':
			# 200-220 MHz
			uv2.select(frequencies=uv2.freq_array[0][1254:1418])
		version = f'{use_times[0]}_{args.version_str}_{args.band}_{ind+1}_{i}'
		uv2.phase_to_time(phaseCenter)
		outname = f'{args.outdir}/uvfits_files/{use_times[0]}_{args.band}.uvfits'
		dirname = args.outdir + '/fhd_' + version + '/beams'
		sourcefile = f'{args.outdir}/fhd_{version}/output_data/{use_times[0]}_{args.band}_uniform_Sources_XX.fits'
		if path.exists(sourcefile) and overwrite is False:
			print(f'{sourcefile} already exists - SKIPPING')
		elif path.exists(dirname) and overwrite is False:
			print('%s has already been run - SKIPPING' % version)
		else:
# 			uv2.write_uvfits(outname, spoof_nonessential=True)
			os.system("idl -e run_h4c_vivaldibeam -args " + filepath + " " + version + " " + args.outdir)
