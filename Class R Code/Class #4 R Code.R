# SCRIPT FOR CLASS #4, COMPUTATIONAL SOCIOLOGY
# Instructor: Chris Bail 
# Copyright, Chris Bail


# INTRODUCTION

# This class is designed to introduce you to the basic techniques
# for collecting large corpora-- or text-based data-- using R. 

# For example, the techniques you will learn in this class can be used
# to scrape text data from websites, extract social media messages or
# other types of texts from sites such as Twitter, Facebook, or Google, 
# or automate the collection of text using other internet-based tools.

# When people think about large text-based data sets, they tend to think
# immediately of social media sites or blogs. Yet one of the most 
# exciting things about recent years is that we are witnessing vast
# archive of historical archives as well. 

# Consider, for example, Google's nGram dataset, which is based upon
# digital copies of nearly every book in the English language, and many
# other languages as well. It is also increasingly easy to get historical
# newspaper data or television transcripts. Librarians across the world
# are rapidly digitizing hand-written texts from across the ages.

# These new wellsprings of data present unprecedented possibilities for
# academics, yet they also raise a number of new challenges. Fortunately,
# the fields of computer science and computational linguistics have 
# jointly produced a suite of new tools that make our job easier.

# Though we once had to hire teams of research assistants to collect, 
# standardize, and analyze large corpora, a single computer or group of
# computers can now do this to text-based datasets that are so large that
# human coders could never analyze them all.

# But these new techniques will be unfamiliar to you if you come from a 
# conventional statistics background. Text-based datasets do not come
# prepackaged. Instead, they are unstructured and usually very messy. 

# This is often because automated collection of texts often produces 
# texts that are formateed or structured differently. The first task 
# we will discuss in this class is simply how to automate collection
# of texts via the internet.

# COLLECTING TEXT-BASED DATA

# Before I describe automated techniques for collecting text-based data
# I'd like to point out that there is already a vast amount of data 
# out there that has already been compiled. For example, the New York
# Times offers a large dataset of its articles, as does Reuters. Google
# also makes is nGrams data available to the public. There are also a
# variety of archives of Wikipedia data.

# It is important to ask yourself whether you might be able to take 
# advantage of text-based datasets that someone else has collected 
# because you may be underestimated the amount of time it takes to collect
# vast amounts of data. On the one hand, new technologies make this
# easier than ever, but on the other hand the inherent messiness of
# automated text collection-- from inconsistent file formats to spelling
# differences to character encoding problems-- can make collecting
# your own text-based datasets quite a hassle.

# But if you are here, it is probably because you want to learn how
# to build your own datasets. And this is probably where the greatest
# value added is given that this is really a new frontier.

# 1.1 Screen-Scraping.

# Unfortunately, however, we are no longer in the "Wild Wild West" of big
# data. Only several years ago one could easily mine or "scrape" vast amounts
# of data from giant archives of information such as Google or Amazon.

# Yet major corporations have become wise to the value of their data, and the
# vast majority of sites now prevent you from scraping large amounts of data.
# There are some important exceptions to this, but by in large, sites such as
# Facebook, Twitter, or JSTOR will shut you down if you try to grab too
# much text in an automated fashion.

# I should also warn you that automated collection of text-based is also 
# often not only discouraged, but illegal. Years ago, several academics
# got into considerable trouble with Facebook and Google for trying to
# scrape data from these sites. To determine whether you can safely 
# automate data collection from a site, you need to visit its "Terms 
# of Service," which is a legally binding document that describes how 
# developers (in this case, you!) may interface with a site.

# Despite all of these issues, the first technique I want to teach you today is something called "screen-scraping." 

# Screen scraping refers to a type of computer program
# that reads in a web page, finds some information on it, grabs the
# information, and puts it into a spreadsheet or other type of data
# storage format.

# When we look at a web page, we typically see something that is very easy
# to digest. There is some combination of text and images in a relatively
# small number of formats that we have been taught to digest easily.

# But this is not what a webpage looks like to a computer. And if we want
# to teach a computer to grab information from a web page for us, we need
# to assume the perspective of a computer.

# To a computer, a webpage is a long list of formatting rules, scripts, text,
# and audio-visual data that is all put together in one of two common formats:
# HTML or XML. These long lines of code tell the website how to assemble text, # images and video on the vast range of devices that might try to load the 
# page. It also generally shapes the "look" or "theme" of the website, and
# how data is stored. But none of this is very important to understand in
# detail unless you are interested in building websites.

# Let's look at an example. Consider, the following Wikipedia page about
# the World Health Organization's Ranking of Different Countries' Health
# systems: 

#https://en.wikipedia.org/wiki/World_Health_Organization_ranking_of_health_systems_in_2000

# To do screen scraping, we need to find the "Source Code," or the messy
# list of instructions that a computer needs to display this page in the 
# format we see before this.

# There are a variety of ways to see the source code of a website, but 
# the easiest way is typically to use your web browser. In Chrome, for
# example, we can go to the dropdown "View" menu, and then select 
# "Developer" and then "View Source."

# Messy, huh? At the top of the source code we can see that this document
# is an HTML file. We will need to know whether a site is in HTML or XML
# because it will determine the type of tools we use in R to scrape it.

# In order to get a better feel for how the source code relates to the website
#, let's navigate back to the wikipedia site:

#https://en.wikipedia.org/wiki/World_Health_Organization_ranking_of_health_systems_in_2000

# Let's say we want to scrape the data from the table on this page.
# To do this, we are going to need to find out where this information is
# within that messy HTML code.

# Fortunately, there are a number of useful tools we can do to find this
# type of information. In Chrome, for example, we can right click on the 
# part of the webpage we want to scrape, and click "inspect element."

# Now, when we mouse over the messy code in the text, Chrome highlights
# the part of the page that this code creates. So if we move our mouse
# around until it highlights the table, we can start to identify the part
# of the code we need to scrape it. The thing we need is called the "xpath"
# To get the xpath, we can again right click and Chrome gives us the option
# to copy it to our clipboard.

# In my view, the best R package for screenscraping at present is the "rvest"
# package, which was written by Hadley Wickham. R used to lag behind other
# languages such as Python for web scraping, but rvest basically takes all the
# best parts of these other languages and ports them into R.

# The first thing I'm going to do is set our class dropbox as my
# working directory:

setwd("/Users/christopherandrewbail/Desktop/Dropbox/Teaching/Computational Soc Fall 2015/Course Dropbox")

# note: the file path will be different on your machine!

# The first thing we need to do is install rvest:

install.packages("rvest")

# Next, we need to remember to load rvest into our r code/r session

library(rvest)

# The first thing we need to do is to pass all of that messy source code
# from the web and into r. To do this, we use the html() command:

wikipedia_page<-html("https://en.wikipedia.org/wiki/World_Health_Organization_ranking_of_health_systems_in_2000")

# Here I've created an object called "wikipedia page" that we are going
# to reference in the rest of our code. If we type "wikipedia_page" we will
# see all of that nonsense:

wikipedia_page

# HTML is broken up into sections that are called "nodes." The xpath tells
# R which section we want. To get that section, we use the html_nodes()
# command as follows:

section_of_wikipedia_html<-html_nodes(wikipedia_page, xpath='//*[@id="mw-content-text"]/table[1]')

#Once again, this object is going to be messy:

section_of_wikipedia_html

#But fortunately rvest has a command that let's us grab tables within
#HTML sections, it's called "html_table()

health_rankings<-html_table(section_of_wikipedia_html)

# ..And voila. We have now scraped the health rankings data from Wikipedia

health_rankings

# It's still in a somewhat messy format though. In fact, let's check to
# see what type of format it is in:

class(health_rankings)

# It's a list. To convert this to a data frame that we could easily
# work with, we can simply write:

test<-as.data.frame(health_rankings)

# Unfortunately, many sites are not as "friendly" to automated text
# collection as Wikipedia, which is not only decidely "open" to anyone
# but also very consistent in the way it formats information.

# On messier sites, the "inspect element" trick in Chrome might not work.
# But there is another way around this. Instead of getting the "xpath" we
# can get something called the "css selector." 

# The easiest way to do this it to download a plugin for chrome called 
# Selector Gadget. This is a tool that you can load when you look at a 
# webpage in order to find the css selector in the html code.

# This website explains how to use it:

#http://cran.r-project.org/web/packages/rvest/vignettes/selectorgadget.html

# If you drag the link on this page onto the bookmarks bar, you can load the
# selectorgadget anytime you are on a website you want to scrape.

# The next step is to click on the stuff you want to scrape, and then click
# on something you DO NOT want to scrape. This helps the tool figure out
# exactly how to describe what you want on the page. IT IS NOT PERFECT THOUGH.
# Once again, different pages use different formats, but some combination
# of this method with the Chrome/INspect Element method should work for
# most webpages.

# Why don't we scrape a list of the 100 Twitter Users with the largest
# numbers of followers so that we can use it when we work with Twitter in 
# just a bit.

# Here is the link to the page:

# http://twittercounter.com/pages/100"

# After using the SelectorGadget tool, I determined that the 
# css Selector for the data we want is called ".name-bio."

# To get the data, the process is almost identical to our
# last example, except that we replace the xpath= with css=

toptwitter<-html("http://twittercounter.com/pages/100")
toptwitternodes<-html_nodes(toptwitter, css=".name-bio")
names<-html_text(toptwitternodes)

#Unfortunately, the html_table does not work, because the node
#we selected is not a table, but just plain text, so we need to
# run the code using the "html_text()" command:

toptwitter<-html("http://twittercounter.com/pages/100")
toptwitternodes<-html_nodes(toptwitter, css=".name-bio")
names<-html_text(toptwitternodes)

#Let's take a look

names

# The data we want is in there, but it's surround by a bunch of odd
# characters. These characters are telling the webpage how many spaces to
# put in between the text.

# Cleaning up messy text like this in R is a very common challenge.
# One can approach the problem in a variety of different ways, but 
# I am fond of using the "gsub()" command.

# The gsub command finds one character string and replaces it with another.
# This line tells R to find the "\n"s and replace the with "" which means
# nothing.

names<-gsub("\n","", names)

# THe last argument simply tells R the name of the object we want to apply
# this text transformation to.

names

# This got rid of the "\n"s but not the "\t"s but to get rid of those,
# we can just add another line of code:

names<-gsub("\t","", names)

#Let's check it out:

names

#Getting closer, but we are going to want to split up the names and the
# Twitter addresses, which begin with "@"

# To do this, we can use the "strsplit" command:
names_data<-(strsplit(names,"@"))

#This command simply tells R to split each string into two when it
# encounters the "@" character

names_data

# It's split, but it's still in a funky format. Let's find out which
# one:

class(names_data)

# It's a list, and we are going to want a data frame once again. Let's
# use an apply function to extract the names and twitter handles in
# separate steps:

twitter_names<-sapply(names_data,"[",1)
twitter_handles<-sapply(names_data, "[", 2)

#Let's just make sure that they are now character vectors:
class(twitter_names)

# now we can simply bind them together using "cbind" and 
# as.data.frame()

twitter_data<-as.data.frame(cbind(twitter_names, twitter_handles))

# Now you know the basics of screen scraping. But there are two
# more things you need to know about. First of all, if you are scraping
# an XML website you can use other functions such as XML2R. There is
# A nice tutorial on this here:

#http://cpsievert.github.io/slides/web-scraping/#1

# One more thing. Often, you don't want to scrape just one website,
# but many websites. This means you need to generate a list of website
# that you can then pass through a "for" loop and extract whatever 
# type of data that you are searching for.

# IF you are trying to repeatedly scrape one website for lots of sub
# pages, you may be able to recognize patterns in the way that the 
# URLs are formed, and then use "gsub" or "paste" commands to change
# your url calls to collect HTML or XML.

# By now you can probably tell that some screen scraping exercises
# are much easier than others. It simply depends upon the structure
# of the website, and its overarching structure.

# As I mentioned earlier, many sites now have functions that stop
# you from scraping them. If you try to request to many different
# sub-sections of the same site, for example, you will eventually
# get an error that says something about "authentication" or an'
# "SSL" error, or an "OAuth" error.

#WORKING WITH AN API

# Sites that block you- which are unfortunately most of the sites you
# might want to scrape- usually offer a powerful alternative: an
# Application Programming Interface (API)

# An API is a type of web infrastructure that enables a developer (you)
# to request large amounts of specific information from a website. The
# Website then creates a new URL that contains the data you request,
# and you scrape it. This has become such an important part of the web
# that most large websites now have APIs (e.g. Google, Twitter, Facebook
# even the New York Times)

# APIs Are called Application Programming Interfaces because may of the people
# who use them are building apps. For example, a music sharing website
# might want to build an app that helps people expose their friends to
# new types of music. But to do this it needs to request permission to
# extract certain types of information about the person from a site
# such as Facebook.

# But Facebook obviously can't give them all the info. Facebook needs to
# make sure that the person wants them to access their data. They also
# need to make sure the app develop can only access certain types of data
# and not all the data that Facebook has.

# To do this, Facebook- and other sites that have APIs- have "authenticat# ion tokens," or "access keys." These are simply codes that you need to # give  when you request data from an API.

# Let's take a look at how the Facebook API works using the "Facebook
# Graph API Explorer. This is a website that lets you see how an
# API works, also known as a "sandbox":

# https://developers.facebook.com/tools/explorer

# try typing "me/friends" into the search bar below the text "FQL Query." # This is a tool that shows you what the results would look like if you #made this API request. 

# what it is actually doing is forming the URL request and then showing  you the JSON-format data that would load if you pasted the URL in your browser.  

# Most sites that have APIs do not have this type of "sandbox." but
# learning how to master working with them is a really nice to skill because
# there are so many APIs out there.

#At present, there are more than 13,000 APIs. You can see a list of them here: http://www.programmableweb.com/category/all/apis?order=field_popularity
# Academics may be interested to know that many data archiving sites now offer
# APIs (such as ProQuest). Many are free to use, but others cost significant
# amounts of money. 

# Most APIs have "rate limits" which determine how many
# requests for information a developer (you) can make within a certain time frame


# In R, you can either interact with an API by forming requests for data within
# a loop and "scraping" the resultant data from URLS "by hand," or you can
# use a variety of user-generated packages to collect data.

# Because we already covered screen scraping, let's look at one of these packages. Let's start with the twitteR package.

install.packages("twitteR")

#The instruction manual for this package is here:
  
# http://cran.r-project.org/web/packages/twitteR/twitteR.pdf

# The first thing you need to do is register as a developer with Twitter.
# in order to do this, you need to visit this page:

# apps.twitter.com 

#Unfortunately, if you don't have a Twitter account, you'll have to make one,
# or follow along on your neighbor's laptop if they don't mind.

#THe next step is to click on "Create New App." You need to name your app, and 
# provide some other credentials. It really does not matter much what you
# put in here, because we are not building an app that other people are going
# to use. I just put in my own website. You can leave the "Callback URL field blank."

# Our goal in doing this is to obtain a Twitter API Key which we need to extract
# Any data from Twitter. TO do this we need to scroll down to the "Application
#Settings section, and then click the blue "manage keys and access token" link
# That is to the right of our Consumer Key

# The next thing we need to do is tell the twitteR package what our secret
#login details are. I can't write mine in here because if this information
# got out a hacker could use it to pose as me, or get data collected by my
# app which I might not want her or him to have.

setup_twitter_oauth(consumer_key="TEXTOFYOURKEYHERE",
                    consumer_secret="TEXTOFYOURSECRETHERE",
                    access_token="TEXTOFACCESSTOKENHERE", 
                    access_secret="TEXTOFACCESSSECRETHERE")


# When we run this last line, it will ask us if we want to use a 
# local file to store these "credentials." I am going to say "no"
# and load these into R each time I need them.

# What this twitteR package is doing for us is simplifying some of
# the complex URL requests we would need to put in each URL call
# we make to the TWitter API. Once all of our authentication
# information is in the system, we have a range of useful commands
# available to us.

#First, we can define a Twitter user whose information we want to scrape
# you can use my name, or feel free to put in your own name
# instead of mine

user <- getUser("chris_bail")

# Let's get a list of my "friends"- by friends, the author of this package is referring
# to the name of the people that I follow on Twitter:

friends<-user$getFriends()

# Now let's get a list of people who follow me on Twitter:
followers<-user$getFollowers()

#We can also get a list of all my favorite Tweets:
favorites<-favorites(user)

#This package also has some nice commands for formatting these
# data as data.frames:

friendsdata <- twListToDF(friends)
followersdata <- twListToDF(followers)

#This the command I would use to get a user's tweets:
tweets<-userTimeline(user)

# I mentioned earlier that Twitter will set shut us
# down if we ask for two much data. this command
# let's me see the limits on what I can do
# within a given time frame:

getCurRateLimitInfo()

# Remember that list of top twitter accounts we got?
# Let's see if we can scrape network data from these folks.
# First, let's remind ourselves what these data look like:

head(twitter_data)

# So what I am going to want to do is create a for loop
# where I make each person the "user" in each iteration
# and scrape the names of the people they follow:

# Create a blank data frame to store data we scrape
twitter_network_data<-as.data.frame(NULL)
# figure out how many rows we have to scrape
z<-nrow(twitter_data)

# start for loop that gets names of people the user
# follows and append them to the dataset we 
# just created. Finally take a break between
# pulling each user's Twitter data in order
# to prevent Twitter rate limiting kicking in:

for(i in 1:z){
  user <- getUser(twitter_data$twitter_handles[i])
  people_user_follows <- user$getFriends()
  people_user_follows<-twListToDF(people_user_follows)
  people_user_follows$name_of_user<-twitter_data$twitter_handles[i]
  twitter_network_data<-rbind(twitter_network_data, people_user_follows)
  Sys.sleep(60)
  print(i)
}

# We don't have time to run this loop together, it will take quite a bit
# of time to run. 


## There are many many more R packages for working with APIS:
## Here are a few: `RgoogleMaps`, `Rfacebook`, `rOpenSci`
##(this one combines many different APIs e.g. the Internet Archive),  
##`WDI`,`rOpenGov`,`rtimes`
##Many more are available but not yet on CRAN (install from 
##github or using devtools)

## There are also APIS that you can use to do analyses, like plotly
# for visualization.

# But there are still APIs that don't have R packages (many of them)

# Let's pretend there was no R package for Google Maps, what would we do?
# first: look for patterns
# https://maps.googleapis.com/maps/api/geocode/json?address=Durham,NorthCarolina&sensor=false
# In this case, address goes between the first** `=` **and the** `&`

findGPS <- function(address,sensor = "false") {
  beginning <- "http://maps.google.com/maps/api/geocode/json?"
  paster <- paste0(beginning,"address=", address, "&sensor=false")
  return(URLencode(paster))
}

findGPS("Durham, North Carolina")

# let's put it all together

page<-findGPS("Durham, North Carolina")
gpscoordinates <- fromJSON(page)
latitude <- gpscoordinates$results[[1]]$geometry$location["lat"]
longitude <- gpscoordinates$results[[1]]$geometry$location["lng"]
gps<-c(latitude, longitude)
gps

# we could then wrap them in a loop.




