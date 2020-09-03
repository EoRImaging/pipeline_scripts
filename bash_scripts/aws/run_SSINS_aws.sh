#!/bin/bash

while getopts ":f:o:b:n:p:t:c:" option
do
  case $option in
    f) obs_file_name="$OPTARG";;
    o) outdir=$OPTARG;;
    b) s3_path=$OPTARG;;
    n) nslots=$OPTARG;;
    p) input_s3_loc=$OPTARG;;
    t) input_type=$OPTARG;;
    c) correct=$OPTARG;;
    \?) echo "Unknown option: Accepted flags are -f (obs_file_name), -o (output directory), "
        echo "-b (output bucket on S3),  -n (number of slots to use), "
        echo "-p (path to input files on S3), -t (type of input file), -c (whether to correct digital things)"
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
if [ -z ${outdir} ];
then
    outdir=/SSINS_output
    echo Using default output directory: $outdir
else
    #strip the last / if present in output directory filepath
    outdir=${outdir%/}
    echo Using output directory: $outdir
fi

if [ -z ${input_type} ]; then
  input_type=uvfits
elif [[ ${input_type} != "uvfits" && ${input_type} != "gpubox" ]]; then
  echo "${input_type} is not a valid input type. Valid options are 'uvfits' or 'gpubox'"
  exit 1
fi

if [ -z ${input_s3_loc} ]; then
  if [ ${input_type} == "uvfits"]; then
    input_s3_loc=s3://mwapublic/uvfits/4.1
  else
    input_s3_loc=s3://mwapublic/gpubox
  fi
else
    #strip the last / if present in uvfits filepath
    input_s3_loc=${input_s3_loc%/}
fi

if [ -z ${s3_path} ]
then
    s3_path=s3://mwa-data/rfi_ps_simulations
    echo Using default S3 location: $s3_path
else
    #strip the last / if present in output directory filepath
    s3_path=${s3_path%/}
    echo Using S3 bucket: $s3_path
fi

if [ -z $correct ]; then
  correct=0
else
  correct=1
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

qsub -V -b y -cwd -v obs_file_name=${obs_file_name},nslots=${nslots},outdir=${outdir},s3_path=${s3_path},input_s3_loc=${input_s3_loc},input_type=${input_type},correct=${correct} -e ${logdir} -o ${logdir} -pe smp ${nslots} -sync y -t 1:${N_obs} SSINS_job_aws.sh &
