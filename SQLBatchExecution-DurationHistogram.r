


library("ggplot2")
library("scales")
ggplot(dataset)+
geom_histogram(binwidth=100,alpha=.5, position="identity",aes(fill=Szenario, x = duration_in_microseconds/1000, y =..count../sum(..count..))) +
scale_y_continuous(labels = percent_format()) +
ylab("Percent of Total Execution Number") 


#weitere histogramme gibt es hier:
#http://www.cookbook-r.com/Graphs/Plotting_distributions_(ggplot2)/ für density plots
#https://ggplot2.tidyverse.org/reference/stat_ecdf.html für kummulative distribution

#beispiel


library("ggplot2")
library("scales")
ggplot(dataset)+
geom_histogram(binwidth=1,alpha=.5, position="identity",aes(fill=Szenario, x = duration_in_microseconds/1000, y =..count../sum(..count..))) +
scale_y_continuous(labels = percent_format()) +
ylab("Percent of Total Execution Number") 

##oder: 


library("ggplot2")
library("scales")

# Histogram overlaid with kernel density curve
ggplot(dataset, aes(x=duration_in_microseconds/1000, fill=Szenario)) + geom_density(alpha=.3)

#oder...


library("ggplot2")
library("scales")

# Histogram overlaid with kernel density curve
ggplot(dataset, aes(x=duration_in_microseconds/1000, fill=Szenario)) +
geom_histogram(aes(y=..density.., fill=Szenario), position="identity",     
                   binwidth=10,
                  alpha=.3) + 
geom_density(alpha=.3)



#oder cummulative distribution plot:


library("ggplot2")
library("scales")

ggplot(dataset, aes(x = duration_in_microseconds/1000, colour = Szenario)) + stat_ecdf() +
xlab("duration in ms")
