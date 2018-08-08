#! /bin/bash
#############################################################################
#Slurm jobscript for running a single ObsID.  Second level program for 
#running firstpass on Oscar. First level program is 
#batch_firstpass.sh
#############################################################################

#SBATCH -J firstpass
# #SBATCH --mail-type=ALL
# #SBATCH --mail-user=nichole.barry@unimelb.edu.au

echo $SLURM_JOBID

#module load ghostscript
#module load imagemagick/6.6.4
#module load git/2.2.1

obsids=("$@")
obs_id=${obsids[$SLURM_ARRAY_TASK_ID]}

#Specify the FHD file path that is used in IDL (generally specified in idl_startup)
FHDpath=$(idl -e 'print,rootdir("fhd")') ### NOTE this only works if idlstartup doesn't have any print statements (e.g. healpix check)

idl -IDL_DEVICE ps -quiet -IDL_CPU_TPOOL_NTHREADS $ncores -e ${FHDpath}../pipeline_scripts/FHD_IDL_wrappers/nb_eor_firstpass_versions -args $obs_id $outdir $version 

if [ $? -eq 0 ]
then
    echo "Finished"
    exit 0
else
    echo "Job Failed"
    exit 1
fi

