xalan <- read.csv("R/assignment/xalan-2.4.csv")
library(e1071)

#calculate descriptive statistics
print(summary(xalan))

# calculate skewness and kurtosis
kur.xalan <- kurtosis(xalan$wmc)
kur.dit <- kurtosis(xalan$dit)
kur.noc <- kurtosis(xalan$noc)
kur.cbo <- kurtosis(xalan$cbo)
kur.rfc <- kurtosis(xalan$rfc)
kur.lcom <- kurtosis(xalan$lcom)

ske.xalan <- skewness(xalan$wmc)
ske.dit <- skewness(xalan$dit)
ske.noc <- skewness(xalan$noc)
ske.cbo <- skewness(xalan$cbo)
ske.rfc <- skewness(xalan$rfc)
ske.lcom <- skewness(xalan$lcom)
print(ske.lcom)

# calculate spearman and pearson coefficient
for (feature in c("wmc","dit","noc","cbo","rfc","lcom"))
{
  
  print(kur.feature)
  correlation.feature.pe <- cor(xalan[feature],xalan["bug"],method = "pearson")
  correlation.feature.sp <- cor(xalan[feature],xalan["bug"],method = "spearman")
  print(correlation.feature.pe)
}


