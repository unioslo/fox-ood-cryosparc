# CryoSPARC for Open OnDemand

This project provides an [Open OnDemand](https://openondemand.org/) app for launching and managing [CryoSPARC](https://cryosparc.com/) sessions on a Slurm-based HPC cluster.  
It is designed for the **[Fox](https://www.uio.no/english/services/it/research/hpc/fox/index.html)** cluster at the **[University of Oslo (UiO)](https://www.uio.no/english/)** but can be adapted for similar systems.

> **Based on:** [Harvard University FASRC’s Open OnDemand CryoSPARC integration](https://github.com/fasrc/ood-cryosparc) (thanks!)  
> **Enhancements by UiO/Fox:** Dynamic partition selection via a CryoSPARC cluster lane.

---

## Overview

CryoSPARC is started as a **main instance** (database and web server) within an Open OnDemand session on a **CPU-only partition**, while individual CryoSPARC jobs are dynamically submitted to **CPU or GPU partitions** depending on their hardware requirements.

---

## Features

-  Launches a CryoSPARC web interface (master + database) via an Open OnDemand interactive session.  
-  Runs the master on a **CPU partition** to conserve GPU resources.  
-  Supports job submission through Slurm to:
  - CPU-only partitions (for preprocessing, etc.)
  - GPU partitions (for reconstruction and refinement jobs)  
-  Uses `cluster_info.json` and a templated submit script to direct jobs to the correct Slurm partitions automatically.

---

## Architecture

1. **OOD Session Launch**
   - The user starts a CryoSPARC session through Open OnDemand.  
   - A Slurm job is submitted to a **CPU partition** to run:
     - CryoSPARC master process  
     - MongoDB database  
     - Web interface (accessible via OOD)

2. **CryoSPARC Job Submission**
   - CryoSPARC submits jobs via its `cluster_info.json` configuration.
   - The submit script dynamically selects the correct partition based on job type:
     - GPU jobs → `gpu` partition  
     - CPU-only jobs → `cpu` partition  
   - This selection is handled transparently through templated SBATCH directives and substitution variables.

3. **Session Lifecycle**
   - The CryoSPARC master runs within the OOD session’s Slurm allocation.
   - All user jobs are submitted as separate Slurm jobs through CryoSPARC.
   - When the OOD session ends, the CryoSPARC master and database is killed.

