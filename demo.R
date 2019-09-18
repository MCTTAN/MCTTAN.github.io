fte_theme <- function() {
  
  # Generate the colors for the chart procedurally with RColorBrewer
  palette <- brewer.pal("Greys", n=9)
  color.background = palette[2]
  color.grid.major = palette[3]
  color.axis.text = palette[6]
  color.axis.title = palette[7]
  color.title = palette[9]
  
  # Begin construction of chart
  theme_bw(base_size=15) +
    
    # Set the entire chart region to a light gray color
    theme(panel.background=element_rect(fill=color.background, color=color.background)) +
    theme(plot.background=element_rect(fill=color.background, color=color.background)) +
    theme(panel.border=element_rect(color=color.background)) +
    
    # Format the grid
    theme(panel.grid.major=element_line(color=color.grid.major, size=.05)) +
    theme(panel.grid.minor=element_blank()) +
    theme(axis.ticks=element_blank()) +
    
    # Format the legend, but hide by default
    theme(legend.background = element_rect(fill=color.background, size=.5, linetype="dotted")) +
    theme(legend.text = element_text(size=8,color="black")) +
    theme(legend.position = "top") +
    theme(legend.title=element_blank()) +
    
    
    # Set title and axis labels, and format these and tick marks
    theme(plot.title=element_text(color=color.title, size=20, vjust=4.25, face = "bold")) +
    theme(axis.text.x=element_text(size=14,color="black")) +
    theme(axis.text.y=element_text(size=12,color="black")) +
    theme(axis.title.x=element_text(size=14,color="black", face = "bold")) +
    theme(axis.title.y=element_text(size=14,color="black", vjust=1.25)) +
    
    # Plot margins
    theme(plot.margin = unit(c(0.35, 0.2, 0.3, 0.35), "cm"))
}

require(quantmod)
require(ggplot2)
require(reshape2)
require(plyr)
require(scales)
require(RColorBrewer)


getSymbols("CMG", src="yahoo")

# Make a dataframe
dat<-data.frame(date=index(CMG),CMG)

# We will facet by year ~ month, and each subgraph will
# show week-of-month versus weekday
# the year is simple
dat$year<-as.numeric(as.POSIXlt(dat$date)$year+1900)
# the month too 
dat$month<-as.numeric(as.POSIXlt(dat$date)$mon+1)
# but turn months into ordered facors to control the appearance/ordering in the presentation
dat$monthf<-factor(dat$month,levels=as.character(1:12),labels=c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"),ordered=TRUE)
# the day of week is again easily found
dat$weekday = as.POSIXlt(dat$date)$wday
# again turn into factors to control appearance/abbreviation and ordering
# I use the reverse function rev here to order the week top down in the graph
# you can cut it out to reverse week order
dat$weekdayf<-factor(dat$weekday,levels=rev(1:7),labels=rev(c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")),ordered=TRUE)
# the monthweek part is a bit trickier 
# first a factor which cuts the data into month chunks
dat$yearmonth<-as.yearmon(dat$date)
dat$yearmonthf<-factor(dat$yearmonth)
# then find the "week of year" for each day
dat$week <- as.numeric(format(dat$date,"%W"))
# and now for each monthblock we normalize the week to start at 1 
dat<-ddply(dat,.(yearmonthf),transform,monthweek=1+week-min(week))

#CHECK DATASET
head(dat)

#only use 2013 to 2016 data (inclusive) - 4 years
library(sqldf)

query = sqldf("SELECT * FROM dat WHERE year BETWEEN 2013 and 2016 ")
head(query)
tail(query)

# Now for the plot
P<- ggplot(query, aes(monthweek, weekdayf, fill = CMG.Close)) + 
  geom_tile(colour = "white") + facet_grid(year~monthf) + scale_fill_gradient(low="red", high="yellow") +
  ggtitle("Chipotle Mexican Grill Closing Price") +  xlab("\n\nWeek of Month") + ylab("") + fte_theme()
P 