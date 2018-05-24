# pipeline_scripts
Scripts and wrappers for running FHD and eppsilon

## simulation 
    sim_pipe_slurm.sh  -- Wrapper script for submitting batch simulation jobs using slurm, accepting a list of ObsIDs.
    eor_simulation_slurm_job.sh -- The slurm jobscript.
    sim_versions_wrapper.pro -- Individual simulation settings determined by a ''version'' string.
    locate_uvfits_oscar.py -- Python script for finding uvfits files for a given ObsID on the Oscar cluster at Brown.
