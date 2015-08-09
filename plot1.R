#fast read the data file
setwd("./GitHub/ExploratoryAnalysis")

library(data.table)
file <- "./data/household_power_consumption.txt"
DT <- fread(file, na.strings = "?" )

#transform Date and Time into POSIXct and Date class 
timeformat <- "%d / %m / %Y %H:%M:%S"
dateformat <- "%d/%m/%Y" # dd/mm/yyyy
DT[, Time:= as.POSIXct( paste(Date,Time),format = timeformat )]
DT[, Date:=as.Date(Date, format= dateformat)]

#Obtain the observations whose date is 2007-2-1 or 2007-2-2
selectidx1 <- DT$Date==as.Date("2007-02-01")
selectidx2 <- DT$Date==as.Date("2007-02-02")
selectidx <- selectidx1|selectidx2
dtselect <- DT[selectidx,]

#construct matrix m including all the columns of dtselect except Date and Time
#The colnames of matrix m are Global_active_power,..., sub_metering_3.
DF <- data.frame(dtselect)
m <- sapply(DF[c(-1,-2)], as.numeric)
colnames(m) <- names(DF)[c(-1,-2)]
datetime <- dtselect$Time

#plot the histgram into plot1.png
png(filename = "plot1.png",
    width = 480, height = 480, units = "px")
hist(m[,1], col = "red", xlab = "Global Active Power(kilowatts)", main = "Global Active Power")  
dev.off() 
