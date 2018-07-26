
library("ggplot2")
library("scales")
ggplot(dataset)+
geom_histogram(binwidth=1000,aes(x = duration_in_microseconds/1000, y =..count../sum(..count..))) +
scale_y_continuous(labels = percent_format()) +
ylab("Percent of Total Execution Number") +
ggtitle("SQLBatchExecution-DurationHistogram")