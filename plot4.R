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


### Plot2: Submetering vs Day  ###
data$Day <- strptime(paste(data$Date, data$Time), '%d/%m/%Y %H:%M:%S')

#Re-format dataset to long format so that there will be one sub_metering variable
data3 <- reshape(data, varying=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'),
                 v.names = 'Submetering', timevar = 'Submeter_Type', times = c(1,2,3),
                 direction = 'long')

#Open png device
png(file = 'Plot4.png')

par(mfcol = c(2,2))

## Plot1: Global_active_power vs Day
with(data, plot(Day, Global_active_power, xlab = '', ylab = 'Global Active Power', type = 'l'))

## Plot2: Submetering vs Day
with(data3, plot(Day, y = Submetering, type = 'n', xlab = '', ylab = 'Energy sub metering'))
with(subset(data3, Submeter_Type == 1), lines(Day, Submetering, type = 'l', col='black'))
with(subset(data3, Submeter_Type == 2), lines(Day, Submetering, type = 'l', col='red'))
with(subset(data3, Submeter_Type == 3), lines(Day, Submetering, type = 'l', col='blue'))
legend('topright', bty = 'n', lty=1, col = c('black', 'red', 'blue'), legend = c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'))

## Plot3: Voltage vs datetime (Day)
with(data, plot(x = Day, y = Voltage, type = 'l', xlab = 'datetime'))

## Plot4: Global_reactive_power vs datetime (Day)
with(data, plot(x = Day, y = Global_reactive_power, type = 'l', xlab = 'datetime'))

dev.off() ## Close the png file device