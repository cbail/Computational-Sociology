# SCRIPT FOR CLASS #1, COMPUTATIONAL SOCIOLOGY
# Instructor: Chris Bail 
# Copyright, Chris Bail


# GETTING STARTED WITH YOUR WORKING DIRECTORY

# Setting Your Working Directory

# First let's identify your "working directory," or the 
# place where the files you want to work with are located. 
# At first they were online in our class's Dropbox folder, 
# but you have since downloaded them onto your computer. 
# Identifying the working directory is important because 
# you will need to know it in order to load files, import 
# data, and export graphs or other types of analysis.

# in order to identify your working directory, highlight 
# the line below and then click "Return" while holding down 
# "Control." This tells RStudio that you want to "run" or
# execute whatever line you are working on. You can also
# use the "Run" button in the upper right-hand side of this 
# pane of RStudio.

getwd()

# You should now see the output of this command below. By 
# default, R sets the working directory to the "home" folder 
# on your computer, or the folder that contains the file you 
# double clicked on.

# Often you will want to change the working directory, either
# because you want to work with data in a new folder, or 
# because you want to tell R to save your work to a folder
# that is more convenient for your work flow

# the command below will set your working directory to be
# your desktop

setwd("~/Desktop")

# The ~ sign here replaces the more detailed name of your 
# computer for example, if I were to use the complete name 
# of my desktop folder is: setwd("/Users/christopherandrewbail/Desktop)
# I am going to set my home folder as follows:

setwd("/Users/christopherandrewbail/Desktop/Dropbox/ODUM R COURSES/Intro to R Class Dropbox/")


# Next, let's take a look at what documents are in your
# home folder. 

list.files()

# Basic Operations in R

# Perhaps the most basic thing one can do is use
# R as a calculator

1+1

# Now let's create our first object or variable in R
# To do this, you need to use the "<-" operator

my_number<-2

# we have now created a numeric variable whose value 
# is 2. Note that you can also use the "=" sign if you
# prefer (my_number=2). 

# Notice in the top right hand pane of Rstudio there is
# now a value for my_number. 

# now lets try some basic operations
2*my_number
2+my_number 
2-my_number
my_number/3
my_number^3

# if we want to store the results of these basic
# operations, we could use the "<-" operator again

my_new_number<-2*my_number

# when naming variables or objects in r, try to 
# avoid terms that may confuse r because they are
# similar to commands. For example, don't name a 
# variable "mean" or "median." Also, keep in mind
# that R is case sensitive. If one letter is
# accidentally capitalized, your command won't 
# work.

# We can also create character or "string" variables
# by using either double or single quotation marks.

my_name<-"Georg Simmel"

# If we want to see the variable, we can use this
# command

print(my_name)

#