library(lubridate)

# Calculate space required for data
# For full data set:

2075259*9*(8/2^20)
#[1] 142.4967 MB

# For only 400,000 rows:

400000*9*(8/2^20)
#[1] 27.46582 MB

#Read in the data

temp <- tempfile()
download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
data <- read.table(unz(temp, "household_power_consumption.txt"), nrows=400000, sep=";", header=TRUE, colClasses = rep("factor",9))
unlink(temp)

# Create data frame

DF <- as.data.frame(data)

# Convert factors to dates

DF$Date <- as.Date(data[,1],format="%d/%m/%Y")

# Create tidy.DF with only 2007-02-01 and 2007-02-02

tidy.DF <- DF[(year(DF$Date)==2007 & month(DF$Date)==2 & day(DF$Date)<3),]

# Add weekdays to data set
tidy.DF$wday <- weekdays(tidy.DF$Date, abbreviate=TRUE)

############ Graph 1: Histogram of Global Active Power ############

# Convert variable to numeric

tidy.DF$Global_active_power <- as.numeric(as.character(tidy.DF$Global_active_power))

# Generate histogram

png("plot1.png", width=480, height=480, units="px")
hist(tidy.DF$Global_active_power, main='Global Active Power', xlab='Global Active Power (kilowatts)', ylab='Frequency', col="red", ylim=c(0,1200), xlim=c(0,6))
dev.off() 
