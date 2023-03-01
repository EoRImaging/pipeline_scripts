#!/bin/bash

####################################################
#
# PIPE_QUEUE.SH
#
# Top level script to run a list of observation IDs through FHD (deconvolution or firstpass),
# check the status of resulting FHD outputs, rerun specific observation IDs as necessary
# with new resource allocations, integrate cubes, and generate power spectra through 
# eppsilon.
#
# Required input arguments are obs_file_name (-f /path/to/obsfile) and version
# (-v yourinitials_jackknife_test)
#
# Optional input arguments are: outdir (-o /path/to/output/directory) which is defaulted to 
# your home directory, wallclock_time (-w 08:00:00) which is defaulted to 
# 3 hours for a typical firstpass run, mem (-m 4gb) which is defaulted to 
# 40 Gigabytes for a typical firstpass run, and queue (-q q8) which is defaulted to q8
#
# WARNING!
# Terminal will hang as it waits for jobs to finish, and closing the terminal will kill any 
# remaining jobs! To run in the background, run: 
# nohup ./pipe_slurm.sh -f /path/to/obsfile -v yourinitials_jackknife_test > /path/to/your/output/log/file.txt &
#
####################################################

Help()
{  
   # Display Help
   echo "Script to submit FHD jobs into the NAOJ queue"
   echo
   echo "Syntax: nohup ./pipe_slurm.sh [-f -o -v -w -q -m -H] >> ~/log.txt &"
   echo "options:"
   echo "-f (text file of observation id's, required)," 
   echo "-o (output directory, default:~/),"
   echo "-v (version input for FHD, required, i.e. foo creates output folder named fhd_foo),"
   echo "-w (wallclock time, default:3:00:00),"
   echo "-q (queue to use, default:q8, options:q1,q4,q8,q16),"
   echo "-m (memory allocation, default:40gb)."
   echo "-H (hold run till specified jobid is finished, optional)." 
   echo
}


#######Gathering the input arguments and applying defaults if necessary

#Parse flags for inputs
#while getopts ":f:s:e:o:v:p:w:n:m:t:" option
while getopts ":f:o:v:w:q:m:H:h" option
do
   case $option in
	f) obs_file_name="$OPTARG";;	#text file of observation id's
        o) outdir=$OPTARG;;		#output directory for FHD output folder
        v) version=$OPTARG;;		#FHD folder name and case for firstpass_versions_wrapper
					#Example: nb_foo creates folder named fhd_nb_foo
	w) wallclock_time=$OPTARG;;	#Time for execution in slurm
	q) queue=$OPTARG;;		#Which PBS queue to use on NAOJ cluster
	m) mem=$OPTARG;;		#Memory per node for slurm
        H) hold=$OPTARG;;  
        h) Help
           exit 1;;
	\?) echo "Unknown option. Please review accepted flags"
            Help
	    exit 1;;
	:) echo "Missing option argument for input flag"
	   exit 1;;
   esac
done

#Manual shift to the next flag.
shift $(($OPTIND - 1))

#Throw error if no obs_id file.
if [ -z ${obs_file_name} ]; then
   echo "Need to specify a full filepath to a list of viable observation ids."
   exit 1
fi

#Set default output directory if one is not supplied and update user
if [ -z ${outdir} ]
then
    outdir=~/
    echo Using default output directory: $outdir
else
    #strip the last / if present in output directory filepath
    outdir=${outdir%/}
    echo Using output directory: $outdir
fi

#Use default version if not supplied.
if [ -z ${version} ]; then
   echo Please specify a version, e.g, yourinitials_test
   exit 1
fi

#Set typical wallclock_time for standard FHD firstpass if not set.
if [ -z ${wallclock_time} ]; then
    wallclock_time=3:00:00
fi
if [ -z ${queue} ]; then
    queue=q8
fi
#Set typical memory needed for standard FHD firstpass if not set.
if [ -z ${mem} ]; then
    mem=40gb
fi
# create hold string
if [ -z ${hold} ]; then hold_str=""; else hold_str="--dependency=afterok:${hold}"; fi

#Make directory if it doesn't already exist
mkdir -p ${outdir}/fhd_${version}
mkdir -p ${outdir}/fhd_${version}/grid_out
echo Output located at ${outdir}/fhd_${version}

#Read the obs file and put into an array, skipping blank lines if they exist
i=0
while read line
do
   if [ ! -z "$line" ]; then
      obs_id_array[$i]=$line
      i=$((i + 1))
   fi
done < "$obs_file_name"

#Create a list of observations for the submit script. 
unset good_obs_list
for obs_id in "${obs_id_array[@]}"; do
     good_obs_list+=($obs_id)
done

#######End of gathering the input arguments and applying defaults if necessary




#######Submit the firstpass job and wait for output

#Find the number of obsids to run in array
nobs=${#good_obs_list[@]}
nobs=$(( $nobs - 1 ))

#Run a task array if there is more than one observation
if [[ "$nobs" -eq 0 ]]
then
     message=$(qsub -N FHD -l ncpus=1,mem=$mem,walltime=$wallclock_time -V -v outdir=$outdir,version=$version,obs_id_array=${good_obs_list} -e ${outdir}/fhd_${version}/grid_out -o ${outdir}/fhd_${version}/grid_out -q $queue ./pipe_queue_submit_job.sh)
else
     message=$(qsub -N FHD -J 0-$nobs:1 -V -v outdir=$outdir,version=$version,obs_id_array=${good_obs_list[@]} -e ${outdir}/fhd_${version}/grid_out -o ${outdir}/fhd_${version}/grid_out -q $queue -l ncpus=1,mem=$mem,walltime=${wallclock_time} ./pipe_queue_submit_job.sh)
fi

#Run the command
message=($message)

echo ${message[@]}

#Gather the job id from the job for later use

##
id=`echo ${message[0]}`
echo $id

while [ `qstat -u $(whoami) | grep $id | wc -l` -ge 1 ]; do
    sleep 10
done

########End of submitting the firstpass job and waiting for output

#./ps_queue.sh -f $obs_file_name -d $outdir/fhd_$version
#echo "Cube integration and PS submitted"
