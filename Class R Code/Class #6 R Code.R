# SCRIPT FOR CLASS #6, COMPUTATIONAL SOCIOLOGY
# Instructor: Chris Bail 
# Copyright, Chris Bail

# Visualizing and Analyzing Data

# Base R has a variety of routines for visualizing data. Many
# of these are fairly good, but there is widespread consensus
# that the "ggplot2" package provides the most sophisticated
# visualization capacities. Let's take a quick peak at 
# some of ggplot's capabilities:
# http://shinyapps.stat.ubc.ca/r-graph-catalog/


# Let's install ggplot2

install.packages("ggplot2")

# The data we are going to use today come "built in" with 
# the ggplot package. These data describe various 
# characteristics of a large sample of diamonds (e.g. their
# size, cut, clarity)

# to load a built in dataset we need to call ggplot2 and then
# run the data() command

library(ggplot2)
data("diamonds")

#2.1 Scatterplots

#Let's try a basic scatterplot in ggplot2:

ggplot(diamonds, aes(x=carat, y=price)) + geom_point()

#`diamonds` is the data set we want to plot  

#"aes" refers to the x,y coordinates we want to plot. 
#Note that we did not need to use the  
#`$` operator to specify the variable names geom_point() 
#describes the type of plot. The `+` indicates this 
#is a "layer." We can add many different types of layers
#to a ggplot2 graph, as we will soon see.

#Not bad, but the graph could be much more informative if
# we added some color. Lets color the points of the graph
# according to the clarity of the diamonds. This variable
# is a factor variable

ggplot(diamonds, aes(x=carat, y=price, color=clarity)) + geom_point()

# Conventiently, ggplot automatically creates a legend
# on the right hand side of the graph.

# But we can go even further by manipulating the size of the
# points. 

ggplot(diamonds, aes(x=carat, y=price, color=clarity, size=cut)) + geom_point()

# Note that we can also use different kinds of shapes (instead of
# circles) by specifying `shape=` within our "aes" command.

# Earlier I mentioned that ggplot uses layers. Let's go even
#further and add a some smoothing to further illustrate 
# the relationship between price and carat

ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + geom_smooth()

# The blue line is the result of the smoothing, and the
# grey bars are the standard errors Here we can see
# there is not a 1 to 1 relationship between carat and price.

# we can put a variety of "options" within geom_smooth if we 
# want. For example, if we want to use linear regression to
# draw the trendline, we can write:

ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + geom_smooth(method="lm")

# Or, if we want to look at different trend lines for different
# variables, we could run:

ggplot(diamonds, aes(x=carat, y=price, color=clarity)) + geom_smooth()

#Note that the points disappeared from our chart because we 
#removed the geom_point() layer.

# Many R users not only like to add layers to individual plots,
# but create many plots beside each other in order to 
# communicate even more information. 

#3.2 Facet Wraps

# To do this, we add something called a "facet_wrap:"

ggplot(diamonds, aes(x=carat, y=price)) + geom_point() + facet_wrap(~ cut)

# The tilde here tells R which variable it should use to make
# the separate plots

# We could of course bring back in color, or change the size 
# of the points again.

# This is really just the very beginning of ggplot's capability
# If this were a course on visualization alone, we could go
# into much greater depth about how to customize titles (ggtitle,
# xlab, ylab), Or how to change the range of an axis (e.g. xlim(0,2))

# But for now, let's look at some other types of graphs ggplot
# can produce. Here is a line graph:

ggplot(diamonds, aes(x=carat, y=price, color=clarity)) + geom_line()

# 3.3 Histograms, Boxplots, Violin Plots

# Here is a histogram

ggplot(diamonds, aes(x=price)) + geom_histogram()

## once again, each layer has a range of different options, let's
# say we want the bars to represent more unique values of price.
# to do this, we'd use the bindwidth option

ggplot(diamonds, aes(x=price)) + geom_histogram(binwidth=100)

# once again, we could add facet_wraps or other types of 
# functionality to this graph, but in the interest of time
# let's keep going and look at some other types of plots

# For example, ggplot's boxplots are fairly popular

ggplot(diamonds, aes(x=color, y=price)) + geom_boxplot()

# We can get a bit more information about the standard
# errors via a "violin plot":

ggplot(diamonds, aes(x=color, y=price)) + geom_violin()


## Now You Try It:
# 1) Load the `mtcars` **data
# 2) plot the relationship between the `mpg` and `hp` variables in
# the form of a scatterplot with facets for the `gear` variable
# 3) Bonus points: add a title to the graph


# Solution:

ggplot(mtcars, aes(mpg, hp)) + geom_point() +facet_wrap(~gear) +ggtitle("Relationship Between MPG and Horsepower by Number of Gears")


##OTHER VISUALIZATION PACKAGES

## Though we have focused on ggplot, There are so many 
## other great packages for visualization in R. Check
## out this "tabplot" package, for example:

install.packages("tabplot")
library(tabplot)
tableplot(diamonds)

# Or check out this beautiful map of geo-tagged tweets
# created using "ggmap" a spin-off of ggplot


# Finally, I'll show you how to create the heatmap
# I showed you earlier

nba <- read.csv("http://datasets.flowingdata.com/ppg2008.csv", sep=",")
nba <- nba[order(nba$PTS),]
row.names(nba) <- nba$Name
nba <- nba[,2:20]
nba_matrix <- data.matrix(nba)
nba_heatmap <- heatmap(nba_matrix, Rowv=NA, Colv=NA, col = cm.colors(256), scale="column", margins=c(5,10))

# I briefly showed you this example to note how many
# visualization tasks involve some data cleaning
# or re-structuring before they can be performed.
# In this case, we sorted the data, changed row names,
# and transformed the data into a matrix.

# But many regular applications require even more
# Challenging tasks such as reshaping your data from
# wide to long, or re-formatting variables from
# character to factor, or factor to numeric.


## Exporting plots from R is fairly straitforward. If you are working with a ggplot object,
## the ggsave command is quite useful: 

myplot<-ggplot(diamonds, aes(x=color, y=price)) + geom_violin()
ggsave(file="organ donation.png", plot=myplot, width=5, height=5, dpi=300)


#If you are using another package, wrap your plot in between the png() function
# and the dev.off() function as follows

# We do this by sandwhich our code in between two new lines:
png(file="nba_heatmap", width=480, height=480)
nba <- read.csv("http://datasets.flowingdata.com/ppg2008.csv", sep=",")
nba <- nba[order(nba$PTS),]
row.names(nba) <- nba$Name
nba <- nba[,2:20]
nba_matrix <- data.matrix(nba)
nba_heatmap <- heatmap(nba_matrix, Rowv=NA, Colv=NA, col = cm.colors(256), scale="column", margins=c(5,10))
dev.off()

# A png file entitled nba_heatmap is now saved in our working directory
# we can change the size using the "width" and "height" options
# within the png command above (and you can do the same in the ggsave command)


# Because the Twitter API Script takes a long time to run,  I ran earlier and saved the data for you in a 
# .Rdata file that is in our class dropbox. It is called "Twitter
# Network Data.Rdata". If you have set your working directory
# to be the same folder that you downloaded from Dropbox,
# you can write:

load("Twitter Network Data.Rdata")

# Once we have the complete dataset, we could do any number
# of things. Because I'm guessing that many of you are interested
# in network analysis, let's just make a quick network plot using
# the igraph package:

# First let's install and load the package:
install.packages("igraph")
library(igraph)

#Next, let's convert our data frame to an "igraph object"
# which is necessary to do any network analysis in this
# package.

twitter_igraph <- graph.data.frame(twitter_network_data, directed=FALSE)

#Calculating network stats is extremely easy using igraph:
  
twitter_betweennes<-betweenness(twitter_igraph)
twitter_closeness<-closeness(twitter_igraph)
twitter_clustering_coefficient<-transitivity(twitter_igraph)

#...and there are many, many more. Working with two-mode, weighted, and dynamic 
# network data is R is also very easy because of its sophisticated database manipulation tools 
# as well as a number of different packages such as `sna tnet SoNIA` 


# Now, let's plot it:

plot(twitter_igraph)

# If you got an error message that says "figure margins too large"
# run this code which resets the allowable limits of visualizations:

par(mar = rep(2, 4))

# what a mess! First, we are simply trying to plot too much
# info, we need to drop all the people who have very few
# network ties from the dataset in order to get a cleaner
# picture:

only_cool_kids<-delete.vertices(twitter_igraph,which(degree(twitter_igraph)<20))
plot(only_cool_kids)

# We are still getting an error message about the labels not working. This
# is most likely because some of the characters in the data we read in
# were in a foreign language (remember, our data describe the most popular
# Twitter users around the entire world)

#To fix this I'm going to change character encoding as follows:

twitter_network_data$Source<-iconv(twitter_network_data$Source, "latin1", "ASCII", sub="")
twitter_network_data$Target<-iconv(twitter_network_data$Target, "latin1", "ASCII", sub="")

# now we need to repeat all the steps:
twitter_igraph <- graph.data.frame(twitter_network_data, directed=FALSE)

# We are still getting a warning message that says some strings were read
# in as NA. This is probably because the character conversion did not
# work for every single language that Twitter users can use:

# once again, let's prune the network
only_cool_kids<-delete.vertices(twitter_igraph,which(degree(twitter_igraph)<20))
plot(only_cool_kids)

# What are those funny loops? Those are people who are following themselves?
# must be a data building error. A quick fix would be to use igraph's 
# simplify command which removes these self references

only_cool_kids<-simplify(only_cool_kids)
plot(only_cool_kids)

#looking better, but hardly beautiful. Let's try a different layout:

plot(only_cool_kids, layout=layout.reingold.tilford)

#Katy Perry rules all!

plot(only_cool_kids, layout=layout.circle)

#Everyone is cool!

plot(only_cool_kids)

#USING GEPHI FOR NETWORK VISUALIZTION

# You can spend a long time making network plots look pretty in igraph, but I prefer to use Gephi, because it is 
# much more interactive and has a better graphics engine. It also works well with large network datasets, and it can handle
# both node and edge attributes, as well as dynamic/longitudinal network data.

# See the slides associated with this lecture for instructions about how to install Gephi, import data, and 
# visualize/analyze your data.
  
