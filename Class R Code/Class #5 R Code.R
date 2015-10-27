# SCRIPT FOR CLASS #5, COMPUTATIONAL SOCIOLOGY
# Instructor: Chris Bail 
# Copyright, Chris Bail


# INTRODUCTION

# What can we do with all of the data we collected last week given that
# we can't read it all by ourselves?

#Fortunately,
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

# But in order to analyze the large amounts of texts that can be analyzed
# using these methods, we need to do something equally challenging: we
# need to transform these texts into numbers, so that they can we can
# classify them using automated tools for text analysis such as topic
# modeling. 

# first, we need a large corpus of documents. You may already 
# have these, but we are going to grab ours from the internet. To
# create our corpus, we are going to use the "tm" package
# in R:

#install.packages("tm")
library(tm)

# Next, I'm going to read in that political blogs data from our dropbox:

blog_data<-read.csv("poliblogs2008.csv", stringsAsFactors = FALSE)

# One of the key commands in the tm package is the "corpus" command. This
# creates- you guessed it- a corpus! We need to tell it the name of
# the variable from the data set we want to import, and we also need to tell it that this  object is a dataset, since the command can also be used to import a directory of text files or other types of data

#first let's figure out the names of the blog_data dataset:

colnames(blog_data)

# The one we want is called "documents," let's check one out:

blog_data$documents[1]


#did you notice the funny text in there (e.g. \xe5\xca ?). This happens if you don't have the correct character encoding
# I'm going to clean up the character encoding before we work with

blog_data$documents <- iconv(blog_data$documents, "latin1", "ASCII", sub="")


blog_corpus <- Corpus(VectorSource(as.vector(blog_data$documents))) 

# That's it! Now our data are in "corpus" format, which is going
# to let us begin to do run basic text processing commands on our
# blog posts, and eventually automated forms of content analysis
# known as topic modeling.

# We could of course code all of these blog posts by hand, or hire
# a team of undergrads to do this for us, but this would create a
# number of probems ranging from coder-burnout to inter-coder reliability

# The only alternative to hand coding used to be word count analysis, where
# one simply counts the number of times a word appears in a document. Over
# the past 10 years or so, however, we have taken leaps and bounds in the
# field of automated text analysis.

# I could introduce you to many different ways of classifying text, but
# for now, we are going to focus on the most popular method at the moment:
# topic modeling.

# Topic modeling is an automated technique that looks at patterns of how
# words co-appear within documents in order to classify them into latent
# groups of topics.

# This technique is not perfect, as we will see, but it is much much better
# then keyword analysis. This is because it is better at recognizing the 
# polysemy of words-- that is, how words can take on different meanings
# if they occur next to other words. 

# We don't have time to get into the math of topic modeling, but I will 
# just briefly tell you that the methods we are going to use are based upon
# a probabilistic Bayesian method known as Latent Dirichlet Allocation,
# which is often abbreviated as LDA.

# Unfortunately, we cannot just run a simple "lda" command on the corpus
# we created in the previous section of this class. This is because lda
# must analyze numbers, and not words. More specifically, lda requires
# us to create a document term matrix, or a set of numbers that describe
# where different words occur across documents. These are the data that the
# lda algorithms actually analyze.

# But even before we create a document term matrix, we need to make some
# important decisions. It is common practice in the field of "Natural 
# Language Processing" to pre-process text. This is because most text is 
# messy- it contains punctuation, variations in spelling, and other
# problems that make the lda algorithms less effective.

# for example, right now our corpus includes dashes (-) do we really want
# our algorithm to treat this-- or any other punctuation mark-- as a "word"
# that should carry a meaning? Probably not. Fortunately, the tm package
# can remove all punctuation as follows:

blog_corpus <- tm_map(blog_corpus, content_transformer(removePunctuation)) 

# Also, if we replaced all words in our document with unique identifiers 
# right now, the words "dog" and "Dog" would be treated differently 
# because one includes a capital letter and the other does not.

# This command will make all the words lowercase to get around this
# problem:

blog_corpus <- tm_map(blog_corpus,  content_transformer(tolower)) 

# to a computer, even a space in between words is treated is something
# that is meaningful, so believe it or not we need to ask R to 
# remove spaces before or after a word from our dataset:

blog_corpus <- tm_map(blog_corpus , content_transformer(stripWhitespace))

# Next, we need to decide what we want to do with extremely common words
# such as "and" or "the." As soon as we move from words to numbers, all
# words are treated equally, but we know that these very common words
# are not going to add much meaning to our analysis.

# very common words are often called "stop words" or words we don't want
# to include in our analysis. I put a csv file that contains a popular
# list of stop terms in the dropbox, let's read that in, and use it to
# remove those words from our corpus:

stoplist <- read.csv("english_stopwords.csv", header=TRUE, stringsAsFactors = FALSE)
stoplist<-stoplist$stopword
blog_corpus  <- tm_map(blog_corpus , content_transformer(removeWords), stoplist)

# I want to pause and note that there some within the field
# who believe stop words should not be removed. Some people believe we
# lost important context. For example the phrase "I hate the president," is
# much much different than "I'd hate to be president" but if we remove stop
# words, both phrases would be reduced to "hate" and "president."

# Another somewhat controversial issue is whether you should "stem" words.
# Stemming means taking a word like "gladly" and transforming it into
# its root word, which is "glad."

# This is actually a very complex task that requires some sophisticated
# databases, fortunately, the tm package handles all of that for us
# by calling data from some other websites

blog_corpus  <- tm_map(blog_corpus , content_transformer(stemDocument), language = "english")

# Ok, we are now finally ready to create our document- term matrix. 
# The command for this in the tm package is:

Blog_DTM <- DocumentTermMatrix(blog_corpus, control = list(wordLengths = c(2, Inf)))

# I've asked R to only create the matrix for words that are great than 2 
# characters long. This is to get rid of some messy stuff that was created
# throughout the text pre-processing stages described above.

# Betcha can't wait to look at your first Document-Term matrix, huh?

inspect(Blog_DTM[300:310,1000:1002])

# some words hardly ever appear in any documents. In order to handle such 
# words, we can drop them from our document term matrix because it
# makes our topic models perform a bit better (they don't struggle
# to figure out what to do with these rare terms):

DTM <- removeSparseTerms(Blog_DTM , 0.990) 

#I've now removed terms that only appear in .01 of all documents.

# Now that all of our words are properly cleaned, let's take a look
# at some of the most popular terms. The following line finds all
# the words that occur more than 3,000 times in the dataset

findFreqTerms(DTM, 3000)

# This is a good step to get a sense of whether or not there 
# are still words in your document term matrix that you do 
# not want to exert undue influence upon your topic models.

# Ok, now we are ready to run a topic model.... finally!

# One downside of topic models is they do not automatically
# figure out how many topics exist in corpus. Ideally, 
# we would have a sense of how many their might be. Let's
# take a wild guess and say there's seven topics-
# just for the purpose of illustration. 

# the number of topics in the lda package is controlled
# by a parameter called k:

k<-7

# Now we need to set a bunch of additional parameters. We
# don't have time to walk through what each of these mean
# right now. Unfortunately. Some of them help us ensure
# that we can get reproducible results, others help us
# asset the fit of our model.

control_LDA_Gibbs <- list(alpha = 50/k, estimate.beta = T, 
                          verbose = 0, prefix = tempfile(), 
                          save = 0, 
                          keep = 50, 
                          seed = 980, # for reproducibility
                          nstart = 1, best = T,
                          delta = 0.1,
                          iter = 2000, 
                          burnin = 100, 
                          thin = 2000) 

# Ok, now let's reate a topic model using the "Gibbs" Sampling method, and the
# "control" parameters we just declared. Also, we need to install the "lda" 
# package

#install.packages("topicmodels")
library(topicmodels)

my_first_topic_model <- LDA(DTM, k, method = "Gibbs", control = control_LDA_Gibbs)

# And then we can look at which words are associated with which topic. Here we look at the top 20 words by topic.

terms(my_first_topic_model, 30)


# I mentioned earlier that there is no way to figure out the appropriate number
# of topics, but we can look at shifts in the log likelihoods produced by
# the LDA and try to identify the point where the curve flattens out. 

# To do this, however, we have to repeate our LDA again and again. For example,
# this code will run models that have everywhere from 2 to 35 topics

many_models <- mclapply(seq(2, 35, by = 1), function(x) {LDA(Blog_DTM, x, method = "Gibbs", control = control_LDA_Gibbs)} )

# Hat tip to Achim Edelman for this nice function!

many_models.logLik <- as.data.frame(as.matrix(lapply(many_models, logLik)))

# We can then plot the results to see where we get decreasing returns for
# increasing the number of topics:

plot(2:35, unlist(lda.models.gibbs.logLik), xlab="Number of Topics", ylab="Log-Likelihood")

# Once we choose the best number of topics, we can change k and 
# run our model again

k<-10

my_first_topic_model <- LDA(Blog_DTM, k, method = "Gibbs", control = control_LDA_Gibbs)

# And if we want to see how each document gets assigned to each
# topic, we can simply right

topic_assignments_by_docs <- topics(my_first_topic_model)



#STRUCTURAL TOPIC MODELS

# topic models perform much better with meta-data. Here is how to use Brandon Stewart's stm package
# I borrow his example verbatim here:

#install.packages("stm")
library(stm)
processed <- textProcessor(blog_data$documents, metadata = blog_data)
#structure and index for usage in the stm model. Verify no-missingness.
out <- prepDocuments(processed$documents, processed$vocab, processed$meta)
#output will have object meta, documents, and vocab
docs <- out$documents
vocab <- out$vocab
meta <-out$meta

# use the utility function prepDocuments to process the loaded data to make sure it is in the right format
plotRemoved(processed$documents, lower.thresh=seq(1,200, by=100))

# and run the model
poliblogPrevFit <- stm(out$documents,out$vocab,K=20,
                       prevalence =~ rating+ s(day), max.em.its=75,
                       data=out$meta,seed=5926696)

# see the vignette at http://structuraltopicmodel.com/ for many more helpful tools
# for model interpretation and validation (including visualization and identifying illustrative quotes)
