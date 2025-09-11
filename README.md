# ood-cryosparc
This OnDemand [CryoSPARC](https://cryosparc.com/) app launches CryoSPARC (both [master and worker processes](https://guide.cryosparc.com/setup-configuration-and-management/hardware-and-system-requirements#master-worker-pattern)) on a single compute node.

The user must use SSH port forwarding to access the the CryoSPARC master via web browser.

## Prerequisites

* [Slurm cluster](https://osc.github.io/ood-documentation/latest/installation/resource-manager/slurm.html)
* [Apptainer](https://apptainer.org/) or [SingularityCE](https://sylabs.io/singularity/)
* CryoSPARC license
  - https://cryosparc.com/download

## Install

1. After obtaining a [CryoSPARC license](https://cryosparc.com/download), download the master and worker tarballs:
```
version=4.7.1
license_id=...CRYOSPARC_LICENSE_ID...
curl -o cryosparc-master_v${version}.tar.gz -L https://get.cryosparc.com/download/master-v${version}/${license_id} 
curl -o cryosparc-worker_v${version}.tar.gz -L https://get.cryosparc.com/download/worker-v${version}/${license_id} 
```
2. Build the SIF image (from the same working directory as the CryoSPARC master/worker tarballs):

    singularity build --fakeroot cryosparc.sif Singularity.def

## Site-specific modifications

* [form.yml.erb](form.yml.erb) - replace `odyssey3` with a valid cluster OOD cluster configuration name
* [template/script.sh.erb](template/script.sh.erb) - replace `${HOME}/cryosparc.sif` with the path to the cryosparc.sif built in Install step 2
* [template/before.sh.erb](template/before.sh.erb) - (if necessary) replace `find_port localhost 7000 11000` with valid port range in your environment


## Testing

1. Download the test data set to a filesystem accessible from all compute nodes:
```
singularity exec --env CRYOSPARC_DB_PATH=/ --env CRYOSPARC_BASE_PORT=1 cryosparc.sif cryosparcm downloadtest
tar -xf empiar_10025_subset.tar
```
2. Launch the CryoSPARC OOD batch app.
    * The CryoSPARC database path should be on a shared filesystem for persistence after the OOD job terminates.
    * Many CryoSPARC jobs require least 1 GPU.

3. After CryoSPARC is ready, instructions on establishing an SSH tunnel to the specified node/port and accessing via web browser will be shown.

4. [Verify the CryoSPARC Installation with the Extensive Validation Job](https://guide.cryosparc.com/setup-configuration-and-management/software-system-guides/tutorial-verify-cryosparc-installation-with-the-extensive-workflow-sysadmin-guide)
   - In the "Path to Dataset Data" textbox, enter the absolute path to the empiar_10025_subset directory extracted in step 1

## Credits

Kevin Dalton, Milson Munakami, Nathan Weeks
