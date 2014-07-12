# Get data
zipped = "household_power_consumption.zip"
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",zipped, "curl")
unzip(zipped)

# Read all data
file = "household_power_consumption.txt"
data <-read.table(file, header=TRUE, sep=";", dec=".", na.string="?")
data[,1:2]=sapply(data[,1:2],function(x) as.character(x)) # remove factors from Date and Time
data[,1]=paste(data[,1], data[,2]) # merge date and time
data<-cbind(strptime(data[,1], format ="%d/%m/%Y %H:%M:%S"), data[,3:9]) # reformat data.frame to include merged Date and Time and remove separate Date and Time columns
names(data)[1]="Date"

# Select interval dates
interval = c(strptime("01/02/2007 00:00:00", format ="%d/%m/%Y %H:%M:%S"), strptime("03/02/2007 00:00:00", format ="%d/%m/%Y %H:%M:%S"))
data = subset(data, Date >= interval[1]) 
data = subset(data, Date <= interval[2])
data[,2:8]=sapply(data[,2:8],function(x) as.numeric(as.character(x))) # remove factors from remaining data

# Reproduce 4th plot
png("plot4.png", width=480, height=480, bg="transparent")
par(mfrow=c(2,2))
plot(data$Date, data$Global_active_power, type="l", xlab="", ylab="Global Active Power", bg="NA")
plot(data$Date, data$Voltage, type="l", xlab="datetime", ylab="Voltage", bg="NA")
plot(data$Date, data$Sub_metering_1, type='l', xlab="", ylab="Energy sub metering", bg="NA")
lines(data$Date, data$Sub_metering_2, type='l', col="red")
lines(data$Date, data$Sub_metering_3, type='l', col="blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
plot(data$Date, data$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power", bg="NA")
par(bg="transparent")
dev.off()
