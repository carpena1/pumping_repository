ahuja tests
contains the files needed to run simulations for the ahuja experiments. 

1. 1 R script per soil type
2. files named ahuja_clay, ahuja_loam, ahuja_SL contain template files to be read by hydrus during the simulation
3. parameters.csv file contains the parameters that were sampled. the R script reads it and runs one simulation per row in the parameters file
4. the resu hig fiteval080625.xlsx contains the best outputs for each type of simulation, and the experimental data for plotting



Cini uncertainty
contains the files needed to run the simulations for testing the initial condition uncertainty for the no pumping (np_h) scenario on Ahuja experiments

1. 1 R script per soil type
2. files named ahuja_clay, ahuja_loam, ahuja_SL contain template files to be read by hydrus during the simulation
3. Cini sampled. csv files provide the initial concentration and are read by the R script to set up the simulations
4. Cini_classpoint.csv files contain the initial concentration value, followed by the final concentration at various depths (for plotting)
5. Cini_class_results,csv files contain the initial concentration and resulting outputs


HavishighR
contains the files needed to run simulations for the ahuja experiments. 

1. 1 R script 
2. files named havisL contains template files to be read by hydrus during the simulation
3. parameters.csv file contains the parameters for the simulation (taken from ahuja loam best simulations). the R script reads it and runs one simulation per row in the parameters file
4. the pumping_results.csv contains the outputs for the parameters in parameters.csv file.
5. the plot_data_havis.xlsx contains the best outputs for each type of simulation, and the experimental data for plotting


Mass_depth_bar
contains data for creating figure 3 (mass and depth of extraction)

Graph Palmer yu depth vs pressure
contains the digitized data from Palmer and Yu articles.