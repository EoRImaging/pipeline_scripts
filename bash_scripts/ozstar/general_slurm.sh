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
j=2

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

module purge
module load gcc/6.4.0 openmpi/3.0.0
module load scalapack/2.0.2-openblas-0.2.20
module load lapack/3.8.0
module load hdf5/1.10.1
module load cmake/3.10.2
module load cfitsio/3.450
module load fftw/3.3.7
module load boost/1.66.0-python-2.7.14

    /fred/oz048/MWA/CODE/cotter/build/cotter -absmem 20 -j 4 -timeres 2 -freqres 80 -edgewidth 80 -usepcentre -initflag 2 -noflagautos -norfi -flagfiles /fred/oz048/MWA/data/2013/1064761888_gpubox/1064761888_%%.mwaf -o /fred/oz048/MWA/data/2013/1064761888_gpubox/1064761888.uvfits -m /fred/oz048/MWA/data/2013/1064761888_gpubox/1064761888.metafits /fred/oz048/MWA/data/2013/1064761888_gpubox/*gpubox*.fits
  #idl -IDL_DEVICE ps -IDL_CPU_TPOOL_NTHREADS 2 -e eor_simulation_suite_enterprise
fi

if [ $j = 2 ]; then

/fred/oz048/jline/run_CHIPS/run_CHIPS.py --obs_list=/home/nbarry/MWA/FHD/obs_list/1061311664.txt \
  --data_dir=/fred/oz048/MWA/CODE/FHD/fhd_nb_data_BH2grid_BH2degrid_GLEAMtenth_Z/CHIPS_input \
  --uvfits_dir='/' \
  --uvfits_tag='uv_model_' \
  --output_tag=FHD_model_1664_hdr7 \
  --band=high --obs_range=0,1 --no_delete \
  --field=0 --timeres=2.0 --base_freq=167.075e+6 --freqres=80000

fi

if [ $j = 3 ]; then


#python /home/nbarry/MWA/MWA_data_analysis/CHIPS_scripts/uvfits_convert.py -c 0 -e 1 -s RTS_compare -o ~/MWA/FHD/obs_list/Aug23_longrunstyle.txt
#python /home/nbarry/MWA/MWA_data_analysis/CHIPS_scripts/uvfits_convert.py -c 1 -e 0 -o ~/MWA/FHD/obs_list/Aug23_longrunstyle.txt -d 1 -m 1
python /home/nbarry/MWA/MWA_data_analysis/CHIPS_scripts/uvfits_convert.py -c 1 -e 0 -s fhd_nb_data_BH2grid_BH2degrid_GLEAMtenth_Z -o ~/MWA/FHD/obs_list/btl_noalltv_noocc4.txt -d 1 -m 1
fi
