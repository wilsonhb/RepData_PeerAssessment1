# Peer graded assignment
install.packages('knitr', repos = c('http://rforge.net', 'http://cran.rstudio.org'),
                 type = 'source')
library(ggplot2)

setwd("D:/Trabajo (3)/Métodos/R courses/Curso 5 DSE - Reproducible research/PGA1")
furl <- "https://github.com/wilsonhb/RepData_PeerAssessment1/raw/master/activity.zip"

if(!file.exists("activity.zip")) {
      download.file(furl, destfile = "./activity.zip", mode="wb")
      unzip("activity.zip", overwrite = T)
}


da <- read.csv("activity.csv", header = T)
str(da)

# What is the mean total number of steps taken per day?
# Calculate the total number of steps taken per day

# Creates an object containing the collapse dataset
steps_day <- aggregate(steps ~ date, da, sum)
hist (steps_day$steps, main="Total number of steps per day", col="red", xlab="Number of steps")

# Reporting the mean and median
##This is the mean and median of the # of steps taken per day
mean(steps_day$steps)
##This is the mean and median of the # of steps taken per day
median(steps_day$steps)


#2. What is the average daily activity pattern?
# Making the time series plot for 5-minute interval
steps_interval <- aggregate(steps ~ interval, da, mean)
with(steps_interval, plot(interval, steps, type="l"))
plot(date, steps, data = steps_day, type="l")
g <- ggplot(data = steps_interval, aes(interval, steps))
g + geom_line() +
      labs(x="5-minute interval", y = "Steps (mean)") +
      labs(title = "Daily activity pattern") +
      theme_minimal()

#Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
#The interval with the maximum of steps is:
max_interval <- steps_interval[which.max(steps_interval$steps), 1]
max_interval


# 3. Imputing missing values
##Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with 

# Total missing values
#The total missing values are:
na <- sum(!complete.cases(da))
na

# Imputing missing values for NA
da$steps[is.na(da$steps) == T] <- mean(da$steps, na.rm = T)
sum(is.na(da$steps))
da2 <- aggregate(steps ~ date, da, sum)
g <- ggplot(data = da2, aes(steps))
g + geom_histogram(bins = 30, col="green") +
      labs("Histogram of daily steps with no NA")
hist (da2$steps, main="Total number of steps per day", col="orange", xlab="Number of steps")


# Are there differences in activity patterns between weekdays and weekends?
install.packages("timeDate")
library(timeDate)
da <- read.csv("activity.csv", header = T)
da$steps[is.na(da$steps) == T] <- mean(da$steps, na.rm = T)
da$ww2 <- isWeekday(da$date)
table (da$ww2)
library(lattice)
da2 <- aggregate(steps ~ interval + ww2, da, mean)
with(da2, xyplot(steps ~ interval | ww2, type="l", layout=c(1,2)))
#
g <- ggplot(da2, aes(interval, steps, color = ww2))
g + facet_wrap(.~ww2, ncol=1, nrow=2) +
      geom_line() +
      labs(x = "Interval", y= "Average number of steps") +
      labs(title = "Average daily steps during weekend/weekdays") +
      scale_colour_discrete(name="Days", labels=c("Weekend", "Weekdays"))
