#R Script to calculate boundary condition for pumping and run R
#boundary condition pressure fluctuations at surface caused
#by rainfall pumping and microtopography
#sources: higashino 2014, Elliot Brooks 1997

rm(list=ls(all=TRUE)) #clear memory

#calculation runoff depth, manning equation
n=0.02
B=0.15 #m
Q=0.00000283 #m3/s
S=0.04 #m/m
K=1

uniform.depth=function(yn){
  K/n*(((B*yn)^(5/3)*S^0.5)/((B+2*yn)^(2/3)))-Q
}

yn=as.numeric(uniroot(uniform.depth,c(0,3))[1])






# ***************************************************************
#assign columns to variables
# ***************************************************************
R=68 #rainfall mm/h
d=0.0004 #m runoff depth

# ***************************************************************
#declare constants + simulation parameters
# ***************************************************************
g=9.81 #m/s^-2
tmax=3600 #s
time=seq(0,tmax,1) #s
n=length(time)

  #-----------------------------
  #Calculate Htop
  #-----------------------------
  #calculation rainfall pumping higashino
  #ho=w2*1/(2gd)*V^2
i=1
  
  W2=(7.12*R[i]^0.77)*10^(-9) #m^3 
  
  V=9.65-10.3*((4.1/(R[i]^0.21))^4)/((0.6+4.1/R[i]^0.21)^4) #m/s
  #V=9.65 - 22457.8/(R^0.21 + 6.83333)^4 #simplified form
  
  ho=W2*1/(2*g)*V^2/d[i] #m
  #check for R=100 mm/h, d=2 cm article says ho=3.0e-5 m
  Tr=0.0256/(R[i]^0.23) #s 
  
  #head
  hrain=ho*sin(2*pi*time/Tr) # m
  

  #add the two sin functions
  htop=hrain+d[i] #m
  
write.csv(htop,'htop_ahuja.csv')