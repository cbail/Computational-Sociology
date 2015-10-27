# SCRIPT FOR CLASS #8, COMPUTATIONAL SOCIOLOGY
# Instructor: Chris Bail 
# Copyright, Chris Bail

# MACHINE LEARNING

# Last class we noted a number of problems that plague analysis of large, 
# complex datasets. These include issues about the meaning of p-values
# an statistical significance, non-linear relationships between variables
# the high likelihood of interaction effects given the large number 
# of variables that can be collected but not analyzed in every possible
# iteration, and- in general- causal complexity, or the likelihood that
# many of the outcomes we are interested in as social scientists do not
# involve a single causal recipe.

# Today we are going to talk about some exciting new (or new-ish) tools
# that help address some of these problems. Some of them are replacements
# for linear models, but others are probably unlikely to displace linear
# models. Given how deeply engrained linear models are within sociology,
# I think the best way to think about these new techniques are alternative
# ways of analyzing/classifying/modeling your data that will help you 
# identify interactions that you might have missed and/or important
# subsets of the data that you might want to code and include in the 
# linear models you ultimately use.

# Once again, you could spend an entire semester on so-called "machine-learning"
# sometimes it is also called "statistical learning." Most of these techniques
# come out of statistics, but they are applied broadly by computer scientists, 
# and people in industry in order to both classify data, and- more often- to make
# predictions about individual behavior. If you are really taken by the ideas
# we talk about today, I recommend checking out this 15 hour class, which will
# give you a comprehensive overview of the techniques, the math and notation behind
# them, and hands on info about how to implement them in R:

#http://www.r-bloggers.com/in-depth-introduction-to-machine-learning-in-15-hours-of-expert-videos/

# In fact, one of the teachers in this video invented one of the techniques we
# will be talking about today (GAMs). For a less technical overview, check out
#this extremely cool visual tutorial:

#http://www.r2d3.us/visual-intro-to-machine-learning-part-1/

# Instead of going in depth into each technique, we are going to do what we 
# always do in this class: try to give you enough of an overview that you
# could pursue this in depth on your own. We will also work through messy
# real-world examples that I hope will help you see the strengths and 
# weaknesses of these new models.

# We are going to focus on three methods in particular: Generalized
# Additive Models, Regression Trees, and Random Forests. 

# GENERALIZED ADDITIVE MODELS

# One huge problem with many linear models is that they are parametric,
# or defined by functions that describe the data using a very small set of 
# parameters. By contrast, GAMs are non-parametric, meaning that the shape 
# of the predictor functions is fully determined by the data

# We can of course build in non-linear transformations of variables
# to account for this problem, but this assumes that we know about the
# problem in the first place. Also, interpretation of such transformations
# can be difficult. For example, do you know what it means if a polynomial
# term is positive or negative? What if there are multiple polynomial
# predictors in your model? To make matters worse, transforming multiple
# predictors within the same model can create colinearity issues. Even
# if we can get around all of these problems, it would take us a ton
# of time- we'd have to try every single type of transformation for 
# every single type of variable until we found the one that is the 
# best fit for the data.

# Generalized Additive Models are a unique approach developed in 1986
# by two statisticians. GAMs look a lot like traditional regression models, 
# but they are much "smarter." GAMs automatically select the best 
# transformation of each variable FOR YOU- these can be both non-linear
# or linear. After "Smoothing" or transforming each variable (where necessary)
# GAMS simultaneously estimate the relationship between each predictor
# and the outcome, outputting coefficients that are very similar to 
# a regular linear model.

# Note that this not only gets us around the issue of having to try
# out different linear combinations of variables we have hunches about
# but also helps us account for potential non-linearities that we did
# not even know to look for.

# GAMS can also support any type of link function, or in other words,
# any type of dependent variable that might be put into a generalized
# linear model (e.g. binary, continuous, etc.)

# GAMs are kind of a compromise between conventional linear models
# which are almost always very biased but easy to interpret; and 
# new machine learning techniques such as random forests which are
# very good at representing/classifying relationships between 
# variables but very difficult to interpret. This is one of the 
# main reasons I don't think we will see random forests in ASR/AJS
# any time soon, but we may well see GAMs.

#Let's look at an example that was put together by Michael Clark at Notre Dame
# these are science test scores from the PISA cross-national education data

data = read.csv("http://www.nd.edu/~mclark19/learn/data/pisasci2006.csv")

# and let's take a look at the data:
library(car)
scatterplotMatrix(data)


# the red smoothed lines show us there is a lot of potential non-linearity
# in the data.

# first, let's run a simple linear model sot hat we can get a baseline.
# we use the gam command, but unless we enclose each predictor in an
# s() it assumes it has a linear relationship with the outcome, 

install.packages("mgcv")
library(mgcv)
first_model <- gam(Overall ~ Income + Edu + Health, data = data)
summary(first_model)

# Now let's try a model that applies a smoother function to each predictor
second_model <- gam(Overall ~ s(Income) + s(Edu) + s(Health), data = data)
summary(second_model)

# and now we can plot the relationship between each predictor and the outcome
plot(second_model, pages=1, residuals=T, pch=19, cex=0.25,
     scheme=1, col='#FF8000', shade=T,shade.col='gray90')

# and this neat contour plot lets us look at multiple variables at once
vis.gam(second_model, type = "response", plot.type = "contour")

# The "lassos" describe the predicted values of the outcome. That is
# the sweat spot is having both high income and high education.

# we can also do something called "tensor product smoothing" here which
# you can think of as a smooth of the smoothers of multiple variables
# at once

third_model <- gam(Overall ~ te(Income, Edu), data = data)
summary(third_model)

# and we can plot it again
vis.gam(third_model3, type='response', plot.type='persp',
        phi=30, theta=30,n.grid=500, border=NA)

# Once again, I'm not sure why GAMs don't have more
# influence in sociology. At the very least, I encourage
# you to use them to triangulate your work with linear
# models. And I suppose that with enough work a linear
# model can "resemble' GAM, so perhaps people are using
# them and then making the relevant transformations within
# the linear models they present in papers? Probably not :)

# REGRESSION TREES

# The idea behind regression and classification trees is to group
# datasets into different subsets and use these different subsets
# to predict different pathways to an outcome. Basically, the
# algorithm breaks down the dataset into different subsets or 
# regions using a stopping rule (for example, the region must
# include at least five observations). Then, the model simply takes
# the mean outcome for each subset or region, and predicts this
# will be the value of the outcome for this subset of the data.
# The results take the form of a "tree" which describes how different
# subsets of the data lead one to expect different values for
# the outcome variable. This visualization is arguably much
# more easy to read than a regression model and can often
# be a better fit for the data (because it can help identify
# non-linearity or causal complexity in the data)

# There are two types of common trees used in machine
#learning : regression trees and classification
# trees. Regression trees are for quantitative outcomes and for these
# we can use the MASS package. classification trees are for 
# categorical outcomes and for these we can use the "tree" package

# Let's take a look at an example which will help make this more
# clear.

install.packages("MASS")
library(MASS)

# the key function we are going to use is called "tree"
# The "mpg~." indicates we want to treat mpg as the outcome
# but look at every other variable in the dataset as a 
# possible preditor:

tree.cars <- tree(mpg~., mtcars)

# One of the great things about regression trees is that
# you can plot them- they kind of resemble a "flowchart"
# within an organization, or a tree used to clasify 
# biological organisms. The main difference, in terms
# or interpretation, is that we are examining causal
# pathways to the outcome (in this case mpg), and the
# ways in which different predictors combine to shape
# the outcome (both high and low levels of the outcome)

plot(tree.cars)
# This adds labels
text(tree.cars ,pretty =0)

# The way to read these trees is to focus on the 
#'<' sign. The branches to the left are less than
# and the branches on the right are greater than.
# the "wt" variable here describes weight (in tons),
# so the tree shows us that this is a big factor in mpg,
# which is not surprising. In fact, all cars less than 2.26
# get about 30mpg. Those greater than 2.26 tons have two
# categories: those with less than six cylinders and those
# with eight cylinders. The V8 cars with the highest horsepower
# (hp) also have the lowest mpg. Again, this makes sense.

# To further intepret how well this classification
#tree fits the data, we can summarize the object:

summary (tree.cars)

#The number we want to focus on is the "residual mean deviance"
# which tells us how far off the regression tree estimates may
# be. If we run a classification tree- which we are about to do
#-we will get another metric: The missclassification rate, which 
# tells us how many cases cannot be explained by the classification tree.

#Finding the best fit for the data usually requires "pruning"
# the tree, or removing branches of the tree that add more
# complexity but less explanatory power. To do this we use the
# cv.tree command

prune.cars =prune.tree(tree.cars ,best =5)
plot(prune.cars)
text(prune.cars ,pretty =0)

# In this case, our tree was already so simple that pruning it
# did not add parsimony. Note that the same pruning process
# can be used for classification trees, as I will soon discuss.

# Let's run through a quick classification tree example, let's
# use the Pew data from a previous class in order to classify
# those who did and did not support the construction of the 
#ground zero mosque. 

load("Pew Data.Rdata")
install.packages("tree")
library(tree)
tree.groundzero =tree(pew10~educ+sex+age+inc+partyln, pewdata)
plot(tree.groundzero)
text(tree.groundzero ,pretty =0)

# The only difference in this process is that the algorithm selects
# the most common value of the outcome given the subset or "branch"
# of the tree instead of the mean value, which is what regression 
# trees use.

# Another neat party for creating trees is the "party" package.
# In addition to the same tree structure generated by the two
# packages above, it adds plots of the cases within each branch
# of the tree. Let's take a look:

install.packages("party")
library(party)
prettycartree <- ctree(mpg~., data=mtcars)
plot(prettycartree)


#These aren't the best datasets to use. I find that regression
# and classification trees are most useful when you have 
# very large datasets with many different variables. I encourage
# you to try this out on different datasets- unfortunately
# I did not have a better dataset on hand.



#RANDOM FORESTS

# The main downside of regression trees is that they are not the most
# accurate tool available. In fact, if all relationships between
# predictors and outcoems are linear, then a linear model will
# be more efficient. 

# The principal reason that regression trees are not the most efficient way
# of making predictions about data is that they only use one "round"
# of subsetting the data. Therefore, regions with high variance
# create problems. But what if instead of partitioning the data
# only once, we did it hundreds of even thousands of times in slightly
# different ways and then averaged the results? This is what is known
# as bootstrapping, and in the language of regression trees, it is 
# often described as "bagging." Random forests are an extension of
# bagging that includes a small tweak that "decorrelates" the bagged
# trees. It does this by taking a random sample of predictor variables
# within each subset, and then choosing one of them as a branch. The 
# random selection of the predictor helps avoid the influence of
# one important predictor over other predictors that have a more 
# moderate yet still meaningful association with the outcome.

# Unfortunately, when we extract a large number of subsets
# from the data using bagging or random forests, we sacrifice 
# the interpritibility a single regression tree. That is, we 
# cannot construct a tree that visualizes all the bagged/randomly
# partioned datasets.


# On the other hand, we can still measure how important each predictor
# is; or how important that "branch" is within the regression tree by
# examining the residual sum of squares.

#Let's try it out.
install.packages("randomForest")
library(randomForest)

set.seed (123)
rf.cars =randomForest(mpg~.,data=mtcars,importance =TRUE)

# To create the variable importance plot, we use this line:
varImpPlot (rf.cars)


# The first plot shows us the how much error we add to our model if we 
# remove the variable from our model using the Mean Square Error. The 
# plot on the right describes
# the total increase in "node impurity" if the variable is removed from
# the model- this is another measure of how important it is to have
# the variable in the model that explains the outcome (and more specifically
# how consistently the outcome is correct for each observation
# within that branch. So a perfectly "pure" node or branch would
# descibe all cases exactly)

# But the best way to figure out how solid your predictions are is to
# use a training dataset or subset of the data to create the model, and 
# then see how well it predicts the outcomes. 


# The most recent advance in regression trees is the concept of 
# boosting, which is similar to bagging but allows trees to grow
# sequentially. If you want to learn more about these models
# check out the book "An Introduction to Statistical Learning"
# and the gbm package





