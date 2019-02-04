#! /bin/bash
#############################################################################
#Slurm jobscript for running a single ObsID.  Second level program for 
#running firstpass on Oscar. First level program is 
#batch_firstpass.sh
#############################################################################

#SBATCH -J general
#SBATCH --mem 10G
#SBATCH -t 1:00:00
#SBATCH -n 2
#SBATCH --export=ALL

echo JOBID $SLURM_JOBID
echo TASKID $SLURM_ARRAY_TASK_ID

task_id=$SLURM_ARRAY_TASK_ID
j=1

if [ $j = 0 ]; then
######Run multiple downloads from the mantaray client

#*****to be put on command line
          #Read the obs file and put into an array, skipping blank lines if they exist
        obs_file_name='/home/nbarry/MWA/FHD/obs_list/Aug23_temp.txt'
        i=0
        while read line
        do
                if [ ! -z "$line" ]; then
                        obs_id_array[$i]=$line
                        i=$((i + 1))
                fi
        done < "$obs_file_name"

        #Find the number of obsids to run in array
        nobs=${#obs_id_array[@]}
        nobs=$((nobs-1))

	mem=10G
	wallclock_time=1:00:00
	ncores=2
#sbatch --mem=$mem -t ${wallclock_time} -n ${ncores} --array=0-$nobs -o /home/nbarry/general.out -e /home/nbarry/general.err /home/nbarry/MWA/pipeline_scripts/bash_scripts/general_slurm.sh ${obs_id_array[@]}

#*****

  #obs_id=($(python ${MWA_DIR}/CODE/MWA_Tools/scripts/pull_args.py $*))

  #echo "obs_id=${obs_id[$task_id]}, job_type=c, timeres=2, freqres=80, edgewidth=80, conversion=uvfits, noflagautos=true, flagdcchannels=true, usepcentre=true" >> /home/nbarry/MWA/manta-ray-client/csv_files/Aug23.csv

  #virtualenv env
  source /home/nbarry/MWA/env/bin/activate

  #mkdi r/fred/oz048/MWA/data/${obs_id[$task_id]}
  python /home/nbarry/MWA/manta-ray-client/mantaray/scripts/mwa_client.py --csv=/home/nbarry/MWA/manta-ray-client/csv_files/Aug23.csv --dir=/fred/oz048/MWA/data/2013/

fi

if [ $j = 1 ]; then
  idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS 2 -e eor_simulation_suite_enterprise
fi


