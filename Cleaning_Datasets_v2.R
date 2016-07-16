
setwd("~/Projects/datasci_course_materials/capstone/blight/data")

#Load csv files into R
city_calls <- read.csv("detroit-311.csv")
blight_viols <- read.csv("detroit-blight-violations.csv")
crime_stats <- read.csv("detroit-crime.csv")
demo_permits <- read.csv("detroit-demolition-permits.csv", header = TRUE)
parcel_points <- read.csv("Parcel_Points_Ownership.csv")

# Cleaning out the LAT and LON variables for blight violations
blight_viols <- as.data.frame(blight_viols)
blight_viols = transform(blight_viols, ViolationAddress = colsplit(ViolationAddress, split = "\n", names = c('street', 'city', 'latlong')))
blight_viols = transform(blight_viols, ViolationAddress.latlong = colsplit(ViolationAddress$latlong, split = ",", names = c('lat', 'long')))
blight_viols$ViolationAddress.latlong.lat <- substr(blight_viols$ViolationAddress.latlong.lat, 2, 10)
blight_viols$ViolationAddress.latlong.long <- substr(blight_viols$ViolationAddress.latlong.long, 1, 11)
names(blight_viols)[names(blight_viols)=="ViolationAddress.latlong.lat"] <- "LAT"
names(blight_viols)[names(blight_viols)=="ViolationAddress.latlong.long"] <- "LON"
blight_viols$LAT <- as.numeric(blight_viols$LAT)
blight_viols$LON <- as.numeric(blight_viols$LON)
blight_viols$ViolationAddress <- NULL

# Cleaning out the LAT and LON variables for demolition permits
demo_permits <- as.data.frame(demo_permits)
demo_locations <- demo_permits[ , "site_location", drop=FALSE]
demo_locations <- cSplit(demo_locations, 'site_location', '\n', drop=FALSE)
demo_locations <- cSplit(demo_locations, 'site_location_3', ',', drop=FALSE)
demo_locations$site_location_3_1 <- str_replace_all(demo_locations$site_location_3_1, "[(]", "")
demo_locations$site_location_3_2 <- str_replace_all(demo_locations$site_location_3_2, "[)]", "")
names(demo_locations)[names(demo_locations)=="site_location_3_1"] <- "LAT"
names(demo_locations)[names(demo_locations)=="site_location_3_2"] <- "LON"
demo_locations$LAT <- as.numeric(demo_locations$LAT)
demo_locations$LON <- as.numeric(demo_locations$LON)
demo_permits <- cbind(demo_permits, demo_locations$LAT, demo_locations$LON)
names(demo_permits)[names(demo_permits)=="demo_locations$LAT"] <- "LAT"
names(demo_permits)[names(demo_permits)=="demo_locations$LON"] <- "LON"

# Cleaning out the LAT and LON variables for demolition permits
city_calls <- as.data.frame(city_calls)
names(city_calls)[names(city_calls)=="lat"] <- "LAT"
names(city_calls)[names(city_calls)=="lng"] <- "LON"

# Write cleaned LAT / LONG files to CSV
write.csv(blight_viols, file = "blight_violations_clean.csv")
write.csv(demo_permits, file = "demo_permits_clean.csv")
write.csv(city_calls, file = "city_calls_clean.csv")
