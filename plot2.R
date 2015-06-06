#Read data within 2/1/2007 - 2/2/2007 to R
#Together there are 69517-66637 -  = 2880 rows
#Read txt file as lines first
con <- file('household_power_consumption.txt', open='r')
line <- readLines(con)

#Get lines that contain data between 2/1/2007 - 2/2/2007 including the header
k <- grep('^[1|2]/2/2007|Date', line)
length(k)    #2881
k[1]         #66638
k[length(k)] #69517

#Get class from a sample of 100 rows
frst100row <-fread('household_power_consumption.txt', nrows=101, stringsAsFactors=FALSE)
cls <- sapply(frst100row, class)

#Get data now
data <-read.table(textConnection(line[k]), header=TRUE, stringsAsFactors=FALSE, colClasses = cls, sep=';')

str(data)
head(data)
tail(data) ### Cool!


### Plot2: Global_active_power vs Day  ###
data$Day <- strptime(paste(data$Date, data$Time), '%d/%m/%Y %H:%M:%S')

#Open png device
png(file = 'Plot2.png')

#Plot line graph
with(data, plot(Day, Global_active_power, xlab = '', ylab = 'Global Active Power (kilowatts)', type = 'l'))

dev.off() ## Close the png file device