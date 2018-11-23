#!/bin/bash

while getopts ":f:o:b:n:p:q:r:" option
do
  case $option in
    f) obs_file_name="$OPTARG";;
    o) outdir=$OPTARG;;
    b) s3_path=$OPTARG;;
    n) nslots=$OPTARG;;
    p) uvfits_s3_loc=$OPTARG;;
    q) script=$OPTARG;;
    r) script_args=$OPTARG;;
    \?) echo "Unknown option: Accepted flags are -f (obs_file_name), -o (output directory), "
        echo "-b (output bucket on S3),  -n (number of slots to use), "
        echo "-p (path to uvfits files on S3), -q (python script to execute),"
        echo "-r (options for python script)."
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
    outdir=/SSINS_output
    echo Using default output directory: $outdir
else
    #strip the last / if present in output directory filepath
    outdir=${outdir%/}
    echo Using output directory: $outdir
fi

if [ -z ${uvfits_s3_loc} ]; then
    uvfits_s3_loc=s3://mwapublic/uvfits/4.1
else
    #strip the last / if present in uvfits filepath
    uvfits_s3_loc=${uvfits_s3_loc%/}
fi

if [ -z ${s3_path} ]
then
    s3_path=s3://mw-mwa-ultra-faint-rfi
    echo Using default S3 location: $s3_path
else
    #strip the last / if present in output directory filepath
    s3_path=${s3_path%/}
    echo Using S3 bucket: $s3_path
fi

logdir=~/grid_out

#Set typical slots needed for standard FHD firstpass if not set.
if [ -z ${nslots} ]; then
    nslots=10
fi

#Make directory if it doesn't already exist
sudo mkdir -p -m 777 ${outdir}/grid_out
echo Output located at ${outdir}

N_obs=$(wc -l < $obs_file_name)

qsub -V -b y -cwd -v obs_file_name=${obs_file_name},nslots=${nslots},outdir=${outdir},s3_path=${s3_path},uvfits_s3_loc=$uvfits_s3_loc,script=$script,script_args=$script_args -e ${logdir} -o ${logdir} -pe smp ${nslots} -sync y -t 1:${N_obs} SSINS_job_aws.sh &
