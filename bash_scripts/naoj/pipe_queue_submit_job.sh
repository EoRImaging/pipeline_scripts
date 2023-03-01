#! /bin/bash
#############################################################################
#Runs one observation at a time in PBS scheduler.  Second level program for 
#running firstpass on the NAOJ cluster. First level program is 
#pipe_queue.sh
#############################################################################

#PBS -V
#PBS -m n

# obs_id, outdir, and version are expected to be passed from qsub call
# in pipe_queue.sh

echo JOBID ${PBS_JOBID}
if [ -z ${PBS_ARRAY_INDEX} ]; then
    obs_id=${obs_id_array}
else
    obs_id=${obs_id_array[$PBS_ARRAY_INDEX]}
    echo TASKID ${PBS_ARRAY_INDEX}
fi

echo $outdir
echo $version
echo $obs_id

/usr/local/harris/idl88/bin/idl -IDL_DEVICE ps -quiet -IDL_CPU_TPOOL_NTHREADS 1 -e my_run_script -args $obs_id $outdir $version 

if [ $? -eq 0 ]
then
    echo "Finished"
    exit 0
else
    echo "Job Failed"
    exit 1
fi

