# Supplementary Materials
## Mechanistic modeling of the impact of rainfall pumping on soil solute remobilization into runoff
**By Lucie Guertault and R. Muñoz-Carpena**

*Under review in HESS journal, June 2026*

This repository contains the supplementary simulation files and data associated with the manuscript submitted to HESS.

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
