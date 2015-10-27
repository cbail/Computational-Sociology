# SCRIPT FOR CLASS #2, COMPUTATIONAL SOCIOLOGY
# Instructor: Chris Bail 
# Copyright, Chris Bail



Vectors

# Many objects in R are vectors. These are sequences
# of multiple variables. We define a vector as follows

my_vector<-c(1, 3, 4, 9)


# Next, Let's try out some basic operations on 
# numeric vectors:

mean(my_vector)
median(my_vector)
max(my_vector)
min(my_vector)
summary(my_vector)

# Note that vectors can also be sequences of strings

my_word_vector<-c("Roy Williams","Is","The Best")

# often, you will want to grab one variable within a
# vector. This command, for example, selects the third
# number in my_word_vector 

my_word_vector[3]

# Let's pause to try this out. Here's an excercise:
# 1) create your own vector of numbers;
# 2) create a new variable that is the mean of
# your vector

# Example Solution:

my_new_vector<-c(100,200, 549)
average_vector<-mean(my_new_vector)
average_vector


#Matrices

# Vectors are a basic building block of matrices,
# another critical type of object in R. To create
# a matrix, we use the "matrix()" function.

my_matrix <- matrix(c(1,2,1,2, 64000,38000,100000,200000,
                      1,5,17,21 ), nrow = 4, ncol = 3)

# the first value required by this function is a 
# vector of numbers or characters. We use nrow and ncol
# to specify the number of rows and columns.

# to look at our matrix, you can run this line:
my_matrix

# or, you can click on "my_matrix" in the upper-right
# pane of RStudio.

# often, we will need to grab one row of a matrix, or
# one column. To do this, we use the "," operator:

my_matrix[1,]

# The "," operator specifies whether you are requesting
# the rows or the columns of the matrix. To request
# the first column, we would run

my_matrix[,1]

# To get the value of a cell within a matrix, we need
# to tell R about both the row and the column:

my_matrix[1,2]

# 64,000 is the number that is in the second column of the
# first row

Lists

# A third important type of R object
# is a list. Lists are like vectors, but unique
# in that they may contain multiple types of 
# data (e.g. strings, numbers, or even matrices)

# Let's create a list

my_list<-list(9, "Roy Williams", my_matrix)

# Let's take a look
my_list

# Let's say we wanted to grab "Roy Williams" from
# our list. We can just write:

my_list[2]


# "Why are we spending so much time with Matrices and Lists?" 
# you may ask. It is because many forms of programming
# require a basic familarity with matrices and lists, and
# if you get into working with big data you will almost
# surely need o know how to work with them.

#Data Frames

# Matrices and lists are also important because they are 
# the building blocks of what may be the most important
# type of object in R: data frames.

# Data frames are very similar to datasets you might load
# into Stata/SPSS/SAS in that they have rows, columns, and
# column names, etc.

# In order to create a data frame, we can use the 
# following command on our matrix:

my_data_frame<-as.data.frame(my_matrix)

# Note that there is now a new object in the upper
# right "Environment" pane of RStudio. If we click
# up there, we see that R has already chosen some
# arbitrary names for our columns (V1, V2, V3).

# R uses some clunky syntax to change column names.
# This is worth our time, however, because column
# names often change when you are manipulating 
# data

# lets change "V1" to "Sex"

colnames(my_data_frame)[colnames(my_data_frame)=="V1"]<-"Sex"

# But let's say we want to use words instead of numbers to
# describe sex. In this case, we need to change the
# contents of the data frame as follows:

my_data_frame$Sex[my_data_frame$Sex==1]<-"Female"
my_data_frame$Sex[my_data_frame$Sex==2]<-"Male"

# That was a mouthful, huh? The "$" operator is 
# how you tell R that you are looking for a specific
# variable within the data frame.

# now lets look at our data frame

my_data_frame

# Now let's figure out the sex breakdown of our
# data using the "table" command.

table(my_data_frame$Sex)

# Ok, let's step back again so that you can try 
# this out on your own:
# 1) Change the name of the Second column in
# my_data_frame to "Income";
# 2) Calculate the median of the Income variable

# MANIPULATING DATA

# Until now, we have been working at a very 
# abstract level. This is because I needed 
# to teach you some basic concepts before we
# can start to work with real data.

# R Data Files have the extension .Rdata 
# We will work with these soon, but let's 
# begin by pulling in other types of data
# files, because it's unlikely that you 
# will be working with an .Rdata file if 
# you are coming from another program
# such as STATA.

# Importing Spreadsheets

# R has a variety of ways of importing data.
# For example, data often comes in .csv
# format. To read this, we use the read.csv
# command

sample_csv_data<-read.csv("Sample_CSV_Data.csv")

# As the upper right hand pane of RSTudio
# now shows, these data have 9909 observations
# and 406 variables.

# By default, R has assumed that the first
# line of these data are the variable names.
# to list all of the variable names, we can
# write

colnames(sample_csv_data)

# We do not have the dictionary for these data,
# so we can only guess what these codes mean.

# R also treats any strings as factors. This can
# become problematic later if you try to perform
# operations on string variables that are actually
# factor variables

# In order to see the "class" of a variable-
# or whether it is a numeric, character, or 
# factor variable, we can use the class() command

class(sample_csv_data$Institution_Name)

# Yep, it's a factor. If we want to prevent R
# from defaulting to this behavior, we can add
# an option to our read.csv command. Options
# for most commands are specified by a comma
# after the name of the object you want to apply
# the command to.

# to illustrate this point a bit better, let's
# look at the "help" file for read.csv. Earlier
# I said there is no manual for R. The "help" 
# file is the closest thing we've got, and it's
# not always great.

?read.csv

# now we can see that there are many different
# types of options that can be specified. Let's
# try:

sample_csv_data<-read.csv("Sample_CSV_Data.csv", 
                          stringsAsFactors=FALSE)

# this tells R not to import strings as factors. In many
# cases, you will want to add lots of different options
# to an R command. We will get to these cases soon.

# But before we do, let's try to import some other types
# of data. For example, what if you are a STATA user
# trying to make the transition to R so that you can
# analyze some Stata Data using a technique that is 
# only available in R?

#Installing Packages and Importing Data

# To do this, we need to install a new package in R. 
# Until now, we have been using "Base R" which refers
# to all of the standard commands that come when you
# download R. But most users will want to take advantage
# of the rapidly expanding number of packages available. 
# Indeed, some of these have become so instrumental for
# computational sociology that I cannot imagine life without them.

# To open Stata data we are going to use the "Haven"
# package written by a fellow named Hadley Wickham. He
# is one of the most prolific authors of R packages for
# computational social science and is very well respected 
# within the R community.

# To add a package onto R, we use the install.packages
# command

install.packages("haven")

# Though you only need to install a package once you
# must "call" it within individual R scripts as follows:

library(haven)

# You can also do this by writing require(haven)

# Here is where things can get messy. There is a group
# called the R Core Development Team which oversees and
# approves R packages in order to make them more useable.
# in order to get your package approved you have to write
# a help file, so we can write.

# to find these help packages, you can either navigate
# to the "packages" pane of RStudio on the lower right
# pane, or you can google the name of the package to 
# find the CRAN site (This stands for the Comprehensive
# R Archive Network).

# Often you can also find a "vignette" or a pdf document
# that not only explains some of the commands in the 
# package but applies them to real data. These are often
# easier to follow then the help files themselves.

# In this case, I know we want the "read_stata" command:

sample_stata_data<-read_stata("Sample Stata Data.dta")

# note that this "Haven" package also allows you to read
# SPSS and SAS files, and write R files into these formats
# as well.

# If you plan to work with text data or other types of web-
# based data you will probably encounter different types of
# data structures that we do not have time to cover in this
# class, but will be covered in my course on Thursday. For 
# example, JSON data, or html data.

# Subsetting Data Frames

# Manipulating data is a core task of computational social science. 
#A recent New York Times Article suggests 80% of data scientists'
# time is spent cleaning data, while only 20% of their time
# is spent analyzing it. See: 
#http://www.nytimes.com/2014/08/18/technology/for-big-data-scientists-hurdle-to-insights-is-janitor-work.html?_r=0

# This is because many data sets are either unstructured, or semi-
# structured, or because they have large amounts of missing
# data, or because they have to be manipulated in order to
# be analyzed for one reason or another

# First, let's work on subsetting data. This simply means breaking
# up a data frame into chunks. The syntax is similar to that we
# used when we worked with matrices. For example, let's say
# we want to take all respondents from our stata dataset who are
# less than 50. The variable we want is called "age."

respondents_under_50<-sample_stata_data[sample_stata_data$age<50,]

# Once again, this is some tricky syntax. We first need to tell R
# which dataset we want to manipulate. Everything inside the 
# parentheses is our instructions to R about what subset we want.
# Remember that the "," before the last "]" here is critical. 
# We are are telling R that we want all rows that meet the criteria.
# This is also the first time we have used a "logical operator"
# in this case "<" you can also use ">" and "<="

# There are also a variety of useful commands to identify missing 
# data. This is important because often when one is working with
# big data one cannot simply eyeball the data to identify patterns
# of missing-ness.

# First, let's drop all rows of the dataset that have any missing
#data. To do this, we use the complete.cases() command:

no_missing_data<-sample_csv_data[complete.cases(sample_csv_data),]

# this dropped every single row. This is because of the structure
# of this dataset (certain questions were asked of some respondents
# but not others).

# more often, you might want to identify all rows that are missing
# data on one single variable in order to identify patterns of 
# missingness. Let's load some new data from the Dropbox in
# order to illustrate this

pewdata<-read.csv("Sample_Pew_Data.csv")

# working with different datasets is useful because it gives you
# a sense of the range of different problems you might encounter
# with data cleaning. In this data set, for example, missing data
# was coded as 9 instead of "NA" (or empty cells, which R would
# have read in as NA). 

# lets look at missing data on the "pew10" variable, which is about
# whether people supported the construction of the "Ground Zero"
# mosque in New York in 2011. First, let's change the 9's to NAs

pewdata$pew10[pewdata$pew10==9]<-NA

missing<-pewdata[is.na(pewdata$pew10),]

#If we want to take all the values where "pew10" is NOT
#missing, we would do this:
  
no_missing<-pewdata[!is.na(pewdata$pew10),]

# Note that is.na() is a logical operator. If we write

is.na(pewdata$pew10)

# we see TRUE/FALSE values for each row of the data frame on this
# variable.

#Recoding Variables 

# now lets say we wanted to find all of the men with missing data. 
# First let's find the variable

colnames(pewdata)

# now let's see how the variable is coded
table(pewdata$sex)

# Looks like 1s and 2s. I happen to know that 1=Male in these
# data, so:

missing<-pewdata[is.na(pewdata$pew10)& pewdata$sex==1,]

# Note again that we need the "," because we are telling R
# we want the rows. If we wanted to trim columns from the data
# we would need to put the content we want after the ","-
# we can either use the numbers of the columns or their names. Let's
# say we just want the two variables we've been working with so
# far:

gender_and_mosque<-pewdata[,c("sex","pew10")]

# remember that the "c()" operator is necessary here because we
# are asking for multiple variables. 

# let's say we wanted everything but the first column in the dataset.
# First we would need to know the number of columns. We can use 
# ncol() for this purpose

ncol(pewdata)

# Then we simply tell R we want rows 2 to 52 using the ":" operator,
# which indicates a sequence.

no_first_column<-pewdata[,2:52]

# I also want to note that we could combine the two steps as follows:

no_first_column<-pewdata[,2:ncol(pewdata)]

# I'm noting this because it will be helpful to know that this is 
# possible when we discuss programming later in this class.

# You now know the basics of manipulating a data frame in R. Let's
# pause for another exercise:
# 1) Figure out the age of the oldest man in the dataset

#Reshaping Data Frames

# Another very common task in computational sociology is reshaping data. For
# example, suppose we wanted to examine partisanship by race. The
# Patyln variable describes the following question within the Pew Data:
# "As of today do you lean more to the Republican Party" or more to The
# Democratic party" The possible answers are 1: Republican, 2: Democrat;
# 9: Missing.

# It's annoying that these are not already correctly coded, but this is
# a common task in computational sociology, so first, let's recode the numeric
# data into strings or characters:

pewdata$partyln[pewdata$partyln==1]<-"Republican"
pewdata$partyln[pewdata$partyln==2]<-"Democrat"
pewdata$partyln[pewdata$partyln==9]<-NA

# let's check to make sure it worked:

table(pewdata$partyln)

# Now we also need to recode the race variables. 

pewdata$race[pewdata$race==1]<-"White"
pewdata$race[pewdata$race==2]<-"African American"
pewdata$race[pewdata$race==3]<-"Asian or Pacific Islander"
pewdata$race[pewdata$race==4]<-"Mixed Race"
pewdata$race[pewdata$race==5]<-"Native American"
pewdata$race[pewdata$race==6]<-"Other"
pewdata$race[pewdata$race==9]<-NA

table(pewdata$race)

# we can get a cross tab by doing this:
table(pewdata$partyln, pewdata$race)

# Just for fun, let's save our cleaned up dataframe
# in R format- we'll use it for some analysis tomorrow
save(pewdata, file="Pew Data.Rdata")

# but let's say we want the average age by race. As is 
# common with R, there are many different ways to do this.
# let's continue using base R. For the record, one could use
# the "plyr" package, the "reshape" package, and the 
# "data.frame" package, just to name a few.

aggregate(pewdata$age, by=list(pewdata$race), FUN=mean)

# What if we want the average age by both race and party?
aggregate(pewdata$age, by=list(pewdata$race, pewdata$partyln), FUN=mean)

# And once again we could store these data as follows:

age_by_race<-aggregate(pewdata$age, by=list(pewdata$race), FUN=mean)

# Merging Data Frames 

# Another very common task you might face in R is merging multiple
# datasets. This is one of the most common tasks you might encounter 
# in data cleaning and manipulation precisely because R can have
# so many objects loaded in memory at once.

# Imagine, for example, that we want to add average income by race
# to our dataset that describes average age. I put a very
# small spreadsheet in the Dropbox that describes average
# income by race.

race_income_data<-read.csv("Income By Race.xlsx")

# this gives us an error, because this is an .xlsx
# file, and not a .csv file. This is a total pain.
# Because the file is so small, we might be tempted to 
# either a) open Excel and save it as .csv or b) 
# just input the data manually into R.

# But what if this dataset were huge, or had some funky
# character encoding that would be lost if you saved it
# as .csv? This is a common problem when working with
# big data.

# In this type of situation, you would need to do some
# research. I said earlier that R does not have a manual
# One can, however, search for R help via RSTudio by typing
# ?? before the search term
??xlsx

# Bit this is a bit confusing, it does not give us good
# advice on which of these packages might be best, or why
# A better solution is simply to google your problem
# let's try "Import .xlsx into R"

# The very first result comes from a site called "Stack
# Overflow. In my opinion this is by far the most reliable
# site for information about R, and other programming 
# language as well. This is because it boasts an extermely
# large and diverse user base, a sort of "hive mind"

# Here is the site:
# http://stackoverflow.com/questions/7049272/importing-xlsx-file-into-r

# At the top of the page is a user who is asking a question
# The question gets "votes" that indicate how important it
# is for the question to be answered.

# First, there are a variety of comments on the question, asking
# for clarification or recommending other resources.

# Below, there are answers. First, note that there are eleven
# answers to the question! This shows both the potential and the
# disorganization of R. Which answer is best? Each answer gets
# votes by other users, so we can see here that the best answer
# is the first one. (You should also note that individual users
# have different reputation scores, and you might use those as
# a guide as well).

# The consensus on this page is to use the XLConnect package. 
# first, we need to install it:

install.packages("XLConnect")

# let's try it out
race_income_data <- readWorksheet(loadWorkbook("Income By Race.xlsx"),sheet=1)

# It didn't work. Why? Because we did not call the packages.
# Let's try again:

library(XLConnect)
race_income_data <- readWorksheet(loadWorkbook("Income By Race.xlsx"),sheet=1)

# That was a lot of work for a little reward, but again
# the point was to help you learn how to resolve a real-
# world type of situation.

# Ok, now that we have finally read the data into R
# we can now merge it together with our data frame.
# We could do this within base r using the "merge"
# command, but it is a bit clunky. Most folks now
# prefer to use the "plyr" package because it is 
# faster and more intuitive. 

install.packages("plyr")
library(plyr)

#The command for merging datasets is called "join"
merged_data<-join(age_by_race, race_income_data)

# This looked like it worked, but if we view the 
# merged dataset, we see that it added NAs instead
# of the values

View(merged_data)

# Why? This particular command from the plyr package
# automatically searches for column names that are 
# shared by both files. Let's check things out with 
# colnames()

colnames(age_by_race)
colnames(race_income_data)

# When we ran the "aggregate" command above, it gave
# the columns new, arbitrary names. We need to fix
# the column names so that they are the same across
# The datasets

colnames(age_by_race)[colnames(age_by_race)=="Group.1"]<-"race"
colnames(age_by_race)[colnames(age_by_race)=="x"]<-"age"

# Let's try to merge again

merged_data<-join(age_by_race, race_income_data)

# Once again, it looks like it worked. But if we view
# the data again, we see that only the income of 
# Whites was added. 

# Note that R did not give us an error message. This
# is because it did exactly what we asked it to do:
# merge all the rows that could be merged. But this
# is the type of easy mistake that can create major
# headaches further down the line. This is why it's
# important to always view or table() your dataframes
# after you manipulate them.

# In order to diagnose the problem, lets table race
# in both dataframes

table(age_by_race$race)
table(race_income_data$race)

# Aha, we can now see that most of the races were not
# merged because they were only in one of the two
# data frames. We ALSO see that the African American
# row in the age_by_race data frame was not merged
# because the race_income_data uses the term "Black." 
# The terms for Asians also need to be recoded
# Let's change this so that our merge will work:

race_income_data[race_income_data=="Black"]<-"African American"
race_income_data[race_income_data=="Asian"]<-"Asian or Pacific Islander"

# And now let's try the merge again

merged_data<-join(age_by_race, race_income_data)

View(merged_data)

# finally, it worked.

# This is the conclusion of the first Day of this Class.
# My goal was to help you get R up and Running and master
# some of the basic object types and data manipulation
# commands. These are by far the most frustrating parts
# of learning R. Tomorrow, we will begin to get to analysis,
# visualization, and programming, which is really where
# R begins to shine.






