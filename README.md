# Towards Bayesian joint modelling of ranks and scores in the assessment of grant proposal quality

**Student:** Alvin Samuel Walker

**Supervision:** Dr. Rachel Heyard, PD Dr. Malgorzata Roos

University of Zürich

November 2026


## Overview

This repository contains the code, figures and report made for the STA495 module "Master Thesis in Biostatistics".

The documents included in this repository are:

- Compiled version of the report, presentation and project plan.
- Quarto file containing the final report and figures.
- Quarto file of presentations.
- Code containing all analyses and generation of figures sorted by model.

## Instruction for use:

1. Access to report
- All compiled documents are available in their compiled folder.

2. Reproducibility
- The code is written in R, and the report in LaTeX. An installation of both these programming languages is
required in order to reproduce the documents generated in this project.
- All documents can be run from their location in the directory directly
(if a document does not compile try setting working directory to the file location).
- Packages used and an installation guide can be found in the section below.

## Package installation

- All R packages are available from CRAN except "INLA"" and "rjags".

- To install INLA, an install.packages() call with a special repository can be used.

- To install rjags, an installation of JAGS is necessary, please follow the instructions on the [JAGS website](https://mcmc-jags.sourceforge.io/)


```r
# Listing required packages
required_packages <- c("reshape2", "pander", "dplyr", "rankrate", "data.table",
                        "psych", "ggplot2", "ggnewscale", "rjags", "coda",
                        "gridExtra", "RColorBrewer")

# Installs all packages
install.packages(required_packages)

# Installs INLA seperately
install.packages("INLA", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)

# Note: For faster installation the argument "ncpus = ..." can be added

```



## Contact

For any questions or inquiries, please contact Alvin Walker at 
[alvin.walker@uzh.ch](alvin.walker@uzh.ch) or [walker.alvi@gmail.com](walker.alvi@gmail.com)