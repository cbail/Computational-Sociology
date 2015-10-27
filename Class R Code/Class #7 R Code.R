# SCRIPT FOR CLASS #7, COMPUTATIONAL SOCIOLOGY
# Instructor: Chris Bail 
# Copyright, Chris Bail

# LINEAR MODELING

# Most of you are not only interested in visualizing
# your data, but understanding it at a much deeper level.
# We can learn quite a lot from visualization. Everything
# from identifying patterns of missing data to three and
# four way interactions between variables.

# But most of us also care about "statistical significance,"
# to some degree. While there are new debates about the
# meaning of significance in the age of big data, I do not
# think we are going to abandon P-values over night.

# In this class, we will 
# focus on some very basic statistics one can do in R.
# Once again, I will try to show you enough that you 
# could learn more on your own, but because R is used
# by everyone from economists to ecologists, the range
# of statistical routines available is truly astounding
# and therefore too broad to cover in one morning- let
# alone one week!

# As always, I'm going to focus on messy, "real-world"
# examples. These are particularly important this week
# because linear models can create very big problems
# with big data. This includes not only issues related to
# p-values, but also outlier detection, equifinality,
# and a range of other issues. So today we will look 
# at some of the data I've collected and make some
# mistakes that I hope will help you avoid similar
# issues in your own work.

# The other reason I'm teaching you how to run models
# in R is that often computational social science requires
# an iterative approach to data cleaning, data classification,
# and data analysis. If you keep moving data back and forth
# between R and STATA Or SAS, you will waste a lot of time
# converting file formats, etc. Plus, I will try to convince
# you that R is a much better platform for statistical analyses
# because it allows you to use state of the art techniques.
# This is also the reason why I advocate R over Python (stats
# packages in the latter pale in comparison to the former)

# Let's start by some of the most basic statistical
# analysis available to us in R. We are going to return
# to base R for the time being, but I'll show you 
# a few packages later on.

# First, let's load our Pew data from yesterday using the
# load command:

load("Pew Data.Rdata")

# Remember that you will need to specify a file path if the file
# is not in your working directory. To check, write "getwd()"

# let's try to predict whether people support or oppose
# the ground zero mosque (this variable is labelled pew10)
# 1=oppose construction, 2= support construction

table(pewdata$pew10)

# let's create a new factor variable that describes
# whether someone is Republican

pewdata$Republican<-0
pewdata$Republican[pewdata$partlyn=="Republican"]<-1


#Now, let's run a ttest to see if being a republican
# shapes your opinion of the ground zero mosque. To
# do this we use the t.test command. Note that we can
# specify our data as an option in this command, or
# write them out using $.
# The ~ in r generally stands for "explained with."

t.test(pew10 ~ Republican, data=pewdata)

# here we see a clear cut difference.

# but was is the direction? To figure this out we
# need to run a correlation. We can use the cor.test
# command

# CORRELATIONS

cor.test(pewdata$pew10, pewdata$Republican)

# we see a negative, significant relationship, so
# this suggests that being republican is negatively
# associated with supporting the Ground Zero Mosque


# One of the most useful things about R is that it 
# can very easily and efficiently combine statistics
# and visualization. 

# Let's say we wanted to quickly identify variables
# with significant correlations with each other. The
# corrgram package produces a "heatmap-style" correlation
# matrix:

install.packages("corrgram")
library(corrgram)
corrgram(pewdata)



# MULTIPLE LINEAR REGRESSION

# but what if we are concerned that age is a confounding
# factor in this relationship. That is older people might
# be less accepting of Muslims.

# To figure this out, we'd need to run a multiple linear
# regression model. In R, the syntax for this is:

lm(pew10~Republican+age, pewdata)

# But this doesn't give us the output we want. This
# is because R stores the output as an object. 
# so we need to write something like:

results<-lm(pew10~Republican+age, pewdata)

# and then to obtain the results, we need to write

summary(results)

# This is a bit annoying, but it can come in handy when
# you want to extract different parts of the results
# and put them into tables or plot them. 

# For example, if we want to get the coefficiences, we
# can use the $ operator to get the coefficients

x<-results$coefficients
y<-results$residuals

z<-cbind(x, y)
write.csv(z, file="myresults.csv")


# we can also plot the residuals values easily

plot(results)

#You need to hit return to see the different types
# of plots available

#The scatterplot matrix is also pretty cool. Let's
# try it out with the built-in "mtcars" data, because
# it has lots of continuous variables unlike these
# pew data:

pairs(~ mpg + hp + cyl, data=mtcars)

#R also includes pretty much every single diagnostic test
#available. For exmaple, here is the command for evaluating
#MultiCollinearity/Variance Inflation Factors:

install.packages("car")
library(car)
vif(results)

# Here is the Bonferonni p-value for the most extreme observations
outlierTest(results)

#comes up negative. Some of them are even interactive:

influencePlot(results,  id.method="identify", main="Influence Plot", sub="Circle size is proportial to Cook's Distance" )


#There are also popular tools for assessing non-normality:

qqPlot(results)

# It looks a little funky because it is bimodal. Normally we use a qqplot to 
#asses wether the data fit a normal distribution

#See also 
leveragePlots(results)
avPlots(results)

#We can also evaluate homoscedasticity using a non-constant error
#variance test:

ncvTest(results)

# look for non-linearity
crPlots(results)

# looks ok.

# What about missing data? 
install.packages("VIM")
library(VIM)
aggr(pewdata)

#extremely efficient, huh?

# we can also combine the matrix scatterplot with a missing data
#analysis as follows:

#first let's take a subset
subsample<-pewdata[,c("age","sex","pew10")]
marginmatrix(subsample) 

# If you get the "figure margins too large" warning, try making
# your plot window large in RStudio.

# There are many more ways of doing this, and many more great
# visualization techniques in the VIM package to help you
# identify even more subtle missing data patterns


# But from this brief glance we know we have
# Lots of missing data. I'll show you how
# to use multiple imputation very quickly.
# A word of warning, however: multiple imputation
# can make things worse if your model is not
# properly specified. Also, make sure you are
# only passing numeric variables or factor variables
# to the multiple imputation commands:

# Let's just try imputing for the small
# data set we created above called "subsample":

library(mice)


# now impute!
mice.dat <- mice(subsample,m=10,seed=3)
## combine datasets
mice.dat <- complete(mice.dat,action=10)
# now we could re-run our analysis if we so choose.

## **Now You Try It:**
  
#1) Determine whether the relationship between mpg and
#hp of a car is significant when controlling for the number
# of cylinders, quarter second time (qsec), and whether or not
# a car is automatic (using the "am" variable)"

# solution: summary(lm(mpg~hp+cyl+qsec+am, data=mtcars))


# FIXED-EFFECTS

# To run a fixed effects model you can simply run:

fixed<-(lm(pew10~Republican+age+factor(state), data=pewdata))

# RANDOM-EFFECTS

install.packages("lme4")
library(lme4)
random<-lmer(pew10~Republican+age+ (1|state), data=pewdata)


# To specify a different distribution of the outcome, use the "family" argument:

random2<-lmer(pew10~Republican+age+ (1|state), family=poisson, data=pewdata)

# We get some funky error messages here because we chose a family that 
#do not fit the data:

# To determine whether or not to use random effects we can use 
# the Breusch-Pagan test- if it is significant this suggests the
#random model is better way to describe the data.

install.packages("lmtest")
library(lmtest)
bptest(fixed, random)

# this suggests we should use the random effects model.


#TIME-SERIES

# R also shines when it comes to time series analysis. We are 
# going to use the plm package, and some sample data on
# employment in the UK:

install.packages("plm")
library(plm)
data("EmplUK", package="plm")
head(EmplUK)

#These "conditioning plots help us see if the relationships
# between sectors really vary across year:

coplot(wage ~ year|firm, type="l", data=EmplUK) 
coplot(wage ~ year|firm, type="l", data=EmplUK) 

#it looks like they do.


#I also like to plot the means across organizations
install.packages("gplots")
library(gplots)
plotmeans(wage ~ year, main="Heterogeineity across time", data=EmplUK)
plotmeans(wage ~ firm, main="Heterogeineity across Employment sectors", data=EmplUK)

# so we are seeing differences across both time and sectors

# now lets run some models. First, let's run fixed effects:

fixed1 <- plm(wage ~ capital+output+emp, index=c("firm", "year"), data=EmplUK, model="within")
summary(fixed1)

#and here's how we would run a random effects model

random1 <- plm(wage ~ capital+output+emp, index=c("firm", "year"), data=EmplUK, model="random")
summary(random1)

#test for serial correlation
library(lmtest)
pbgtest(random1)

#We should also test for cross-sectional dependence/contemporaneous causation
pcdtest(random1, test = c("lm"))

#And of course, we could test for much, much more...



