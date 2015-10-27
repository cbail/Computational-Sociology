
#read in document from google docs

our_interests<-read.csv("https://docs.google.com/spreadsheets/d/1zIeZ-9fbnCM1AQ3vt_OT8Kqwdqup2VA90b2m0jnkzkM/pub?gid=0&single=true&output=csv", row.names=1)

#cluster our interests


# Ward Hierarchical Clustering
#create distance matrix
distance_matrix <- dist(our_interests, method = "euclidean") 
fit <- hclust(distance_matrix, method="ward") 
# display dendogram
plot(fit) 
groups <- cutree(fit, k=5) # cut tree into 5 clusters
# draw dendogram with red borders around the 5 clusters 
rect.hclust(fit, k=5, border="red")


#Non-Hierarchical cluster analysis

kmeans_clusters <- kmeans(our_interests, 5)
library(cluster) 
clusplot(our_interests, kmeans_clusters$cluster, color=TRUE, shade=TRUE, 
         labels=2, lines=0)


# Now where are the good puzzles?

# http://www.unc.edu/~ncaren/cite_network_full/cites.html