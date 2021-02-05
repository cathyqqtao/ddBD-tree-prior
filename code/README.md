Getting Started
---------------

To intall `ddBD` on your local machine, please follow the steps:

1. Download `rate.CorrTest` from code directory.
2. In R session, type `setwd(<yout folder location>)` to change the working directory to be the folder that contains `rate.CorrTest` function. 
2. Type `source("ddBD.R")` to activate the funciton.
	
`ddBD` requires 4 external packages: ape and stats4. Install them in advance before using the program. To do so, type the following command inside the R session and follow the instructions to complete the installation: 

	install.packages("ape")
	install.packages("stats4")

To run `ddBD` using the example data, please install the program follow above steps and then follow the following steps:

	setwd("empirical-data")
	t.rt = read.tree("dosReis_Mammals274_RelTime_relTimes.nwk")
	out.tip = c("Ornithorhynchus_anatinus", "Zaglossus_bruijni", "Tachyglossus_aculeatus")
	
	BDpara(t.rt, out.tip, root.time = 1.85)

If you have more questions, please email cathyqqtao@gmail.com (or qiqing.tao@temple.edu).

