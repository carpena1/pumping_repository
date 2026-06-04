# Supplementary Materials
## Mechanistic modeling of the impact of rainfall pumping on soil solute remobilization into runoff
**By Lucie Guertault and R. Muñoz-Carpena**

*Under review in HESS journal, June 2026*

This repository contains the supplementary simulation files and data associated with the manuscript submitted to HESS.

---

## Note on running the R scripts with Hydrus-1D

Prior to running the R script, the Hydrus executable file H1D_CALC.EXE must be added to the same folder where the R script is following these instructions:

1. The EXE file can be obtained at https://www.pc-progress.com/en/Default.aspx?Downloads.
2. Download the Hydrus1D_4.17.0140.exe and install it in your computer. The executable file H1D_CALC.EXE will be found in the installation folder.
3. Copy the file and place them in the same folder as the R script that you intend to run.

A place holder file "H1D_CALC_EXE_HERE.txt" has been placed in the folders described below where you should place the H1D_CALC.EXE before running the scripts.

---

## Contents

### `ahuja_tests/`

Files needed to run simulations for the Ahuja experiments.

1. One R script per soil type
2. Folders `ahuja_clay`, `ahuja_loam`, `ahuja_SL` contain template files read by HYDRUS during the simulation
3. `parameters.csv` — sampled parameters; the R script reads this file and runs one simulation per row
4. `resu_hig_fiteval080625.xlsx` — best outputs for each simulation type and experimental data for plotting

---

### `Cini_uncertainty/`

Files needed to run simulations testing initial condition uncertainty for the no-pumping (`np_h`) scenario on the Ahuja experiments.

1. One R script per soil type
2. Folders `ahuja_clay`, `ahuja_loam`, `ahuja_SL` contain template files read by HYDRUS during the simulation
3. `Cini_sampled.csv` — initial concentration values read by the R script to set up simulations
4. `Cini_classpoint.csv` — initial concentration followed by final concentration at various depths (for plotting)
5. `Cini_class_results.csv` — initial concentration and resulting outputs

---

### `havishighR/`

Files needed to run simulations for the Havis experiments at high R.

1. One R script
2. Folder `havisL` contains template files read by HYDRUS during the simulation
3. `parameters.csv` — simulation parameters (taken from Ahuja loam best simulations); the R script reads this and runs one simulation per row
4. `pumping_results.csv` — outputs for the parameters in `parameters.csv`
5. `plot_data_havis.xlsx` — outputs and experimental data for plotting

---

### `Mass_depth_Bar.xlsx`

Data for creating Figure 3 (mass and depth of extraction).

---

### `graph palmer yu depth vs pressure.xlsx`

Digitized data from Palmer and Yu articles.
