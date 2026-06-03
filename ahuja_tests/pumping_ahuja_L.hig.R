#simulate ahuja clay experiment using hydrus template files
#reads parameter file for inverse optimization pumping
#calculate boundary condition for pumping and run R
#boundary condition pressure fluctuations at surface caused
#by rainfall pumping and microtopography
#sources: ahuja 1983 higashino 2014, Elliot Brooks 1997

rm(list=ls(all=TRUE)) #clear memory

#install and load packages
#install.packages(c('here','stringi'))
library(here)
library(stringi)

#experimental data loam
deptha=c(-0.09,-0.22,-0.71,-1.5,-2.5,-3.5,-4.5)
conca=c(0.000790, 0.00222,0.00347,0.00411,0.00489,0.00469,0.00445)

#name of parameter file
#para.filename='parameters_ahuja.csv'
para.filename='plotL.csv'

#name of hydrus folder with reference files to copy
hydrus.filename='ahuja_loam'

#create hydrus subfolder in the folder
dir.create(here('hydrus'), showWarnings = FALSE)


# ***************************************************************
#read parameter file from Morris Sampling
# ***************************************************************
parameters=read.csv(here(para.filename))

# ***************************************************************
#assign columns to variables
# ***************************************************************
d=parameters[,1]
disp=parameters[,2] #dispersivity
thetar=parameters[,3] # residual water content
alpha=parameters[,4] #alpha VG
ns=parameters[,5] #n VG
Ksat=parameters[,6] # saturated hydraulic conductivity


# ***************************************************************
#declare constants + simulation parameters
# ***************************************************************
tmax=3660 #s
time=seq(0,tmax,0.1) #s
n=length(time)


# ***************************************************************
#declare vectors to store pumping stats for each simulation
# ***************************************************************
# ***************************************************************
#LOOP that calculates Htop for each sample of variables,
#creates a folder for hydrus tests
#copies input files from reference simulation
#writes the HYDRUS ATMOSPH file
#runs Hydrus
# ***************************************************************

for (i in 1:nrow(parameters)){
  
  #-----------------------------
  #Calculate Htop
  #-----------------------------
  #rain
  R=68
  g=9.81
  W2=(7.12*R^0.77)*10^(-9)*100 #m^3/s
  
  V=9.65-10.3*((4.1/(R^0.21))^4)/((0.6+4.1/R^0.21)^4) #m/s
  #V=9.65 - 22457.8/(R^0.21 + 6.83333)^4 #simplified form
  
  ho=W2*1/(2*g)*V^2/d[i] #m
  #check for R=100 mm/h, d=2 cm article says ho=3.0e-5 m
  Tr=2.56/(R^0.23) #s 
  
  #head
  hrain=ho*sin(2*pi*time/Tr) # m
  
  #htop
  htop=d[i]+hrain
	#update first time for hydrus
	time[1]=0.05

	#create table of inputs for hydrus ATMOSPH file
	table=cbind(time,rep(0,n),rep(0,n),rep(0,n),rep(0,n),rep(0,n),rep(0,n),round(htop*100,4),rep(0,n),rep(0,n),rep(0,n),rep(0,n),rep(0,n))


	#-----------------------------
	#Prepare hydrus simulations: create subfolder for simulation, copy input files, create new Atmosph file
	#-----------------------------
	#set the different path names
	wd2=file.path(here(),'hydrus') #folder where one subfolder is created by simulation inputs/outputs files are stored
	wd3=file.path(here(),hydrus.filename) #folder where reference simulation is
	
	
	#create a subfolder to store hydrus input and output files for the simulation 
	dir.create(paste(wd2,'/test',i,sep=''), showWarnings = FALSE)
	
	#list the .IN and .DAT files in the reference simulation and copy them to the new folder
	list_of_files <-c(list.files(wd3, ".IN"), list.files(wd3, ".DAT"))
	file.copy(from=file.path(wd3,list_of_files),to=paste0(wd2,'/test',i))
	
	#also copy the hydrus exe exe
	file.copy(from=here('H1D_CALC.exe'),to=paste0(wd2,'/test',i))
	
	#go to the new folder, and create a new input file for Atmosph (top BC)
	wd4=(file.path(wd2, paste('test',i,sep=''))) #create path
	file.remove(file.path(wd4,"ATMOSPH.IN")) #delete original file
	file.create(file.path(wd4,"ATMOSPH.IN")) #create a new one
	
	#connect to input file AtMOSPH
	fileConn<-file(file.path(wd4,"ATMOSPH.IN"))
	
	#format the table with inputs in ATMOSPH
	table.lines=c()
	for (j in 1:nrow(table)){
	  table.lines=c(table.lines,stri_join(table[j,],collapse='   '))
	} #this loop creates a vector with one character string per row of data in table,
	#separated by spaces
	
	#add header for file,and combine with data
	lines.to.write=c("Pcp_File_Version=4","*** BLOCK I: ATMOSPHERIC INFORMATION  **********************************",
	                 '   MaxAL                    (MaxAL = number of atmospheric data-records))',
	                 '   3661',
	                 ' DailyVar  SinusVar  lLay  lBCCycles lInterc lDummy  lDummy  lDummy  lDummy  lDummy',
	                 '   f       f       f       f       f       f       f       f       f       f',
	                 ' hCritS                 (max. allowed pressure head at the soil surface)',
	                 '   0',
	                 ' tAtm        Prec       rSoil       rRoot      hCritA          rB          hB          ht        tTop        tBot        Ampl        cTop        cBot   RootDepth',
	                 table.lines,"end*** END OF INPUT FILE 'ATMOSPH.IN' **********************************")
	
	#write data in file
	writeLines(lines.to.write, fileConn)
	
	#close connection to file
	close(fileConn)
	
	
	
	
	
	#go to the new folder, and create a new input file for SELECTOR (soil properties)
	file.remove(file.path(wd4,"SELECTOR.IN")) #delete original file
	file.create(file.path(wd4,"SELECTOR.IN")) #create a new one
	
	#connect to input file SELECTOR
	fileConn2<-file(file.path(wd4,"SELECTOR.IN"))
	
	#format the table with inputs in SELECTOR
	#add header for file,and combine with data
	lines.to.write2=c("Pcp_File_Version=4"
	                  ,"*** BLOCK A: BASIC INFORMATION *****************************************"
	                  ,"Heading"
	                  ,"Welcome to HYDRUS-1D"
	                  ,"LUnit  TUnit  MUnit  (indicated units are obligatory for all input data)"
	                  ,"cm"
	                  ,"sec"
	                  ,"g"
	                  ,"lWat   lChem lTemp  lSink lRoot lShort lWDep lScreen lVariabBC lEquil lInverse"
	                  ," t     t     f      f     f     f      f     t       t         t         f"
	                  ,"lSnow  lHP1   lMeteo  lVapor lActiveU lFluxes lIrrig  lDummy  lDummy  lDummy"
	                  ," f       f       f       f       f       t       f       f       f       f"
	                  ,"NMat    NLay  CosAlpha"
	                  ,"  1       1       1"
	                  ,"*** BLOCK B: WATER FLOW INFORMATION ************************************"
	                  ,"MaxIt   TolTh   TolH       (maximum number of iterations and tolerances)"
	                  ,"  10    0.001      1"
	                  ,"TopInf WLayer KodTop InitCond"
	                  ," t     f       1       t"
	                  ,"BotInf qGWLF FreeD SeepF KodBot DrainF  hSeep"
	                  ," f     f     f     f     -1      f      0"
	                  ,"         rTop         rBot        rRoot"
	                  ,"           0            0            0"
	                  ,"    hTab1   hTabN"
	                  ,"    1e-006   10000"
	                  ,"    Model   Hysteresis"
	                  ,"      0          0"
	                  ,"   thr     ths    Alfa      n         Ks       l"
	                  ,stri_join(c(thetar[i],0.49,alpha[i],ns[i],Ksat[i],0.5),collapse='   ')
	                  ,"*** BLOCK C: TIME INFORMATION ******************************************"
	                  ,"        dt       dtMin       dtMax     DMul    DMul2  ItMin ItMax  MPL"
	                  , "        0.01        0.005      432000     1.3     0.7     3     7     3"
	                  , "      tInit        tMax"
	                  , "          0        3660"
	                  ,"  lPrintD  nPrintSteps tPrintInterval lEnter"
	                  , "     f           1         86400       f"
	                  , "TPrint(1),TPrint(2),...,TPrint(MPL)"
	                  , "  1        1800        3660 "
	                  , "*** BLOCK F: SOLUTE TRANSPORT INFORMATION *****************************************************"
	                  , " Epsi  lUpW  lArtD lTDep    cTolA    cTolR   MaxItC    PeCr  No.Solutes  lTort   iBacter   lFiltr  nChPar"
	                  , "  0.5     f     f     f         0         0     1        2        1       t       0        f       16"
	                  , "iNonEqul lWatDep lDualNEq lInitM  lInitEq lTort lDummy  lDummy  lDummy  lDummy  lCFTr"
	                  , "   0       f       f       f       f       f       t       f       f       f       f"
	                  , "     Bulk.d.     DisperL.      Frac      Mobile WC (1..NMat)"
	                  , stri_join(c(1.42,disp[i],1,0),collapse='   ')
	                  , "         DifW       DifG                n-th solute"
	                  , "     1.85e-005           0 "
	                  , "         Ks          Nu        Beta       Henry       SnkL1       SnkS1       SnkG1       SnkL1'      SnkS1'      SnkG1'      SnkL0       SnkS0       SnkG0        Alfa"
	                  ,"          0           0           1           0           0           0           0           0           0           0           0           0           0           0 "
	                  ,"      kTopSolute  SolTop    kBotSolute  SolBot"
	                  ,"          1           0           0           0 "
	                  , "      tPulse"
	                  , "       0"
	                  , "*** END OF INPUT FILE 'SELECTOR.IN' ************************************")
	#write data in file
	writeLines(lines.to.write2, fileConn2)
	
	#close connection to file
	close(fileConn2)
	
	#for PC
	system2(file.path(here(),'H1D_CALC.exe'),wd4)
	
	

	
	# # Run hydrus simulation
	# testdir <- paste0("hydrus/test",i)
	# # run with wine 4.0
	# #command = paste0("/apps/apptainer/latest/apptainer exec /apps/wine/4.0/sandbox wine ", here(), "/H1D_CALC.EXE ", testdir,  " | tee ", testdir, "/tee_output.log")
	# # run with wine 7.0
	# command = paste0("/apps/apptainer/latest/apptainer exec /apps/ubuntu/20.04/container wine ", here(), "/H1D_CALC.EXE ", testdir,  " | tee ", testdir, "/tee_output.log")
	# print(command)
	# system(command)
	# print(paste0("command complete, ", testdir, "/tee_output.log written")) 	
	# 
}
#END LOOP


#-----------------------------
#create summary file with properties of the pumping signal for further analysis
#-----------------------------

# ***************************************************************
#calculate mass remaining in soil for each test: total profile and top 2 cm 
# ***************************************************************
#create empty vector to store the mass in soil for each simulation (final time step) and find NSE
mass=c()
mass2cm=c()
mass.ini=c()
mass2cm.ini=c()
NSE=c()


#for loop over the number of tests
for (i in 1:nrow(parameters)){
  
  #read Nod Inf file with profile outputs
  wd5=paste0(here(),'/hydrus/test',i)
  data=read.table(file.path(wd5,'Nod_Inf.out'),sep='',fill = TRUE,skip=6)
  
  
  #find the number of times output profiles were saved and the corresponding times
  ind.time=which(data[,1]=='Time:') #position of Time in file
  ind.end=which(data[,1]=='end') #position of end of data table for a given Time in file
  times=data[ind.time,2] #values of the times
  
  
  # ***************************************************************
  #calculate initial mass in soil 
  # ***************************************************************
  ind.first=ind.time[1]+3  #row of start of the data table
  ind.last=ind.end[1]-1 # row of end of data table
  
  depth=as.numeric(data[ind.first:ind.last,2]) #get depths
  theta=as.numeric(data[ind.first:ind.last,4]) #get soil moisture
  conc=as.numeric(data[ind.first:ind.last,12]) #get concentrations
  
  mass.ini[i]=0 #set mass to zero
  
  
  #for loop to integrate using trapezoidal rule
  for (j in 2:length(depth)){ #loop over number of depths in profile
    mass.ini[i]=mass.ini[i]+(conc[j]*theta[j]+conc[j-1]*theta[j-1])/2*abs(depth[j]-depth[j-1]) #add incremental mass for each depth
  }
  
  
  # ***************************************************************
  #calculate initial mass in soil top 2 cm
  # ***************************************************************
  depth.all=as.numeric(data[ind.first:ind.last,2]) #get depths
  ind2cm=which(depth.all==-2)#find position of depth at -2cm, which will be the end of our selection
  
  depth2=as.numeric(data[ind.first:(ind.first+ind2cm-1),2]) #get depths
  theta2=as.numeric(data[ind.first:(ind.first+ind2cm-1),4]) #get soil moisture
  conc2=as.numeric(data[ind.first:(ind.first+ind2cm-1),12]) #get concentrations
  
  mass2cm.ini[i]=0 #set mass to zero
  
  #for loop to integrate using trapezoidal rule
  for (j in 2:length(depth2)){ #loop over number of depths in profile
    mass2cm.ini[i]= mass2cm.ini[i]+(conc2[j]*theta2[j]+conc2[j-1]*theta2[j-1])/2*abs(depth2[j]-depth2[j-1]) #add incremental mass for each depth
  }
  
  
  # ***************************************************************
  #calculate final mass in soil 
  # ***************************************************************
  
  #calculate the mass in soil, using data recorded at the last time 
  ind.first=ind.time[length(ind.time)]+3  #row of start of the data table
  ind.last=ind.end[length(ind.end)]-1 # row of end of data table
  depth=as.numeric(data[ind.first:ind.last,2]) #get depths
  theta=as.numeric(data[ind.first:ind.last,4]) #get soil moisture
  conc=as.numeric(data[ind.first:ind.last,12]) #get concentrations
  mass[i]=0 #set mass to zero
  
  #for loop to integrate using trapezoidal rule
  for (j in 2:length(depth)){ #loop over number of depths in profile
    mass[i]=mass[i]+(conc[j]*theta[j]+conc[j-1]*theta[j-1])/2*abs(depth[j]-depth[j-1]) #add incremental mass for each depth
  }
  
  # ***************************************************************
  #calculate final mass in soil top 2 cm
  # *************************************************************** 
  depth.all=as.numeric(data[ind.first:ind.last,2]) #get depths
  ind2cm=which(depth.all==-2)#find position of depth at -2cm, which will be the end of our selection
  
  depth2=as.numeric(data[ind.first:(ind.first+ind2cm-1),2]) #get depths from 0 to -2cm
  theta2=as.numeric(data[ind.first:(ind.first+ind2cm-1),4]) #get soil moisture from 0 to -2cm
  conc2=as.numeric(data[ind.first:(ind.first+ind2cm-1),12]) #get concentrations from 0 to -2cm
  
  mass2cm[i]=0 #set mass to zero
  
  #for loop to integrate using trapezoidal rule
  for (j in 2:length(depth2)){ #loop over number of depths in profile
    mass2cm[i]=mass2cm[i]+(conc2[j]*theta2[j]+conc2[j-1]*theta2[j-1])/2*abs(depth2[j]-depth2[j-1]) #add incremental mass for each depth
  }
  
  
  
  
  
  
  # ***************************************************************
  #calculate NSE
  # ***************************************************************
  
  conc.m=approx(depth,conc,deptha)$y
  
  
  NSE[i]=1-sum((conca-conc.m)^2)/sum((conca-mean(conca))^2)
  
  
  
}



# ***************************************************************
#write file with results
# ***************************************************************  

resu.mat=cbind(mass,mass2cm,mass.ini,mass2cm.ini,mass.ini-mass,mass2cm.ini-mass2cm,NSE)



colnames(resu.mat)<-c('final mass in soil (g.cm2)','final mass in soil top 2cm (g.cm2)','initial mass in soil (g.cm2)','initial mass in soil top 2cm (g.cm2)','mass.out','mass.out 2cm','NSE')

write.csv(resu.mat,here('pumping_results.csv'))
