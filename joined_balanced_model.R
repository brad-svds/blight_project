
test <- read.csv("test.csv")
test2 <- read.csv("test2.csv")
test3 <- read.csv("test3.csv")
test4 <- read.csv("test4.csv")

master <- rbind(test, test2, test3, test4)
write.csv(master, file = "blight_master.csv")

master_true <- master[master$NBR_MATCH == "True", ]
master_false <- master[master$NBR_MATCH == "False", ]

#Binning the TRUEs
lat_cuts <- cut(master_true$LAT, 10)
lon_cuts <- cut(master_true$LON, 10)
lat_cuts <- as.numeric(unique( sub("\\((.+),.*", "\\1", lat_cuts)))
lon_cuts <- as.numeric(unique( sub("\\((.+),.*", "\\1", lon_cuts)))
master_true$latcut <- cut(master_true$LAT, lat_cuts, labels = FALSE)
master_true$loncut <- cut(master_true$LON, lon_cuts, labels = FALSE)
master_true$latcut <- as.character(master_true$latcut)
master_true$loncut <- as.character(master_true$loncut)
master_true$Bin <- paste(master_true$latcut, master_true$loncut, sep = "")
master_true$Bin <- as.factor(master_true$Bin)

#Binning the FALSEs
lat_cuts <- cut(master_false$LAT, 10)
lon_cuts <- cut(master_false$LON, 10)
lat_cuts <- as.numeric(unique( sub("\\((.+),.*", "\\1", lat_cuts)))
lon_cuts <- as.numeric(unique( sub("\\((.+),.*", "\\1", lon_cuts)))
master_false$latcut <- cut(master_false$LAT, lat_cuts, labels = FALSE)
master_false$loncut <- cut(master_false$LON, lon_cuts, labels = FALSE)
master_false$latcut <- as.character(master_false$latcut)
master_false$loncut <- as.character(master_false$loncut)
master_false$Bin <- paste(master_false$latcut, master_false$loncut, sep = "")
master_false$Bin <- as.factor(master_false$Bin)

#couldn't figure out how to get the probabilities the same in each
false_sample <- master_false[sample(nrow(master_false), nrow(master_true), replace = FALSE, prob = NULL), ]

#merge and shuffle
data_analysis <- rbind(master_true, false_sample)
data_analysis <- data_analysis[sample(1:nrow(data_analysis)), ]
write.csv(data_analysis, "data_analysis.csv")

analysis_calls <- read.csv("analysis_calls.csv")
which(analysis_calls$idx == 214710)

analysis_full <- read.csv("analysis_full.csv")
blight_viols_clean <- read.csv("blight_violations_clean.csv")
