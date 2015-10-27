# SCRIPT FOR CLASS #3, COMPUTATIONAL SOCIOLOGY
# Instructor: Chris Bail 
# Copyright, Chris Bail



#1: Introduction to Programming

# Though STATA, SPSS, and SAS provide basic forms of programming,
# R blows them out of the water. This is because R is built upon
# extremely powerful languages such as C++, but also because it has
# the object-oriented and open-source characteristics necessary
# to interface with other programming languages such as Python.

# At the same time, the syntax of programming in R can be rather
# funky. People who come to R from other languages such as C++
# or Python often report being frustrated by its clunky syntax.
# There are ways to make R simulate the syntax of other programming
# languages, but I will proceed to teach you the "R way" because
# I assume that most of you are hoping to use R as your main
# programming tool. 

#I should note that many people believe that the first programming
# language you learn is the hardest. Once you get a sense of the
# basic concepts of programming, it is much easier to translate
# what you know from one language to another.

# 2: Functions

# The most basic form of programming is a function. We've actually
# already been using them extensively throughout the course. But
# we've been using them without seeing the "source code" or the 
# complicated list of instructions that R processes each time
# we run a command such as corrgram, or tableplot

# A function is simply a set of instructions or tasks that one
# may apply to any type of object in R. Let's take a very basic
#function

my_function <- function(x) x+2

# This function takes a number (x) and adds two to the number.
# let's try it:

my_function(2)
  
# functions can get much, much more complicated.
another_function <- function(x, y, z) {
  x <- mean(x)^2
  y <- cos(y)-5
  z <- log(z)*200
  c(x,y,z)
  }

# this function requires three inputs (x, y, and z). The part
# between the brackets tells R what we want to do to each of these
# three inputs. The "c()" tells R that we want to display the results
# if we did not include the c(), the function would still run, but
# we would need to type "x,""y," or "z," to see the results for each
# variable.

# If you are just getting started out in R, you will probably not
# write too many of your own functions, but you will probabbly soon
# begin borrowing functions from others that you find online. It
# is also important that you understand how a function works in
# case you begin borrowing segments of other people's codes. If 
# you do not understand why their code works, you probably will
# not be able to modify it to suit your own purposes.

# 3: Loops

# Another central type of programming in R is the "for" loop. This
# is one of the oldest types of programming in computer science. We
# might use a for loop when we want to repeat some type of function
# or transformation across a large number of rows in a data frame, or
# a large number of files in a folder.

#let's begin with a very simple example:

for (i in 1:6){
  print("Jim Moody is bad-a$$")
}

# Let's start working with an example to illustrate. Let's say we 
# have a folder full of .csv files that describe different health
# indicators from OECD, but we are really only interested in data
# about Korea. 

# Let's build a for loop that opens each file, grabs the data from
# korea, and then makes another data frame. We need to begin with
# a few steps that may seem strange or unnecessary, but it will
# soon become clear why we need to do them.

# first, we need to tell R where the data are. I've placed it in
# the dropbox in a folder entitled "OECD Health Data. Let's use
# list.files to count the number of files. 

list.files("OECD Health Data")

#The first thing we need to do with a for loop is initialize it, or tell it how
# many times we want it to repeat the action. We therefore need
# to count the number of files "

filenames<-list.files("OECD Health Data")
number_of_files<-length(filenames)

# now, let's create an empty data frame to store our data:
koreadata<-as.data.frame(NULL)

# now, let's loop into each file

for(i in 1:number_of_files){
  
  filepath<-paste("OECD Health Data/", filenames[i], sep="")
  data<-read.csv(filepath, stringsAsFactors = FALSE)
  newdata<-data[data$Location=="Korea",]
  newdata$indicator<-filenames[i]
  koreadata<-rbind(koreadata,newdata)
}

# There is quite a lot to explain here. Let's begin by the first
# line. The "i" here is the variable we are going to loop through.
# so if i=1, then we are looking at the first file in the folder. If
# i=2 we are looking at the second file in the folder, etc.

# the 1:number_of_files, tells R that we want to repeat the steps
# within the loop for values between 1 and number_of_files. In this
# case our number_of_files variable equals 5, so we are telling R
# to repeat these steps for all five files in our folder.

# Everything within the brackets is what we want r to do for each
# file.

# The first thing we want it to do is open the csv file, but to
# do this we need to tell it the full file path of the file. We
# could type filenames[i] but this would just get us the name of
# the file, and not the whole file path.

# to create the file path, we are using the paste function.
# this function takes two strings and joins them together. The
# sep here refers to what we want R to put in between the two
# strings, in this case, we want nothing, so we put no text or
# spaces in between the quotation marks. 

# the second line in the loop simply reads in the .csv file 
#using the file path we just created.

# The third line selects only the data for Korea, which we can
#find because all of the .csv files we are reading in have used
# the same column names, and the same capitalization for the term
# "Korea."

# In the fourth line, we are creating a new variable in the data
# frame we created in the preceding line that describes the name
# of the metric. In this case, the names are sloppy because they 
# include all of the .csv formatting. We could clean this up
# using a command such as gsub() but let's keep it simple for now

# The final line in the loop is critical. We are telling R to
# take this new data frame we created and append it to the blank
# data frame we created before we started the loop. With each
# iteration of the loop, the data frame gets one more row.

# That was a detailed explanation, but my goal was to try and
# work in a few useful commands into a practical example which
# you might encounter in your own work.

# There are other types of loops in R that we do not have time
# to cover (e.g. "while" loops, and if/else statements). My hope
# is that if you want to learn more about these types of loops
# you now have a base level of knowledge to learn about them.

# Loops are slow in most languages, but particularly in R. You 
# may never care about speed if you are only working with datasets
#<10,000 observations in R, but if you want to get into big data
# you will probably want to look into activities at loops.

# On the other hand, you can also chose to be a "hack" or a sloppy
# programmer, and simply run your code on a really powerful
# machine. I'll describe how to do this later during this class.

========================================================
  # **Now you try it:
  
  # Write a forloop that goes through each variable in our Pew Dataset   and replaces values of 9 with NA.

  #Hint: you may find the `ncol` function useful.
  
  #SOLUTION
  
  number_of_columns<-ncol(pewdata)
 for (j in 1: number_of_columns){
   pewdata[,j][pewdata[,j]==9]<-NA
 }


# 4: Vectorized functions
  
# One of the reasons that R is slow is that it is not a compiled 
# language. In other words, you don't have to run a "set up" type
# of program before you do your analysis.

# R can access compiled commands through a process called "vectorization"
# It is not really important for you to understand what the difference
# is. The important thing is that you will probably encounter
# other people using vectorized commands because they are faster
# and it is therefore important for you to understand how they
# work.

# Vectorized functions within R are known as "apply" functions.
# There are different types of apply commands for different
# types of r objects. We are just going to look briefly at the one
# for data frames, though there are also apply commands for lists 
# and arrays.

# let's try to read our OECD Health files into R using apply. Once
# again, we need a list of the names of the files:

filenames<-list.files("OECD Health Data")

# And now let's paste the file path into them
filenames<-paste("OECD Health Data/", filenames, sep="")
  
# and now let's apply the read.csv command to each file:
data<-lapply(filenames,read.csv)

# just one line! Note that the data is now in list format
# and we'd have to clean it up to make it comparable to
# the data we created within the for loop.

# The important thing isn't the usefulness of this command
# in this context, but in other, larger datasets. The apply
# command is particularly powerful because we can apply 
# whatever function we want to our filenames- either other
# people's r functions or our own.

# the syntax for apply commands can become somewhat opaque
# because they do not spell out the functions. Also, one has 
# to choose the appropriate apply command for the object in
# question. A useful resource on the apply command is this
# blog post: 
# http://www.r-bloggers.com/using-apply-sapply-lapply-in-r/

# One final note: you can speed up plyr and dplyr commands
# by specifying the "parallel processing" options that allow
# r to take advantage of multiple CPUs that you may have on 
# your machine. This can be particularly helpful if you use
# the very powerful Amazon machines- or other cluster computing
# technologies- described in section 4.6 below

# 5: Piping

# At the risk of giving you too many different options for 
# programming, I'm going to introduce you to one of the newer,
# more cutting edge ways of programming in R. This is called 
# piping. 

# Piping is a way of passing data and functions in code without
# initializing or iterating. Many people find it more intuitive
# because it is a) less complex, and b) can be coded in a less
# cluttered manner. 

# let's take a quick peak at the maggritr package

install.packages("magrittr")
library(magrittr)

# The key contribution of this package is the `%>% operator.
# Whatever is on the left side of this operator gets passed
# to the right side.

# Let's look at some data on baby naming from the Social
# Security administration.

install.packages("babynames")
library(babynames)

# The real power of %>% comes when you combine it with other
# packages. Let's combine it with the dplyr package for data
# reshaping/manipulation:

# first, lets take the babynames data and pass it through the
# "filter" command in dplyr which lets us request only names
#where the first three letters start with "Ste." Then we will
# use the group_by function of the same package to reshape
# the data by year and sex. Finally, we will count the totals,
# and plot it using ggplot

library(dplyr)
library(ggplot2)

babynames %>%
  filter(name %>% substr(1, 3) %>% equals("Ste")) %>%
  group_by(year, sex) %>%
  summarize(total = sum(n)) %>%
  qplot(year, total, color = sex, data = ., geom = "line")%>%
  add(ggtitle('Names starting with "Ste"')) %>%
  print

# Notice that we never created a variable, a blank data frame
# or any other object. Once again, for some, this is much easier
# to follow. Regardless of whether you find it more intuitive,
# you would probably agree that it is quicker to write.

# 6: Debugging your code

# Whether you are brand-new to coding or whether you've been
# doing it for years, it is extremely easy to make small mistakes
# that can make your code fail.

# Consider, for example, a for loop that never closes its brackets,
# or a loop that uses the same letter to represent two different
# variables in a model.

# In order to catch these annoying problems, we need to "de-bug"
# our code. Thankfully, R has a number of built in tools as well
# as user contributed packages that can help us do this.

# Perhaps the easiest way to debug your code, however, is right
# here in RStudio.

# You've probably noticed by now that RStudio will try to complete
# the code you write. Once you define a data frame, for example
# it can help you write variable names, etc. It can also help
# you find options within a function.

# You may have also noticed a red dot to the left of your code
# or "Script" window. This describes some type of error. Usually
# it is a syntax error, or some type of code that would result in
# an error message in R.

# This is particularly useful if you are looking at a very large
# amount of code. It may be something as simple as realizing that
# you did not load a package before calling a function.

# RStudio also helps you find where brackets and parentheses
#begin and end in your code.

# RSTudio also has more sophisticated debugging tools that are
# described in detail here: 
# https://support.rstudio.com/hc/en-us/articles/205612627-Debugging-with-RStudio

# One final note on programming. If you want to get into more 
# advanced programming in R, I highly suggest the following 
# site: http://adv-r.had.co.nz authored by Hadley Wickham

