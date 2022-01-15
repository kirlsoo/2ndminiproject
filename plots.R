#Kby: Kristen Ann Joy Luciano
#Data Science 2nd mini project

#2. Household power consumption data

#Loading the data
#Use read.table to load the data and save under the variable name hpc_data
#missing values, coded as ? are marked with na.strings argument
hpc_data <- read.table("./household_power_consumption.txt", header = T, sep=";", na.strings = "?")

#for the data to be plotted which is from dates 2007-02-01 to 2007-02-02, we use %ini% for value matching
#the data is saved under the variable name hpc_plot 
hpc_plot <- hpc_data[hpc_data$Date %in% c("1/2/2007","2/2/2007"),]

#strptime is used to convert the Date and time to date/time classes in R. with the needed format
#these are saved to the variable set_time
set_time <- strptime(paste(hpc_plot$Date, hpc_plot$Time, sep =" "), "%d/%m/%Y %H:%M:%S")

#the formatted date and time is added to the hpc_plot dataset
hpc_plot <- cbind(set_time, hpc_plot)


#Generating plots

#plot 1
#This plot is a histogram for the global active power .
#using hist fuction we get the data from the column Global_active_power and set color to red and label the x axis as such
#the title is set with the main argument
hist(hpc_plot$Global_active_power, col="red", main="Global Active Power",  xlab="Global Active Power (kilowatts)", ylab = "")
#code for exporting to png
dev.copy(png, file = "plot1.png")
dev.off()


#plot2
#using the plot fuction we then use type l for line plot. this is also for the global active power but the label is on the y axis
plot(hpc_plot$set_time, hpc_plot$Global_active_power, type="l", col="black", xlab="", ylab = "Global Active Power (kilowatts)")
#code for exporting to png
dev.copy(png, file = "plot2.png")
dev.off()


#plot 3
#First we create the vector with the different colors of the lines to be used
collines <- c("black", "red", "blue")
#then another vector for the labels of the lines for th legent
labels <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
#plot the first data with is the data for the sub metering 1, also a line graph, in the needed color and labels
#the data is based on time
plot (hpc_plot$set_time, hpc_plot$Sub_metering_1, type="l", col=collines[1], xlab ="", ylab="Energy sub metering")
#use line function to plot only the lines since the plot is already done
#the data is retrieved from the sub metering 2 under hpc_plot
lines(hpc_plot$set_time, hpc_plot$Sub_metering_2, col=collines[2])
#same as previous only with sub metering 3 data
lines(hpc_plot$set_time, hpc_plot$Sub_metering_3, col=collines[3])
#to create the legend we use the legend function.
#the legend is to be at the top right with the labels and colors from the vectors created earlier. the line types are solid
legend("topright", legend=labels, col=collines, lty = "solid")
#code for exporting to png
dev.copy(png, file = "plot3.png")
dev.off()

#plot 4
#creating labels and color vectors
labels <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
collines <- c("black", "red", "blue")
#setting that the graphic will be in 2 columns and 2 rows to contain the plots
par(mfrow=c(2,2))
#plotting the first plot which is a line plot  for the global active power
plot(hpc_plot$set_time, hpc_plot$Global_active_power, type = "l", col="black", xlab="", ylab = "Global Active Power")
#plot for the next with is for the Voltage in date time
plot(hpc_plot$set_time, hpc_plot$Voltage, type = "l", col="black", xlab="datetime", ylab = "Voltage")

#the third is for the energy sum  metering same as plot 3 earlier
plot(hpc_plot$set_time, hpc_plot$Sub_metering_1, type = "l", xlab="", ylab = "Energy sub metering")
lines(hpc_plot$set_time, hpc_plot$Sub_metering_2, type = "l", col="red" )
lines(hpc_plot$set_time, hpc_plot$Sub_metering_3, type = "l", col="blue" )
legend("topright", bty ="n" ,legend=labels,lty=1, col=collines)

#last is pot for the global reactive power only with x axis as the datetime
plot(hpc_plot$set_time, hpc_plot$Global_reactive_power, type="l", col="black", xlab="datetime", ylab = "Global_reactive_power")
#code for exporting to png
dev.copy(png, file = "plot4.png")
dev.off()

