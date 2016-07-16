install.packages('caret')
install.packages('randomForest')
install.packages('rattle')
library('caret')
library('randomForest')
library('rattle')

python_dataset <- read.csv("analysis_forR.csv")

drops <- c("X.1", "LAT", "LON", "Unnamed..0", "Unnamed..0.1", "Unnamed..0.1.2", "Unnamed..0.1.1", "X", "idx", "NBR_LIST", "NBR_COUNT", "latcut", "loncut", "Bin", "CALL_LIST", "BLIGHT_LIST", "CRIME_LIST")
final_analysis <- python_dataset[ , !(names(python_dataset) %in% drops)]

set.seed(1000)
inTrain <- createDataPartition(final_analysis$NBR_MATCH, p = 3/4)[[1]]
training <- final_analysis[ inTrain,]
testing <- final_analysis[-inTrain,]

#random_forest
model <- randomForest(NBR_MATCH ~ .,  data = training, na.action = na.omit)
modelresult <- predict(model, testing, type = "class")
confusionMatrix(testing$NBR_MATCH, modelresult)

#logistic_regression
model2 <- train(NBR_MATCH ~ ., data = training, method = 'glm', family = binomial)
modelresult2 <- predict(model2, testing, type = "raw")
confusionMatrix(testing$NBR_MATCH, modelresult2)

#tree
model3 <- train(factor(NBR_MATCH) ~ ., method = 'rpart', data = training)
fancyRpartPlot(model3$finalModel,main="",sub="")
