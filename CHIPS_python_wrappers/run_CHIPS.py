#!/usr/bin/env python
from __future__ import print_function
from numpy import *
from subprocess import call,check_output
from sys import exit
from os import environ,getcwd
from os.path import exists
import os

def command(cmd,debug=False):
    '''Run cmd on the command line. Prints out cmd if
    debug == True'''
    if debug: print(cmd)
    call(cmd,shell=True)

def test_false(option,value):
    '''Test if a necessary argument has a value
    Exit with a warning message if not'''
    if value == None:
        exit('%s must be set for this script - please check your input arguments. Exiting now.' %option)
    else:
        pass
    return value

def read_env_variables(filename):
    '''Reads the environment variables stored in the
    cluster specific bash script'''
    lines = open(filename,'r').read().split('\n')
    for line in lines:
        if '=' in  line:
            if 'CODEDIR' in line: CODEDIR = line.split('=')[-1]
            elif 'OUTPUTDIR' in line: OUTPUTDIR = line.split('=')[-1]
            elif 'OBSDIR' in line: OBSDIR = line.split('=')[-1]
            elif 'INPUTDIR' in line: INPUTDIR = line.split('=')[-1]
            elif 'BEAMDIR' in line: BEAMDIR = line.split('=')[-1]
            elif 'PBSDIR' in line: PBSDIR = line.split('=')[-1]
            elif 'PLOTSDIR' in line: PLOTSDIR = line.split('=')[-1]
                
        else:
            pass
        
    return CODEDIR,OUTPUTDIR,OBSDIR,INPUTDIR,BEAMDIR,PBSDIR,PLOTSDIR

def make_grid_sbatch(obs=None,band=None,uvfits_dir=None,uvfits_tag=None,output_tag=None,INPUTDIR=None,cluster=None,
                     ENV_VARIABLES=None,CODEDIR=None,finebeam=None,drips=None,freqres=None,timeres=None,field=None,base_freq=None):
    
    ##There is a gap in ultra freq coverage due to FM band
    ##so default only process 20 bands
    if band == 'ultra':
        num_coarse_bands = 20
    else:
        num_coarse_bands = 24
        
    ##Test if the uvfits files specified even exist
    for coarse_band in range(1,num_coarse_bands+1):
        if exists('%s%s/%s/%s%02d.uvfits' %(INPUTDIR,obs,uvfits_dir,uvfits_tag,coarse_band)):
            pass
        else:
            pass
            #print("%s%s/%s/%s%02d.uvfits doesn't exist - CHIPS will fail. Check --uvfits_dir and --uvfits_tag make sense. Exiting now" %(INPUTDIR,obs,uvfits_dir,uvfits_tag,coarse_band))
            exit("%s%s/%s/%s%02d.uvfits doesn't exist - CHIPS will fail. Check --uvfits_dir and --uvfits_tag make sense. Exiting now" %(INPUTDIR,obs,uvfits_dir,uvfits_tag,coarse_band))
    
    outfile = open('run_grid_%s%s_%s.sh' %(obs,uvfits_dir,output_tag) ,'w+')
    
    outfile.write('#!/bin/bash\n')
    outfile.write('#SBATCH --job-name="grid_%s%s_%s"\n' %(obs,uvfits_dir,output_tag))
    outfile.write('#SBATCH --export=NONE\n')
    outfile.write('#SBATCH --time=00:40:00\n')
    outfile.write('#SBATCH --nodes=1\n')
    outfile.write('#SBATCH --cpus-per-task=16\n')
    outfile.write('#SBATCH --output=grid_%s%s_%s.%%j.o\n' %(obs,uvfits_dir,output_tag))
    outfile.write('#SBATCH --error=grid_%s%s_%s.%%j.e\n' %(obs,uvfits_dir,output_tag))
    outfile.write('#SBATCH --mem=30000\n')
    outfile.write('#SBATCH --array=1-%d\n' %num_coarse_bands)
        
    if cluster == 'ozstar':
        outfile.write('#SBATCH --partition=skylake\n')
        outfile.write('#SBATCH --account=oz048\n')
        outfile.write('module load openblas/0.2.20\n')
        outfile.write('module load gcc/6.4.0 openmpi/3.0.0\n')
    else:
        ##TODO this is where new clusters go if we transfer elsewhere
        pass
        
    outfile.write('source %s\n' %ENV_VARIABLES)
    outfile.write('export OMP_NUM_THREADS=16\n')
    outfile.write('cd %s\n' %CODEDIR)
    outfile.write('GPUBOXN=$(printf "%02d" "$SLURM_ARRAY_TASK_ID")\n')
    
    ##Setup the correct arguments to the CHIPS commands
    if band == 'ultra': band_num = 0
    elif band == 'low': band_num = 0
    elif band == 'high': band_num = 1
        
    if drips:
        command = "./gridvisdrips"
    else:
        if band == 'ultra':
            command = './gridvisultra'
        else:
            if finebeam:
                command = "./gridvisdifffine"
            else:
                command = "./gridvisdiff"

    cmd = 'srun --mem=30000 --export=ALL %s %s%s/%s/%s${GPUBOXN}.uvfits %s %s_%s %d -f %d -p %.3f -c %.5f' %(command,INPUTDIR,obs,uvfits_dir,uvfits_tag,obs,uvfits_dir,output_tag,band_num,field,timeres,freqres)
    if base_freq:
        cmd += ' -n %.5f' %(base_freq)

    
    outfile.write('%s\n' %cmd)

    return 'run_grid_%s%s_%s.sh' %(obs,uvfits_dir,output_tag)

def write_clean_script(uvfits_dir=None,uvfits_tag=None,ENV_VARIABLES=None,cluster=None,no_delete=None):
    outfile = open('run_clean_%s_%s.sh' %(uvfits_dir,output_tag),'w+')
    
    outfile.write('#!/bin/bash -l\n')
    outfile.write('#SBATCH --job-name="clean_%s_%s"\n' %(uvfits_dir,output_tag))
    outfile.write('#SBATCH --export=NONE\n')
    outfile.write('#SBATCH --time=8:00:00\n')
    outfile.write('#SBATCH --nodes=1\n')
    outfile.write('#SBATCH --cpus-per-task=1\n')
    outfile.write('#SBATCH --output=clean_%s_%s.%%j.o\n' %(uvfits_dir,output_tag))
    outfile.write('#SBATCH --error=clean_%s_%s.%%j.e\n' %(uvfits_dir,output_tag))
    outfile.write('#SBATCH --mem=30000\n')
        
    if cluster == 'ozstar':
        outfile.write('#SBATCH --partition=skylake\n')
        outfile.write('#SBATCH --account=oz048\n')
        outfile.write('module load openblas/0.2.20\n')
        outfile.write('module load gcc/6.4.0 openmpi/3.0.0\n')

    else:
        ##TODO this is where new clusters go if we transfer elsewhere
        pass
    
    outfile.write('source %s\n' %ENV_VARIABLES)
    outfile.write('export OMP_NUM_THREADS=16\n')

    outfile.write('cd $CODEDIR\n')

    outfile.write('time rm ${OUTPUTDIR}bv_freq*.extension.dat\n')
    outfile.write('time rm ${OUTPUTDIR}noise_freq*.extension.dat\n')
    outfile.write('time rm ${OUTPUTDIR}weights_freq*.extension.dat\n')
    
    if no_delete:
        pass
    else:
        cwd = getcwd()
        outfile.write('rm %s/*grid*%s_%s*\n' %(cwd,uvfits_dir,output_tag))
        outfile.write('rm %s/*lssa_%s_%s*\n' %(cwd,uvfits_dir,output_tag))
        outfile.write('rm %s/*clean_%s_%s*\n' %(cwd,uvfits_dir,output_tag))

    return 'run_clean_%s_%s.sh' %(uvfits_dir,output_tag)
        
def make_lssa(band=None,pol=None,cluster=None,drips=None,base_freq=None,freqres=None,timeres=None):
    
    outfile = open('run_lssa_%s_%s_%s.sh' %(uvfits_dir,output_tag,pol),'w+')
    
    outfile.write('#!/bin/bash -l\n')
    outfile.write('#SBATCH --job-name="lssa_%s_%s_%s"\n' %(uvfits_dir,output_tag,pol))
    outfile.write('#SBATCH --export=NONE\n')
    outfile.write('#SBATCH --time=4:00:00\n')
    outfile.write('#SBATCH --nodes=1\n')
    outfile.write('#SBATCH --cpus-per-task=16\n')
    outfile.write('#SBATCH --output=lssa_%s_%s_%s.%%j.o\n' %(uvfits_dir,output_tag,pol))
    outfile.write('#SBATCH --error=lssa_%s_%s_%s.%%j.e\n' %(uvfits_dir,output_tag,pol))
    outfile.write('#SBATCH --mem=30000\n')
    
    if cluster == 'ozstar':
        outfile.write('#SBATCH --partition=skylake\n')
        outfile.write('#SBATCH --account=oz048\n')
        outfile.write('module load openblas/0.2.20\n')
        outfile.write('module load gcc/6.4.0 openmpi/3.0.0\n')

    else:
        ##TODO this is where new clusters go if we transfer elsewhere
        pass

    outfile.write('source %s\n' %ENV_VARIABLES)
    outfile.write('export OMP_NUM_THREADS=16\n')
    outfile.write('printenv\n')

    outfile.write('cd $CODEDIR\n')
    
    ##Setup the correct arguments to the CHIPS commands
    if band == 'ultra': band_num = 0
    elif band == 'low': band_num = 0
    elif band == 'high': band_num = 1
        

    ##There is a gap in ultra freq coverage due to FM band
    ##so default only process 20 bands
    if band == 'ultra':
        num_coarse_bands = 20
    else:
        num_coarse_bands = 24

    full_bandwidth = num_coarse_bands * 1.28e+6
    num_chans = int(full_bandwidth / freqres)
    

    if drips:
        command1 = "./prepare_lssa_drips"
        command2 = "./lssa_fg_drips"
    else:
        if band == 'ultra':
            command1 = "./prepare_ultra"
        else:
            command1 = "./prepare_diff"
        command2 = "./lssa_fg_thermal"

    ##In the commnand below, 80 is the number of k bins, and 300 is the maximum uv value to grid up to
    cmd1 = "srun --mem=30000 --export=ALL %s %s_%s %d 0 '%s' %s_%s %d -c %.5f -p %.3f"  %(command1,uvfits_dir,output_tag,num_chans,pol,uvfits_dir,output_tag,band_num,freqres,timeres)
    cmd2 = "srun --mem=30000 --export=ALL %s %s_%s %d 80 '%s' 300. %s_%s 0 %d 0 -c %.5f -p %.3f"  %(command2,uvfits_dir,output_tag,num_chans,pol,uvfits_dir,output_tag,band_num,freqres,timeres)


    if base_freq:
        cmd1 += ' -n %.5f' %(base_freq)

        
    outfile.write("%s\n"  %cmd1)
    outfile.write("%s\n"  %cmd2)

    return 'run_lssa_%s_%s_%s.sh' %(uvfits_dir,output_tag,pol)

##Do the running        
if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description="Setup and run jobs to run CHIPS")

    parser.add_argument('--cluster', default='ozstar',help='Which cluster is being used. Default is ozstar. Current clusters: ozstar')
    parser.add_argument('--obs_list', default=None,help='Text file list of all obs IDs to be processed')
    parser.add_argument('--uvfits_dir', default=None,help='The name of the directory that the uvfits are stored in - default is to be located be located in */MWA/data/obsID')
    parser.add_argument('--band',default=None,help='Which band you are processing: ultra, low, or high')
    parser.add_argument('--output_tag',default=None,help='Tag to add to output names')
    parser.add_argument('--obs_range', default=None,help='Range of observations within --obs_list to use - enter 2 values separated by a comma (e.g --obs_range=0,1 to only process the first obs)')

    parser.add_argument('--data_dir',default=False,help='If data does not live in generic /MWA/data dir, enter the base directory here. Script will search for uvfits files in /data_dir/obsID/uvfits_dir')
    parser.add_argument('--finebeam',default=False,action='store_true',help='Add to grid with the fine channel beam instead of course channel beam (NO SUPPORT FOR ULTRA CURRENTLY)')
    parser.add_argument('--debug',default=False,action='store_true',help='Add to print out all subprocess commands run by this script')
    parser.add_argument('--uvfits_tag',default='uvdump_',help="Add different if your uvfits don't follow RTS naming conventions - however they MUST end in *01.uvfits where 01 is band number. Name of uvfits will be interpreted as: '%%s%%02d.uvfits %%(args.uvfits_tag,band_number)' ")
    parser.add_argument('--no_delete',default=False,action='store_true',help='Default is to auto-delete the error and output logs - add this to retain (please consider deleting them ASAP once read)')
    parser.add_argument('--drips',default=False,action='store_true',help='Add to run with DRIPS instead of CHIPS')
    parser.add_argument('--no_run',default=False,action='store_true',help="Don't submit the jobs to the queue")

    parser.add_argument('--base_freq',default=False,help="If using FHD or non-RTS base frequency, add the base frequency here in Hz")
    parser.add_argument('--timeres',default=8.0,help="Time resolution of data (s) - defaults to 8s")
    parser.add_argument('--freqres',default=80.0e+3,help="Frequency resolution of the data (Hz), defaults to 80e+3Hz")
    parser.add_argument('--field',default=2,help="Limit gridded to specific field. Use field=0 for EoR0 and field=1 for EoR1 (defaults to grid anything)")




    args = parser.parse_args()

    ##Get optional arguments
    cluster = args.cluster
    finebeam = args.finebeam
    debug = args.debug
    uvfits_tag = args.uvfits_tag
    no_delete = args.no_delete
    drips = args.drips
    
    base_freq = args.base_freq
    if base_freq: base_freq = float(base_freq)

    timeres = float(args.timeres)
    freqres = float(args.freqres)
    field = int(args.field)

    ##Test the necessary arguments have been passed
    obs_list = test_false('--obs_list', args.obs_list)
    try:
        obs_list = open(obs_list,'r').read().split('\n')
        obs_list = array([obs for obs in obs_list if obs != '' and obs != ' ' ])
    except:
        exit('Cannot read --obs_list=%s, please check file. Exiting now.' %obs_list)
    
    uvfits_dir = test_false('--uvfits_dir', args.uvfits_dir)
    ##Make sure we have the correct amount of dir slashes as expected throughout script
    if uvfits_dir[-1] == '/': uvfits_dir = uvfits_dir[:-1]
    band = test_false('--band',args.band)
    output_tag = test_false('--output_tag',args.output_tag)
    obs_range = test_false('--obs_range', args.obs_range)

    ##Try and make a sensible obs range. Exit if failed
    try:
        low,high = map(int,obs_range.split(','))
        obs_range = range(low,high)
    except:
        exit('Cannot convert --obs_range into two numbers - please check your input. Exiting')

    ##Get cluster specific information
    ##Get environment variables - python doesn't like you running source
    ##as it's a shell builtin - so manually read them from the text file
    ##TODO add other clusters if we port this elsewhere
    if cluster == 'ozstar':
        ENV_VARIABLES = '/fred/oz048/MWA/CODE/CHIPS/chips/ozstar_env_variables.sh'
        CODEDIR,OUTPUTDIR,OBSDIR,INPUTDIR,BEAMDIR,PBSDIR,PLOTSDIR = read_env_variables(ENV_VARIABLES)
    else:
        exit('The cluster you have requested is not recognised - please see --cluster help')

    ##If user supplies a different data_dir
    ##then update INPUTDIR
    if args.data_dir:
        INPUTDIR = args.data_dir
        if INPUTDIR[-1] == '/': pass
        else: INPUTDIR += '/'
    
    grid_jobs = []    
    ##for all observations, write gridding sbatch files
    for obs in obs_list[obs_range]:
        grid_job = make_grid_sbatch(obs=obs,band=band,uvfits_dir=uvfits_dir,uvfits_tag=uvfits_tag,output_tag=output_tag,
            INPUTDIR=INPUTDIR,cluster=cluster,ENV_VARIABLES=ENV_VARIABLES,CODEDIR=CODEDIR,finebeam=finebeam,drips=drips,base_freq=base_freq,timeres=timeres,freqres=freqres,field=field)
        grid_jobs.append(grid_job)
        
    clean_job = write_clean_script(uvfits_dir=uvfits_dir,uvfits_tag=uvfits_tag,ENV_VARIABLES=ENV_VARIABLES,cluster=cluster,no_delete=no_delete)
    
    job_xx = make_lssa(band=band,pol='xx',cluster=cluster,drips=drips,base_freq=base_freq,timeres=timeres,freqres=freqres)
    job_yy = make_lssa(band=band,pol='yy',cluster=cluster,drips=drips,base_freq=base_freq,timeres=timeres,freqres=freqres)
    lssa_jobs = [job_xx,job_yy]
        
    
    ##==================sbatch and do depends======================##

    ##launch first grid job
    
    if args.no_run:
        pass
    else:
	#Make output logs directory
	cwd = os.getcwd()
        output_log_dir = 'logs_' + output_tag
	if not os.path.exists(output_log_dir):
	    os.mkdir(output_log_dir)	
	
        grid_job_name = cwd + '/' + output_log_dir + '/' + grid_job.strip('.sh')
        grid_job_message = check_output('sbatch -e %s-%%\A_%%a.err -o %s-%%\A_%%a.out %s' %(grid_job_name,grid_job_name,grid_jobs[0]),shell=True)
        grid_job_ID_start = grid_job_message.split()[-1].strip('\n')
	grid_jobs_ID_all = []
	grid_jobs_ID_all.append(grid_job_ID_start)
	print(grid_job_ID_start)        

	##launch other grid jobs, with a dependance that the last one has run
        for grid_job in grid_jobs[1:]:
	    grid_job_name = cwd + '/' + output_log_dir + '/' + grid_job.strip('.sh')
            grid_jobs_ID_join = ''.join(grid_jobs_ID_all)
            grid_job_message = check_output('sbatch --dependency=afterok:%s -e %s-%%\A_%%a.err -o %s-%%\A_%%a.out %s' %(grid_jobs_ID_join,grid_job_name,grid_job_name,grid_job),shell=True)
            grid_job_ID = grid_job_message.split()[-1].strip('\n')
	    grid_jobs_ID_all.append(':')
	    grid_jobs_ID_all.append(grid_job_ID)
            print(grid_job_ID)
        
	##Run lssa xx
	grid_jobs_ID_all = ''.join(grid_jobs_ID_all)
	lssa_xx_job_name = cwd + '/' + output_log_dir + '/' + job_xx.strip('.sh')
        xx_job_message = check_output('sbatch --dependency=afterok:%s -e %s-%%j.err -o %s-%%j.out %s' %(grid_jobs_ID_all,lssa_xx_job_name,lssa_xx_job_name,job_xx),shell=True)
        xx_job_ID = xx_job_message.split()[-1].strip('\n')
        ##Run lssa yy
	lssa_yy_job_name = cwd + '/' + output_log_dir + '/' + job_yy.strip('.sh')
        yy_job_message = check_output('sbatch --dependency=afterok:%s -e %s-%%j.err -o %s-%%j.out %s' %(grid_jobs_ID_all,lssa_yy_job_name,lssa_yy_job_name,job_yy),shell=True)
        yy_job_ID = yy_job_message.split()[-1].strip('\n')

	clean_job_name = cwd + '/' + output_log_dir + '/' + clean_job.strip('.sh')
        #call('sbatch --dependency=afterany:%s:%s:%s -e %s-%%j.err -o %s-%%j.out %s' %(grid_jobs_ID_all,xx_job_ID,yy_job_ID,clean_job_name,clean_job_name,clean_job),shell=True)
