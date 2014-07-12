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

# Reproduce 1st plot
png("plot1.png", width=480, height=480, bg="transparent")
hist(data$Global_active_power, xlab = "Global Active Power (kilowatts)", col = "red", main = "Global Active Power", bg="NA")
par(bg="transparent")
dev.off()