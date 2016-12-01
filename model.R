library(caret)
library(stats)
library(ggplot2)
library(pROC)

#import data

#train and test set
sampleSize <- floor(0.7 * nrow(tweets))
set.seed(131)
trainIndices <- sample.int(nrow(tweets), sampleSize, replace = FALSE)

#separate features from response
x.train <- tweets[trainIndices, 1:3]
y.train <- tweets[trainIndices, 4]
  
x.test <- tweets[-trainIndices, 1:3]
y.test <- tweets[-trainIndices, 4]
  

####Prevent Overfitting
# Justify Why (Low Bias Low Variance)
tenFoldCV <- trainControl(method = "repeatedcv",
                          number = 10,
                          repeats = 10)


##### NAIVE BAYES ####

#Train Model

# Model will be train 10 fold cross validation


nb <- train(x.train, y.train, method = "nb", trControl = tenFoldCV)

nb
plot(nb)
plot(nb, metric = "Kappa")

#Explain model train performance w/ accuracy, kappa statistic



####Random Forrest
rf <- train(x.train, y.train, method = "ranger", trControl = tenFoldCV)
rf
rf.predict <- predict(rf, x.test)
#Make Conf Matrix

#Draw ROC Curve
rf.prob <- predict(rf, x.test, type = "prob")
rf.roc <- roc(rf.predict, y.test)



#####Stochastic Gradient Boosting
sgb <- train(x.train, y.train, method = "gbm", trControl = tenFoldCV, verbose = F)

sgb

trellis.par.set(caretTheme())
plot(sgb)
plot(sgb, metric = "Kappa")
ggplot(sgb, metric = "Kappa")
densityplot(sgb)
plot.roc(sgb)

xgb <- train(x.train, y.train, method = "xgbTree", trControl = tenFoldCV)
