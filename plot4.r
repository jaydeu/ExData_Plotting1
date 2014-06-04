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

############ Graph 4: Four plots ############

# Convert variables to numeric
tidy.DF$Global_active_power <- as.numeric(as.character(tidy.DF$Global_active_power))
tidy.DF$Sub_metering_1  <- as.numeric(as.character(tidy.DF$Sub_metering_1 ))
tidy.DF$Sub_metering_2  <- as.numeric(as.character(tidy.DF$Sub_metering_2 ))
tidy.DF$Sub_metering_3  <- as.numeric(as.character(tidy.DF$Sub_metering_3 ))
tidy.DF$Voltage  <- as.numeric(as.character(tidy.DF$Voltage ))
tidy.DF$Global_reactive_power  <- as.numeric(as.character(tidy.DF$Global_reactive_power))

png("plot4.png", width=480, height=480, units="px")
# Tell R to put all plots in the same 2x2 window
par(mfrow=c(2,2))

# Global Active Power plot

plot(tidy.DF$Global_active_power, type='l', ylab="Global Active Power", xlab='', xaxt='n')
axis(1, at=c(0, sum(tidy.DF$wday=="Thu")+1, nrow(tidy.DF)),labels=c("Thu", "Fri", "Sat"))

# Voltage plot
plot(tidy.DF$Voltage, type='l', ylab='Voltage', xlab='datetime', xaxt='n')
axis(1, at=c(0, sum(tidy.DF$wday=="Thu")+1, nrow(tidy.DF)),labels=c("Thu", "Fri", "Sat"))


# Energy sub metering plot

plot(tidy.DF$Sub_metering_1,type="l",col="black", ylab='Energy sub metering', xlab='',  xaxt='n')
lines(tidy.DF$Sub_metering_2,type="l",col="red")
lines(tidy.DF$Sub_metering_3,type="l",col="blue")
axis(1, at=c(0, sum(tidy.DF$wday=="Thu")+1, nrow(tidy.DF)),labels=c("Thu", "Fri", "Sat"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c(1, 2, 4), lty = c(1, 1, 1), bty = "n")

# Global reactive power plot

plot(tidy.DF$Global_reactive_power, type='l', ylab='Global_reactive_power', xlab='datetime', xaxt='n')
axis(1, at=c(0, sum(tidy.DF$wday=="Thu")+1, nrow(tidy.DF)),labels=c("Thu", "Fri", "Sat"))
dev.off() 