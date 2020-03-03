library(Hmisc)
#Assignment One - Climate Change 
cli_chg = read.csv('climate_change.csv')

#split data
train_data = subset(cli_chg, Year <= 2006)
test_data = subset(cli_chg, Year > 2006)
model = lm(Temp ~ MEI + CO2 + CH4 + N2O + CFC.11 + CFC.12 + TSI + Aerosols, data = train_data)
model2 = lm(Temp ~ MEI  + N2O + TSI + Aerosols, data = train_data)
model3 = step(model)
model4 = lm(Temp ~  MEI + CO2 + N2O + CFC.11 + CFC.12 + TSI + Aerosols, data = train_data)
temp_predict = predict(model3, newdata = test_data)
SSE = sum((temp_predict - test_data$Temp)^2)
SST = sum((mean(train_data$Temp) - test_data$Temp)^2) #??train??ƽ??ֵ-testԤ????ֵ
R2 = 1 - SSE/SST
# The in-sample R2 will improve, but not necessarily the out-of-sample R2 
# R2 is negative when the model fits the data worse than the horizontal line

#Assignment Two - PISA 
pisaTrain = read.csv('pisa2009train.csv')
pisaTest = read.csv('pisa2009test.csv')
tapply(pisaTrain$readingScore, pisaTrain$male, summary)
summary(pisaTrain)
x = pisaTrain$minutesPerWeekEnglish
x[is.na(x)] = min(x, na.rm = T)
summary(pisaTrain)
pisaTrain$minutesPerWeekEnglish = x
summary(pisaTrain)
#186,266.2,374.6,252.7
pisaTrain = na.omit(pisaTrain) 
pisaTest = na.omit(pisaTest)
#set reference level of the factor variable 
pisaTrain$raceeth = relevel(pisaTrain$raceeth, 'White')
pisaTest$raceeth = relevel(pisaTest$raceeth, 'White')
lmScore = lm(readingScore ~ ., data = pisaTrain)
predTest = c(predict(lmScore, newdata = pisaTest))

#Assignment Three - Flu Epidemics 
Flutrain = read.csv('FluTrain.csv')
FluTest = read.csv('FluTest.csv')
hist(Flutrain$ILI)
plot(log(Flutrain$ILI), Flutrain$Queries)
#find the week that maximizes the ILI
subset(Flutrain, ILI == max(ILI))
Flutrain$Week(Flutrain$ILI == max(Flutrain$ILI))
which.max(Flutrain$ILI) 
which.max(Flutrain$ILI) 
----------------------------------
#find the week that max the query 
which.max(Flutrain$Queries) 
Flutrain$Week[303]
FluTrend1 = lm(log(ILI) ~ Queries, data = Flutrain)
summary(FluTrend1)
#R^2 = Correlation^2
PredTest1 = exp(predict(FluTrend1, newdata = FluTest))
FluTest$Pred = PredTest1
summary(FluTest)
which(FluTest$Week == "2012-03-11 - 2012-03-17")
#2.2934216 0.4329349 2.187378
#(2.2934216 - 2.187378)/ 2.2934216
#lagVAR
install.packages("zoo")
library(zoo)
ILILag2 = lag(zoo(Flutrain$ILI), -2, na.pad = TRUE)
Flutrain$ILILag2 = coredata(ILILag2)
summary(Flutrain)
#another lm 
FluTrend2 = lm(log(ILI) ~ Queries + log(ILILag2), data = Flutrain)
summary(FluTrend2)
#add ILILAG2 TO TEST DATA 
ILILag2_T = lag(zoo(FluTest$ILI), -2, na.pad = TRUE)
FluTest$ILILag2_T = coredata(ILILag2_T)
summary(FluTest)
plot(log(Flutrain$ILILag2), log(Flutrain$ILI))
summary(FluTrend2)
FluTest$ILILag2_T[1] = Flutrain$ILI[416]
FluTest$ILILag2_T[2] = Flutrain$ILI[417]

#Unit2 - Assignment 4 - Statedata
data(state)
statedata = cbind(data.frame(state.x77), state.abb, state.area, state.center,  state.division, state.name, state.region)
plot(statedata$x,statedata$y)
tapply(statedata$HS.Grad, statedata$state.region, summary)
boxplot(statedata$Murder ~ statedata$state.region, col='green')
a = subset(statedata, statedata$state.region == 'Northeast')
which.max(a$Murder)
a$state.name[6]
le_lm = lm(Life.Exp ~ Population + Income + Illiteracy + Murder + HS.Grad + Frost + Area, data = statedata)
summary(le_lm)
plot(statedata$Income, statedata$Life.Exp)
step(le_lm)
#We expect the "Multiple R-squared" value of the simplified model to be slightly worse than that of the initial model. 
#It can't be better than the "Multiple R-squared" value of the initial model.
model2 = lm(Life.Exp ~ Population + Murder + HS.Grad + Frost, data = statedata)
summary(model2)
PredTest1 = c(predict(model2))
PredTest1
sort(PredTest1)
which.min(statedata$Life.Exp)
statedata$state.name[40]
which.max(statedata$Life.Exp)
statedata$state.name[11]
SSE = abs(PredTest1 - statedata$Life.Exp)
sort(SSE)

#Unit2 - Assignment 4 - Forecasting Elantra Sales 
ela = read.csv('elantra.csv')
summary(ela)
str(ela)
train = subset(ela, Year<='2012')
test = subset(ela, Year>'2012')
str(train)
model1 = lm(ElantraSales ~ Unemployment + CPI_all + CPI_energy + Queries, data = train)
summary(model1)
model2 = lm(ElantraSales ~ Unemployment + CPI_all + CPI_energy + Queries + Month, data = train)
summary(model2)
Pred1 = c(predict(model2))
train$Pred = Pred1
train
mon_fact = as.factor(train$Month)
model3 = lm(ElantraSales ~ Unemployment + CPI_all + CPI_energy + Queries + mon_fact, data = train)
summary(model3)
step(model3)
model4= lm( ElantraSales ~ Unemployment + CPI_all + CPI_energy + mon_fact, data = train)
summary(model4)
summary(test)
remove(test$mon_fact)
pred = predict(model4, newdata = test)
SSE = sum((pred - test$ElantraSales)^2)
SST = sum((mean(train$ElantraSales) - test$ElantraSales)^2)
R2 = 1 - SSE/SST
R2
test$diff = abs(pred - test$ElantraSales)
test$diff
which.max(test$diff)
test$Month[5]
test$Year[5]

#assignment three
log_odds = -1.5 + 3*1 + (-0.5) *5
odds = exp(log_odds)
tmp = exp(log_odds * -1)
p_y1 = 1/(1 + tmp)
p_y1

quality = read.csv("quality.csv")

install.packages("caTools")

library(caTools)

set.seed(88)

split = sample.split(quality$PoorCare, SplitRatio = 0.75)

qualityTrain = subset(quality, split == TRUE)

qualityTest = subset(quality, split == FALSE)

#Then recall that we built a logistic regression model to predict PoorCare using the R command:
  
QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family=binomial)
predictTest = predict(QualityLog, type="response", newdata=qualityTest)
#You can compute the test set AUC by running the following two commands in R:
ROCRpredTest = prediction(predictTest, qualityTest$PoorCare)
auc = as.numeric(performance(ROCRpredTest, "auc")@y.values)

##framingham heart study
framingham = read.csv('framingham.csv')
str(framingham)
library(caTools)
set.seed(1000)
split = sample.split(framingham$TenYearCHD, SplitRatio = 0.65)
train = subset(framingham, split == TRUE)
test = subset(framingham, split == FALSE)
framinghamLog = glm(TenYearCHD ~ ., data = train, family = binomial)
summary(framinghamLog)
predictTest = predict(framinghamLog, type = "response", newdata = test)
predictTest
table(test$TenYearCHD, predictTest > 0.5)
#accuracy of the model 
(1069 + 11) / (1069+6+187+11)
(1069+6)/(1069+6+187+11)
library(ROCR)
ROCRpred = prediction(predictTest, test$TenYearCHD)
as.numeric(performance(ROCRpred, "auc")@y.values)
#Model can differentiate low-risk from high-risk patients(AUC = 0.74)
#compute senstivity, tp / (tp + fn)
#compute specificity, tn / (tn + fp)

#senstivity tp / (tp + fp)
11/(11+187)
#specificity tn / (tn + fn)
1069/(1069+6)

##use polling data 
polling = read.csv('PollingData.csv')
str(polling)
table(polling$Year)
summary(polling)
#dealing with Missing data
#delete missing observations, missing values, fill missing dats with average values 
#fill missing values based on non-missing values 
install.packages("mice")
library('lattice')
library("mice")
simple = polling[c('Rasmussen', "SurveyUSA", "PropR", "DiffCount")]
summary(simple)
set.seed(144)
imputed = complete(mice(simple))
summary(imputed)
polling$Rasmussen = imputed$Rasmussen 
polling$SurveyUSA = imputed$SurveyUSA
summary(polling)

Train = subset(polling, Year == 2004 | Year == 2008)
Test = subset(polling, Year == 2012)
table(Train$Republican)

sign(20)
sign(-10)
sign(0)
table(sign(Train$Rasmussen))
table(Train$Republican, sign(Train$Rasmussen))
cor(Train)
str(Train)
cor(Train[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount", "Republican")])
mod1 = glm(Republican~PropR, data = Train, family = "binomial")
summary(mod1)
pred1 = predict(mod1, type = "response")
table(Train$Republican, pred1 >= 0.5)
mod2 = glm(Republican~SurveyUSA + DiffCount, data = Train, family = "binomial")
pred2 = predict(mod2, type = "response")
table(Train$Republican, pred2 >= 0.5)
summary(mod2)
table(Test$Republican, sign(Test$Rasmussen))
TestPrediction = predict(mod2, newdata = Test, type = "response")
table(Test$Republican, TestPrediction >= 0.5)
subset(Test, TestPrediction >=0.5 & Republican ==0)

##Unit 3 Assignment 1 - Song 
song = read.csv('songs.csv')
str(song)
song1 = subset(song, year >= 2010)
str(song1)
table(song$artistname == "Michael Jackson")
MJ = subset(song, artistname == "Michael Jackson")
top_song = MJ[c('songtitle', 'Top10')]
table(song$timesignature)
which.max(song$tempo)
song$songtitle[6206]
SongsTrain = subset(song, year <= 2009)
SongsTest = subset(song, year == 2010)
str(SongsTrain)
str(song)
nonvars = c('year', 'songtitle', 'artistanme', 'songID', 'artistID')
SongsTrain = SongsTrain[,!(names(SongsTrain) %in% nonvars)]
SongsTest = SongsTest[,!(names(SongsTest) %in% nonvars)]
SongsLog1 = glm(Top10 ~ ., data = SongsTrain,family = binomial)
summary(SongsLog1)
cor(SongsTrain$loudness,SongsTrain$energy)
SongsLog2=glm(Top10 ~. -loudness, data = SongsTrain, family = binomial)
summary(SongsLog2)
SongsLog3=glm(Top10 ~. -energy, data = SongsTrain, family = binomial)
summary(SongsLog3)
pred = predict(SongsLog3, newdata = SongsTest, type = 'response')
table(SongsTest$Top10, pred >= 0.45)
accuracy = (309+19) / (309+5+40+19)
accuracy
#baseline accuracy 
table(SongsTest$Top10)
bl = 314/(314 + 59)
#senstivity tp / (tp + fn)
19 / (19+40)
#specificity tn / (tn + fp)
309 / (309 + 5)

# Assignment2: Predict Parole Violators 
parole = read.csv('parole.csv')
summary(parole)
str(parole)
table(parole$violator)
#unordered factor 
str(parole$state)
str(parole$crime)
parole$state = as.factor(parole$state)
parole$crime = as.factor(parole$crime)
summary(parole)
set.seed(144)#????set seedΪ????һ?????֣???train, test???в?ͬ?Ľ?????
library(caTools)
split = sample.split(parole$violator, SplitRatio = 0.7)
train = subset(parole, split == TRUE)
test = subset(parole, split == FALSE)
ParLog1=glm(violator ~., data = parole, family = binomial)
summary(ParLog1)
#ln(odds of A) = ln(odds of B) + 1.61
#exp(ln(odds of A)) = exp(ln(odds of B) + 1.61)
#exp(ln(odds of A)) = exp(ln(odds of B)) * exp(1.61)
#odds of A = exp(1.61) * odds of B
#odds of A= 5.01 * odds of B
#In the second step we raised e to the power of both sides. 
#In the third step we used the exponentiation rule that e^(a+b) = e^a * e^b. 
#In the fourth step we used the rule that e^(ln(x)) = x.
exp_tmp = exp(-4.052377 + 0.270624 + 0.757252 + 50*0.006554 + 12*0.053293 + 0.336893)
prob = 1/(1+exp_tmp)
pred = predict(ParLog1, newdata = test, type = 'response')
summary(pred)
table(test$violator, as.numeric(pred >= 0.5))
#senstivity tp / (tp + fn)
9 / (9+14)
#specificity tn / (tn + fp)
172/ (172 + 7)
accuracy = 181 / (179 + 23)
bl_accuracy = 179 / (179 + 23)
accuracy
bl_accuracy
#Decreasing the cutoff leads to more positive predictions, 
#which increases false positives and decreases false negatives. 
#Meanwhile, increasing the cutoff leads to more negative predictions,
#which increases false negatives and decreases false positives. 
#The parole board assigns high cost to false negatives, and therefore should decrease the cutoff.
#???ɴ???100???????ҷ?һ??
#The board assigns more cost to a false negative than a false positive, 
#and should therefore use a logistic regression cutoff less than 0.5
library(ROCR)
ROCRpred = prediction(pred, test$violator)
as.numeric(performance(ROCRpred, "auc")@y.values)

#Assignment 3 
loan = read.csv('loans.csv')
str(loan)
summary(loan)
table(loan$not.fully.paid)
1533/(1533+8045)
missing = subset(loan, is.na(log.annual.inc) | is.na(days.with.cr.line) | is.na(revol.util) | is.na(inq.last.6mths) | is.na(delinq.2yrs) | is.na(pub.rec))
table(missing$not.fully.paid)

#imputation
install.packages("mice") 
library(mice)
set.seed(144)
vars.for.imputation = setdiff(names(loan), "not.fully.paid")
imputed = complete(mice(loan[vars.for.imputation]))
loan[vars.for.imputation] = imputed
str(loan)
summary(loan)

#split data into train and test
set.seed(144)
library(caTools)
split = sample.split(loan$not.fully.paid, SplitRatio = 0.7)
train = subset(loan, split == TRUE)
test = subset(loan, split == FALSE)

#loanLog1
loanLog1 = glm(not.fully.paid ~ ., data = train, family = binomial)
summary(loanLog1)
(-9.054e-03 * 700) -  (-9.054e-03 * 710)
exp(-9.054e-03 * 700) / exp(-9.054e-03 * 710)
test$predicted.risk = predict(loanLog1, newdata = test, type = 'response')
table(test$not.fully.paid, test$predicted.risk > 0.5)
accuracy = (3+2400) / (2400 + 3 + 13 + 457)
bl_accuracy = (2400 + 13) / (2400 + 3 + 13 + 457)
accuracy
bl_accuracy
library(ROCR)
ROCRpred = prediction(test$predicted.risk, test$not.fully.paid)
as.numeric(performance(ROCRpred, "auc")@y.values)

#loanLog2
loanLog2 = glm(not.fully.paid ~ int.rate, data = train, family = binomial)
summary(loanLog2)
cor(train$int.rate, train$fico)
test$predicted.risk = predict(loanLog2, newdata = test, type = 'response')
summary(pred)
table(test$not.fully.paid, as.numeric(pred >= 0.5))
library(ROCR)
ROCRpred = prediction(pred, test$not.fully.paid)
as.numeric(performance(ROCRpred, "auc")@y.values)
10 * exp(3 * 0.06)
c * (exp(rt) - 1)

#highInterest
test$profit = exp(test$int.rate*3) - 1
test$profit[test$not.fully.paid == 1]
summary(test)
highInterest = subset(test, int.rate >= 0.15)
summary(highInterest$profit)
table(highInterest$not.fully.paid)
cutoff = sort(highInterest$predicted.risk, decreasing=FALSE)[100]
cutoff
selectedLoans = subset(highInterest, predicted.risk <= cutoff)
nrow(selectedLoans)
sum(selectedLoans$profit)
table(selectedLoans$not.fully.paid)
#


#Assignment 4
baseball = read.csv('baseball.csv')
str(baseball)
length(table(baseball$Year))
baseball2 = subset(baseball, baseball$Playoffs == '1')
str(baseball2)
table(table(baseball$Year))
PlayoffTable = table(baseball$Year)
k = names(PlayoffTable)
str(k)
PlayoffTable[c("1990", "2001")]
table(baseball$NumCompetitors)
baseball$WorldSeries = as.numeric(baseball$RankPlayoffs == 1)
baseball$WorldSeries
nn_tmp = subset(baseball, WorldSeries == '0')
str(nn_tmp)
table(baseball$WorldSeries)
mod1 = glm(WorldSeries ~ Year, data = baseball, family = binomial) 
summary(mod1)
mod2 = glm(WorldSeries ~ RS, data = baseball, family = binomial) 
summary(mod2)
mod3 = glm(WorldSeries ~ RA, data = baseball, family = binomial) 
summary(mod3)
mod4 = glm(WorldSeries ~ W, data = baseball, family = binomial) 
summary(mod4)
mod5 = glm(WorldSeries ~ OBP, data = baseball, family = binomial) 
summary(mod5)
mod6 = glm(WorldSeries ~ SLG, data = baseball, family = binomial) 
summary(mod6)
mod7 = glm(WorldSeries ~ BA, data = baseball, family = binomial) 
summary(mod7)
mod8 = glm(WorldSeries ~ RankSeason, data = baseball, family = binomial) 
summary(mod7)
mod9 = glm(WorldSeries ~ OOBP, data = baseball, family = binomial) 
summary(mod9)
mod10 = glm(WorldSeries ~ OSLG, data = baseball, family = binomial) 
summary(mod10)
mod11 = glm(WorldSeries ~ NumCompetitors, data = baseball, family = binomial) 
summary(mod11)
mod12 = glm(WorldSeries ~ League, data = baseball, family = binomial) 
summary(mod12)

mod1 = glm(WorldSeries ~ Year, data = baseball, family = binomial) 
mod3 = glm(WorldSeries ~ RA, data = baseball, family = binomial) 
mod8 = glm(WorldSeries ~ RankSeason, data = baseball, family = binomial) 
mod11 = glm(WorldSeries ~ NumCompetitors, data = baseball, family = binomial) 
mod14 = glm(WorldSeries ~ Year+RA, data = baseball, family = binomial)
mod15 = glm(WorldSeries ~ Year+RankSeason, data = baseball, family = binomial)
mod16 = glm(WorldSeries ~ Year+NumCompetitors, data = baseball, family = binomial)
mod17 = glm(WorldSeries ~ RA+RankSeason, data = baseball, family = binomial)
mod18 = glm(WorldSeries ~ RA+NumCompetitors, data = baseball, family = binomial)
mod19 = glm(WorldSeries ~ RankSeason+NumCompetitors, data = baseball, family = binomial)

for(i in c(mod1,mod3,mod8,mod11,mod14,mod15,mod16,mod17,mod18,mod19)) print(AIC(i))

AIC(mod1)
AIC(mod3)
AIC(mod8)
AIC(mod11)
AIC(mod14)
AIC(mod15)
AIC(mod16)
AIC(mod17)
AIC(mod18)
AIC(mod19)
mod13 = glm(WorldSeries ~ Year + RA + RankSeason + NumCompetitors, data = baseball, family = binomial) 
summary(mod13)
cor(baseball$RankSeason, baseball$RA)

###Unit 4 Trees
#rpart: ID3 ????Ϣ??????Ϊ??????׼
#cart: ?Ի???ϵ????Ϊ??????׼
stevens = read.csv('stevens.csv')
str(stevens)
install.packages('caTools')
library(caTools)
set.seed(3000)
spl = sample.split(stevens$Reverse, SplitRatio = 0.7)
Train = subset(stevens, spl == TRUE)
Test = subset(stevens, spl == FALSE)
install.packages('rpart')
library(rpart)
install.packages('rpart.plot')
library(rpart.plot)
StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method = 'class', minbucket = 25)
prp(StevensTree)
predictCART = predict(StevensTree, newdata = Test, type = 'class')
table(Test$Reverse, predictCART)
accuracy = (41+71) / (41+36+22+71)
accuracy
library(ROCR)
PredictROC = predict(StevensTree, newdata = Test)
PredictROC
pred = prediction(PredictROC[,2], Test$Reverse)
perf = performance(pred, "tpr", "fpr")
plot(perf)
as.numeric(performance(pred, "auc")@y.values)
StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method = 'class', minbucket = 5)
prp(StevensTree)
StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method = 'class', minbucket = 100)
prp(StevensTree)
install.packages("randomForest")
library(randomForest)
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, nodesize = 25, ntree=200)
Train$Reverse = as.factor(Train$Reverse)
Test$Reverse = as.factor(Test$Reverse)
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, nodesize = 25, ntree=200)
PredictForest = predict(StevensForest, newdata = Test)
table(Test$Reverse, PredictForest)
accuracy = (39+74) / (39+38+19+74)
set.seed(100)
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, nodesize = 25, ntree=200)
PredictForest = predict(StevensForest, newdata = Test)
table(Test$Reverse, PredictForest)
(43+74) / (43+34+19+74)
set.seed(200)
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, nodesize = 25, ntree=200)
PredictForest = predict(StevensForest, newdata = Test)
table(Test$Reverse, PredictForest)
(44+76) / (44+33+17+76)
install.packages("caret")
library(caret)
install.packages("e1071")
install.packages('recipes')
numFolds = trainControl(method = "cv", number=10)
cpGrid = expand.grid(.cp = seq(0.01, 0.5, 0.01))
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method = "rpart", trControl = numFolds, tuneGrid = cpGrid)
StevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, data = Train, method = "class", cp = 0.19)
PredictCV = predict(StevensTreeCV, newdata = Test, type = "class")
table(Test$Reverse, PredictCV)
(59+64) / (59+18+29+64)
prp(StevensTreeCV)

#claim data
claims = read.csv('ClaimsData.csv')
str(claims)
table(claims$bucket2009) / nrow(claims)
set.seed(88)
spl = sample.split(claims$bucket2009, SplitRatio = 0.6)
ClaimsTrain = subset(claims, spl == TRUE)
ClaimsTest = subset(claims, spl == FALSE)
mean(ClaimsTrain$age)
table(ClaimsTrain$diabetes)/nrow(ClaimsTrain)
table(ClaimsTest$bucket2009, ClaimsTest$bucket2008)
(110058 + 10772 + 2701 + 1534 + 92) / nrow(ClaimsTest)
PenaltyMatrix = matrix(c(0,1,2,3,4,2,0,1,2,3,4,2,0,1,2,6,4,2,0,1,8,6,4,2,0), byrow=TRUE, nrow = 5)
PenaltyMatrix
as.matrix(table(ClaimsTest$bucket2009, ClaimsTest$bucket2008)) * PenaltyMatrix
sum(as.matrix(table(ClaimsTest$bucket2009, ClaimsTest$bucket2008)) * PenaltyMatrix)/nrow(ClaimsTest)
110138/nrow(ClaimsTest)
(16000 * 2 + 7006 * 4 + 2688 * 6 + 293 * 8)
table(ClaimsTest$bucket2009)
bl_accuracy = 122978/nrow(ClaimsTest)
bl_accuracy
penalty_error = (0 * 122978 + 2 * 34840 + 4 * 16390 + 6 * 7939 + 8 * 1057) / nrow(ClaimsTest)
penalty_error
library(rpart)
library(rpart.plot)
ClaimsTree = rpart(bucket2009 ~ age + arthritis + alzheimers + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data = ClaimsTrain, method = "class", cp=0.00005)
prp(ClaimsTree)
PredictTest = predict(ClaimsTree, newdata = ClaimsTest, type = "class")
table(ClaimsTest$bucket2009, PredictTest)
(114141+16102+118+201+0)/nrow(ClaimsTest)
as.matrix(table(ClaimsTest$bucket2009, PredictTest)) * PenaltyMatrix
sum(as.matrix(table(ClaimsTest$bucket2009, PredictTest)) * PenaltyMatrix) /nrow(ClaimsTest)
ClaimsTree = rpart(bucket2009 ~ age + arthritis + alzheimers + cancer + copd + depression + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke + bucket2008 + reimbursement2008, data = ClaimsTrain, method = "class", cp=0.00005, parms=list(loss=PenaltyMatrix))
PredictTest = predict(ClaimsTree, newdata = ClaimsTest, type = "class")
table(ClaimsTest$bucket2009, PredictTest)
(94310 + 18942 + 4692 + 636 + 2) / nrow(ClaimsTest)
sum(as.matrix(table(ClaimsTest$bucket2009, PredictTest)) * PenaltyMatrix) / nrow(ClaimsTest)
16000+7006+2688+293
#In the previous video, we constructed two CART models. The first CART model, without the loss matrix, 
#predicted bucket 1 for 78.6% of the observations in the test set. 
#Did the second CART model, with the loss matrix, predict bucket 1 for more or fewer of the observations, and why?
#According to the penalty matrix, some of the worst types of errors are to not predict bucket 1 
#when the actual cost bucket is bucket 1. Therefore, the model with the penalty matrix predicted bucket 1 less frequently.

#Boston Housing 
boston = read.csv('boston.csv')
str(boston)
plot(boston$LON, boston$LAT)
points(boston$LON[boston$CHAS==1],boston$LAT[boston$CHAS==1], col="blue", pch=19)
points(boston$LON[boston$TRACT==3531], boston$LAT[boston$TRACT==3531], col="red", pch=19)
summary(boston$NOX)
points(boston$LON[boston$NOX>=0.55], boston$LAT[boston$NOX>=0.55], col="green", pch=19)
plot(boston$LON, boston$LAT)
summary(boston$MEDV)
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=19)
plot(boston$LAT, boston$MEDV)
plot(boston$LON, boston$MEDV)
latlonlm = lm(MEDV ~ LAT + LON, data=boston)
summary(latlonlm)
plot(boston$LON, boston$LAT)
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=19)
latlonlm$fitted.values
points(boston$LON[latlonlm$fitted.values>=21.2], boston$LAT[latlonlm$fitted.values>=21.2], col="blue", pch="$")
library(rpart)
library(rpart.plot)
latlontree = rpart(MEDV ~ LAT + LON, data = boston)
prp(latlontree)
plot(boston$LON, boston$LAT)
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=19)
fittedvalues = predict(latlontree)
points(boston$LON[fittedvalues>=21.2], boston$LAT[fittedvalues>=21.2], col="blue", pch="$")
latlontree = rpart(MEDV ~ LAT + LON, data = boston, minbucket=50)
plot(latlontree)
text(latlontree)
plot(boston$LON, boston$LAT)
abline(v=-71.07)
plot(latlontree)
text(latlontree)
plot(boston$LON, boston$LAT)
abline(v=-71.07)
abline(h=42.21)
abline(h=42.17)
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=19)
library(caTools)
set.seed(123)
split = sample.split(boston$MEDV, SplitRatio=0.7)
train = subset(boston, split==TRUE)
test = subset(boston, split==FALSE)
linreg = lm(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data = train)
summary(linreg)
linreg.pred = predict(linreg, newdata = test)
linreg.sse = sum((linreg.pred - test$MEDV)^2)
linreg.sse
tree = rpart(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data = train)
prp(tree)
tree.pred = predict(tree, newdata = test)
tree.sse = sum((tree.pred - test$MEDV)^2)
tree.sse
#cp(complex parameters) = lambda / RSS(no splits)
#large cp encourages no splits, while small cp motivates more splits 
library(caret)
library(e1071)
tr.control = trainControl(method="cv", number=10)
cp.grid = expand.grid(.cp = (0:10) * 0.001)
0:10 * 0.001
tr = train(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data = train, method = "rpart", trControl = tr.control, tuneGrid = cp.grid)
best.tree = tr$finalModel
prp(best.tree)
best.tree.pred = predict(best.tree, newdata = test)
best.tree.sse = sum((best.tree.pred - test$MEDV)^2)
best.tree.sse
linreg.sse = 3030

#hw1
gb = read.csv("gerber.csv")
table(gb$voting)
108696/(235388+108696)
tapply(gb$civicduty, gb$voting, mean)
tapply(gb$hawthorne, gb$voting, mean)
tapply(gb$self, gb$voting, mean)
tapply(gb$neighbors, gb$voting, mean)
voteLog = glm(voting ~ civicduty + hawthorne + self + neighbors, data = gb, family = binomial)
summary(voteLog)
summary(pred)
#use a threshold of 0.3 
pred = predict(voteLog, type = "response")
table(gb$voting, as.numeric(pred > 0.3))
(134513 + 51966) / (134513 + 51966 + 100875 + 56730)
#use a threshold of 0.5
pred = predict(voteLog, type = "response")
table(gb$voting, as.numeric(pred > 0.5))
235388 / (235388 + 108696)
#bl_accuracy
table(gb$voting)
bl_accuracy = 235388 / (235388 + 108696)
#auc
ROCRpredTest = prediction(pred, gb$voting)
auc = as.numeric(performance(ROCRpredTest, "auc")@y.values)
auc
#build a cart model
CARTmodel = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=gb)
prp(CARTmodel)
CARTmodel2 = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=gb, cp=0.0)
prp(CARTmodel2)
summary(CARTmodel2)
CARTmodel3 = rpart(voting ~ civicduty + hawthorne + self + neighbors + sex, data=gb, cp=0.0)
CARTmodel4 = rpart(voting ~ control, data=gb, cp=0.0)
CARTmodel5 = rpart(voting ~ control + sex, data=gb, cp=0.0)
prp(CARTmodel4, digits = 6)
prp(CARTmodel5 , digits = 6)
women = 0.334176 - 0.290456
men = 0.345818 - 0.302795
# log model 
voteLog2 = glm(voting ~ control + sex, data = gb, family = binomial)
summary(voteLog2)
Possibilities = data.frame(sex=c(0,0,1,1),control=c(0,1,0,1))
predict(voteLog2, newdata=Possibilities, type="response")
w_nt_lg = 0.2908065
w_nt_tree = 0.290456
w_nt_tree - w_nt_lg
voteLog3 = glm(voting ~  sex + control +  sex:control, data = gb, family = "binomial")
w_nt_log2_tmp = exp(-0.637471 -0.051888 -0.196553 -0.007259)
w_nt_log2 = 0.4093556 / (1+0.4093556)
w_nt_log2 - w_nt_tree

summary(voteLog3)
tmp = predict(voteLog3, newdta = Possibilities, type = "response")

Possibilities2 = data.frame(sex=c(0,0,1,1),control=c(0,1,0,1),sc=c(0,1,1,2))
##Assignment 2 
letters = read.csv('letters_ABPR.csv')
str(letters)
letters$isB = as.factor(letters$letter == "B") 
set.seed(1000)
library(caTools)
split = sample.split(letters$isB, SplitRatio=0.5)
train = subset(letters, split==TRUE)
test = subset(letters, split==FALSE)
table(train$isB)
library(rpart)
CARTb = rpart(isB ~ . - letter, data=train, method="class")
pred = predict(CARTb, newdata = test, type = "class")
table(test$isB, pred)
accuracy = (1118+340) / nrow(test)
accuracy
set.seed(1000)
install.packages("randomForest")
library(randomForest)
letterForest = randomForest(isB ~ . - letter, data = train)
pred = predict(letterForest, newdata = test, type = "class")
table(test$isB,pred)
accuracy = (1163+374) / nrow(test)
accuracy
#predict the letter, multiclassification 
letters$letter = as.factor( letters$letter )
set.seed(2000)
library(caTools)
split = sample.split(letters$isB, SplitRatio=0.5)
train = subset(letters, split==TRUE)
test = subset(letters, split==FALSE)
table(test$letter)
bl_accuracy = 397 / nrow(test)
bl_accuracy
#build a classification tree to predict VAR letter
CARTb = rpart(letter ~ . - isB, data=train, method="class")
pred = predict(CARTb, newdata = test, type = "class")
table(test$letter, pred)
accuracy = (345+317+360+332) / nrow(test)
accuracy
#build a random forest model to predict VAR letter
set.seed(1000)
letterForest = randomForest(letter~ . - isB, data = train)
pred = predict(letterForest, newdata = test, type = "class")
table(test$letter,pred)
accuracy = (392+379+389+372) / nrow(test)
accuracy

#Unit4 - Assignment 3 
census = read.csv('census.csv')
library(caTools)
set.seed(2000)
split = sample.split(census$over50k, SplitRatio = 0.6)
train = subset(census, split==TRUE)
test = subset(census, split==FALSE)
#build a log model 
censusLog = glm(over50k ~ ., data = train, family = binomial)
summary(censusLog)
pred = predict(censusLog, newdata=test, type = "response")
table(test$over50k, as.numeric(pred > 0.5))
accuracy = (9051+1888) / (9051+662+1190+1888)
accuracy
table(test$over50k)
bl_accuracy = 9713/(9713+3078)
bl_accuracy
ROCRpredTest = prediction(pred, test$over50k)
auc = as.numeric(performance(ROCRpredTest, "auc")@y.values)
auc
#build a classification tree 
library(rpart)
library(rpart.plot)
censusTree = rpart(over50k ~ ., data = train, method = 'class')
prp(censusTree)
pred = predict(censusTree, newdata=test, type = "class")
table(test$over50k, pred)
accuracy = (9243 + 1596) / nrow(test)
accuracy
pred = predict(censusTree, newdata=test)
ROCRpredTest = prediction(pred[,2], test$over50k)
auc = as.numeric(performance(ROCRpredTest, "auc")@y.values)
auc
plot(ROCRpredTest)
#The probabilities from the CART model take only a handful of values 
#(five, one for each end bucket/leaf of the tree); the changes in the ROC curve correspond to setting the threshold to one of those values

#Get a smaller sample for Random Forest Model 
library(randomForest)
trainSmall = train[sample(nrow(train), 2000), ]
set.seed(1)
censusForest = randomForest(over50k ~ ., data = trainSmall)
pred = predict(censusForest, newdata = test)
table(test$over50k, pred)
table(pred)
accuracy = (8839+2033) / nrow(test)
accuracy
vu = varUsed(censusForest, count=TRUE)
vusorted = sort(vu, decreasing = FALSE, index.return = TRUE)
dotchart(vusorted$x, names(censusForest$forest$xlevels[vusorted$ix]))
varImpPlot(censusForest)
#select cp by cross-validation 
set.seed(2)
library(caret)
library(e1071)
numFolds = trainControl(method = "cv", number=10)
cartGrid = expand.grid(.cp = seq(0.002, 0.1, 0.002))
train(over50k ~ ., data = train, method = "rpart", trControl = numFolds, tuneGrid = cartGrid)
censusTreeCV = rpart(over50k ~., data = train, method = "class", cp = 0.002)
pred = predict(censusTreeCV, newdata=test,type='class')
table(test$over50k, pred)
accuracy = (9178+1838) / (9178+535+1240+1838)
accuracy
prp(censusTreeCV)
#reflection on tradeoff: may favor a simpler model over a more accuract but complicated one. 

# Unit 4 - Assignment4
#build a linear regression model 
#Trying different combinations of variables in linear regression controls the complexity of the model. 
#This is similar to trying different numbers of splits in a tree, which is also controlling the complexity of the model.
data(state)
statedata = data.frame(state.x77)
str(statedata)
stateLR = lm(Life.Exp ~., data = statedata)
pred = predict(stateLR)
summary(stateLR)
sse = sum((pred - statedata$Life.Exp)^2)
stateLR2 = lm(Life.Exp ~ Population + Murder + Frost + HS.Grad, data = statedata)
pred = predict(stateLR2)
sse2 = sum((pred - statedata$Life.Exp)^2) # SSE = sum(RegModel2$residuals^2)
sse2
cor(statedata)
#build a CART 
stateTree = rpart(Life.Exp ~ ., data = statedata)
prp(stateTree)
pred = predict(stateTree)
SSE = sum((pred - statedata$Life.Exp)^2)
SSE
#limit minbucket to 5
stateTree = rpart(Life.Exp ~ ., data = statedata, minbucket = 5)
pred = predict(stateTree)
SSE = sum((pred - statedata$Life.Exp)^2)
SSE
prp(stateTree)
##limit minbucket to 1 and change independent var 
stateTree = rpart(Life.Exp ~ Area, data = statedata, minbucket = 1)
pred = predict(stateTree)
SSE = sum((pred - statedata$Life.Exp)^2)
SSE
prp(stateTree)
#optimize linear model 
set.seed(111)
library(caret)
library(e1071)
numFolds = trainControl(method = "cv", number=10)
cartGrid = expand.grid(.cp = seq(0.01, 0.50, 0.01))
train(Life.Exp ~ ., data = statedata, method = "rpart", trControl = numFolds, tuneGrid = cartGrid)
stateTreeCV = rpart(Life.Exp ~., data = statedata, cp = 0.12)
prp(stateTreeCV)
pred = predict(stateTreeCV)
sse = sum((statedata$Life.Exp - pred)^2)
sse
set.seed(111)
numFolds = trainControl(method = "cv", number=10)
cartGrid = expand.grid(.cp = seq(0.01, 0.50, 0.01))
train(Life.Exp ~ Area, data = statedata, method = "rpart", trControl = numFolds, tuneGrid = cartGrid)
stateTreeCV = rpart(Life.Exp ~ Area, data = statedata, cp = 0.02)
prp(stateTreeCV)
pred = predict(stateTreeCV)
sse = sum((pred - statedata$Life.Exp)^2)
sse
#Cross-validation is not designed to improve the fit on the training data, 
#but it won't necessarily make it worse either. Cross-validation cannot guarantee improving the SSE on unseen data, although it often 

###Unit 5 Text Analytics 
tweets = read.csv('tweets.csv', stringsAsFactors=FALSE)
str(tweets)
tweets$Negative = as.factor(tweets$Avg <= -1)
table(tweets$Negative)
install.packages("tm")
library(tm)
install.packages("SnowballC")
library(SnowballC)
corpus = Corpus(VectorSource(tweets$Tweet))
corpus
# to lower, removePunctuation, removeWords, stemDocument
corpus[[1]]
corpus = tm_map(corpus, tolower)
corpus[[1]]
corpus = tm_map(corpus, removePunctuation)
stopwords('english')[1:10]
corpus = tm_map(corpus, removeWords, c("apple", stopwords("english")))
corpus[[1]]
corpus = tm_map(corpus, stemDocument)
corpus[[1]]
#bag of words 
frequencies = DocumentTermMatrix(corpus)
frequencies
inspect(frequencies[1000:1005, 505:515])
findFreqTerms(frequencies, lowfreq=20)
#0.995, only keep terms that appear in 0.5% or more of the tweets 
sparse = removeSparseTerms(frequencies, 0.995)
sparse
tweetsSparse = as.data.frame(as.matrix(sparse))
colnames(tweetsSparse) = make.names(colnames(tweetsSparse))
tweetsSparse$Negative = tweets$Negative 
library(caTools)
split = sample.split(tweetsSparse$Negative, SplitRatio = 0.7)
trainSparse = subset(tweetsSparse, split == TRUE)
testSparse = subset(tweetsSparse, split == FALSE)
findFreqTerms(frequencies, lowfreq=100)
#build a CART
library(rpart)
library(rpart.plot)
tweetCART = rpart(Negative ~. , data = trainSparse, method = "class")
prp(tweetCART)
predictCART = predict(tweetCART, newdata=testSparse, type = "class")
table(testSparse$Negative, predictCART)
(294+19) / nrow(testSparse)
table(testSparse$Negative)
300 / 355
#build a random forest 
library(randomForest)
set.seed(123)
tweetRF = randomForest(Negative ~., data=trainSparse)
predictRF = predict(tweetRF, newdata = testSparse)
table(testSparse$Negative, predictRF)
(291+22) / (291+9+33+22)
#build a logistic regression model 
tweetLog = glm(Negative ~., data = trainSparse, family = binomial)
predictions = predict(tweetLog, newdata=testSparse, type="response")
table(testSparse$Negative, as.numeric(predictions > 0.5))

#Emails 
emails = read.csv('energy_bids.csv', stringsAsFactors=FALSE)
str(emails)
emails$email[1]
strwrap(emails$email[1])#broken down long strings to shorter ones 
emails$responsive[1]
strwrap(emails$email[2])
emails$responsive[2]
table(emails$responsive)
library(tm)
corpus = Corpus(VectorSource(emails$email))
strwrap(corpus[[1]])
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords('english'))
corpus = tm_map(corpus, stemDocument)
strwrap(corpus[[1]])
dtm = DocumentTermMatrix(corpus)
dtm
dtm = removeSparseTerms(dtm, 0.97)
dtm
labeledTerms = as.data.frame(as.matrix(dtm))
labeledTerms$responsive = emails$responsive
str(labeledTerms)
library(caTools)
set.seed(144)
spl = sample.split(labeledTerms$responsive, 0.7)
train = subset(labeledTerms, spl == TRUE)
test = subset(labeledTerms, spl == FALSE)
library(rpart)
library(rpart.plot)
emailCART = rpart(responsive~., data = train, method = "class")
prp(emailCART)
pred = predict(emailCART, newdata = test)
pred[1:10,]
pred.prob = pred[,2]
table(test$responsive, pred.prob >= 0.5)
accuracy = (195+25) / nrow(test)
accuracy
table(test$responsive)
215/(215+42)
library(ROCR)
predROCR = prediction(pred.prob, test$responsive)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize = TRUE)
performance(predROCR, "auc")@y.values

#Unit 5 Assignment 1 detecting vandalism on wikipedia
wiki = read.csv('wiki.csv', stringsAsFactors =  FALSE)
wiki$Vandal = as.factor(wiki$Vandal)
table(wiki$Vandal)
corpusAdded = Corpus(VectorSource(wiki$Added))
corpusAdded
corpusAdded = tm_map(corpusAdded, removeWords, stopwords('english'))
length(stopwords("english"))
corpusAdded = tm_map(corpusAdded, stemDocument)
dtmAdded = DocumentTermMatrix(corpusAdded)
dtmAdded
sparseAdded = removeSparseTerms(dtmAdded, 0.997)
sparseAdded
wordsAdded = as.data.frame(as.matrix(sparseAdded))
wordsAdded
colnames(wordsAdded) = paste("A", colnames(wordsAdded))
corpusRemoved = Corpus(VectorSource(wiki$Removed))
corpusRemoved = tm_map(corpusRemoved, removeWords, stopwords('english'))
corpusRemoved = tm_map(corpusRemoved, stemDocument)
dtmRemoved = DocumentTermMatrix(corpusRemoved)
sparseRemoved = removeSparseTerms(dtmRemoved, 0.997)
wordsRemoved = as.data.frame(as.matrix(sparseRemoved))
colnames(wordsRemoved) = paste("R", colnames(wordsRemoved))
str(wordsRemoved)
wikiWords = cbind(wordsAdded, wordsRemoved)
colnames(wikiWords) = make.names(colnames(wikiWords))
wikiWords$Vandal = wiki$Vandal
table(wikiWords$Vandal)
set.seed(123)
library(caTools)
spl = sample.split(wikiWords$Vandal, SplitRatio = 0.7)
train = subset(wikiWords, spl == TRUE)
test = subset(wikiWords, spl == FALSE)
table(test$Vandal)
library(rpart)
library(rpart.plot)
wikiWordsCART = rpart(Vandal~., data = train, method = "class")
prp(wikiWordsCART)
pred = predict(wikiWordsCART, newdata = test,  type="class")
table(test$Vandal, pred)
accuracy = (614 + 19) / nrow(test)
accuracy
wikiWords2 = wikiWords
wikiWords2$HTTP = ifelse(grepl("http",wiki$Added,fixed=TRUE), 1, 0)
table(wikiWords2$HTTP)
train2 = subset(wikiWords2, spl == TRUE)
test2 = subset(wikiWords2, spl == FALSE)
wikiWordsCART2 = rpart(Vandal~., data = train2, method = "class")
prp(wikiWordsCART2)
pred = predict(wikiWordsCART2, newdata = test2,  type="class")
table(test2$Vandal, pred)
(605+64) / (605+13+481+64)
wikiWords2$NumWordsAdded = rowSums(as.matrix(dtmAdded))
wikiWords2$NumWordsRemoved = rowSums(as.matrix(dtmRemoved))
str(wikiWords2$NumWordsAdded)
mean(wikiWords2$NumWordsAdded)
train2 = subset(wikiWords2, spl == TRUE)
test2 = subset(wikiWords2, spl == FALSE)
wikiWordsCART2 = rpart(Vandal~., data = train2, method = "class")
prp(wikiWordsCART2)
pred = predict(wikiWordsCART2, newdata = test2,  type="class")
table(test2$Vandal, pred)
(514+248) / nrow(test2)
wikiWords3 = wikiWords2
wikiWords3$Minor = wiki$Minor
wikiWords3$Loggedin = wiki$Loggedin
train3 = subset(wikiWords3, spl == TRUE)
test3 = subset(wikiWords3, spl == FALSE)
wikiWordsCART3 = rpart(Vandal~., data = train3, method = "class")
prp(wikiWordsCART3)
pred = predict(wikiWordsCART3, newdata = test3,  type="class")
table(test3$Vandal, pred)
(595+241) / nrow(test3)
prp(wikiWordsCART3)
str(wiki)
#Unit 5 Assignment 2 Automating Reviews in Medicine
trials = read.csv('clinical_trial.csv', stringsAsFactors=FALSE)
summary(trials)
str(trials)
# fileEncoding="latin1"
table(nchar(trials$abstract)==0)
which.min(nchar(trials$title))
corpusTitle = Corpus(VectorSource(trials$title))
corpusAbstract = Corpus(VectorSource(trials$abstract))
corpusTitle = tm_map(corpusTitle, tolower)
corpusAbstract = tm_map(corpusAbstract,tolower)
corpusTitle = tm_map(corpusTitle, removePunctuation)
corpusAbstract = tm_map(corpusAbstract, removePunctuation)
corpusTitle = tm_map(corpusTitle, removeWords, stopwords('english'))
corpusAbstract = tm_map(corpusAbstract, removeWords, stopwords('english'))
corpusTitle = tm_map(corpusTitle, stemDocument)
corpusAbstract = tm_map(corpusAbstract, stemDocument)
dtmTitle = DocumentTermMatrix(corpusTitle)
dtmAbstract = DocumentTermMatrix(corpusAbstract)
sparseAbstract
sparseTitle = removeSparseTerms(dtmTitle, 0.95)
dtmTitle = as.data.frame(as.matrix(sparseTitle))
sparseAbstract = removeSparseTerms(dtmAbstract, 0.95)
dtmAbstract = as.data.frame(as.matrix(sparseAbstract))
str(dtmTitle)
str(dtmAbstract)
which.max(colSums(dtmAbstract))
colnames(dtmTitle) = paste0("T", colnames(dtmTitle))
colnames(dtmAbstract) = paste0("A", colnames(dtmAbstract))
dtm = cbind(dtmTitle, dtmAbstract)
dtm$trial = trials$trial
str(dtm)
set.seed(144)
spl = sample.split(dtm$trial, SplitRatio = 0.7)
train = subset(dtm, spl == TRUE)
test = subset(dtm, spl == FALSE)
table(train$trial)
train_bl = 730 / (730+572)
train_bl
library(rpart)
library(rpart.plot)
trialCART = rpart(trial~., data = train, method = "class")
prp(trialCART)
pred = predict(trialCART)
max(pred[,2])
table(train$trial, pred[,2] > 0.5)
accuracy = (631 + 441) / nrow(train)
accuracy
#compute senstivity, tp / (tp + fn)
441/(441 + 131)
#compute specificity, tn / (tn + fp)
631/(631+99)
predTest = predict(trialCART, newdata = test, type = "class")
table(test$trial, predTest)
(261+162) / (261 + 52 + 83 + 162)
library(ROCR)
ROCRpred = prediction(as.numeric(predTest),test$trial)#Ҫת??????????
as.numeric(performance(ROCRpred, "auc")@y.values)

#Assignment 3 Separating Spam from Ham  
emails = read.csv("emails.csv", stringsAsFactors = FALSE)
str(emails)
table(emails$spam)
library(tm)
library(SnowballC)
emails$text[1]
corpus = Corpus(VectorSource(emails$text))
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords('english'))
corpus = tm_map(corpus, stemDocument)
dtm = DocumentTermMatrix(corpus)
spdtm = removeSparseTerms(dtm, 0.95)
spdtm
emailsSparse = as.data.frame(as.matrix(spdtm))
colnames(emailsSparse) = make.names(colnames(emailsSparse))
str(dtm)
max(nchar(emails$text))
which.min(nchar(emails$text))
emailsSparse$spam = emails$spam
sort(colSums(subset(emailsSparse, spam == 0)))
sort(colSums(subset(emailsSparse, spam == 1)))#Note that the variable "spam" is the dependent variable and is not the frequency of a word stem.
emailsSparse$spam = as.factor(emailsSparse$spam)
#start building ML models 
library(caTools)
library(rpart)
library(rpart.plot)
library(randomForest)
emailsSparse$spam = as.factor(emailsSparse$spam)
set.seed(123)
spl = sample.split(emailsSparse, SplitRatio = 0.7)
train = subset(emailsSparse, spl == TRUE)
test = subset(emailsSparse, spl == FALSE)
spamLog = glm(spam ~., data = train, family = "binomial")
spamCART = rpart(spam~., data = train, method = "class")
set.seed(123)
spamRF = randomForest(spam~., data = train, method = "class")
predictLog = predict(spamLog,type = "response")
table(as.numeric(predictLog < 0.00001))
predictCART = predict(spamCART)
table(as.numeric(predictCART > 0.99999))
predictRF = predict(spamRF, type= "prob")
predictRF = as.numeric(predictRF[,2])
predictRF
table(as.numeric(predictLog < 0.99999), as.numeric(predictLog > 0.00001 ) )
summary(spamLog)
prp(spamCART)
#train accuracy of log model 
table(train$spam, as.numeric(predictLog) > 0.5)
accuracy = (917+2978) / nrow(train)
accuracy
library(ROCR)
ROCRpred = prediction(as.numeric(predictLog),train$spam)#Ҫת??????????
as.numeric(performance(ROCRpred, "auc")@y.values)
#train accuracy of  CART model 
table(train$spam, as.numeric(predictCART[,2]) > 0.5)
accuracy = (2900+894) / nrow(train)
accuracy
ROCRpred = prediction(as.numeric(predictCART),train$spam)#Ҫת??????????
as.numeric(performance(ROCRpred, "auc")@y.values)
#train accuracy of  RF model
table(train$spam, as.numeric(predictRF) > 0.5)
accuracy = (3004+916) / nrow(train)
accuracy
ROCRpred = prediction(as.numeric(predictCART),train$spam)#Ҫת??????????
as.numeric(performance(ROCRpred, "auc")@y.values)
ROCRpred = prediction(as.numeric(predictRF),train$spam)#Ҫת??????????
as.numeric(performance(ROCRpred, "auc")@y.values)
#Obtain predicted probabilities for the testing set for each of the models
predictLog = predict(spamLog, newdata = test, type = "response")
predictCART = predict(spamCART, newdata = test)
set.seed(123)
predictRF = predict(spamRF, newdata = test, type = "prob")[,2]
table(test$spam, as.numeric(predictLog) > 0.5)
table(test$spam, as.numeric(predictCART[,2] > 0.5))
table(test$spam, as.numeric(predictRF) > 0.5)
#accuracy of prediction models 
accuLog = (1245+376) / nrow(test)
accuCART = (1243+383) / nrow(test)
accuRF = (1302+391) / nrow(test)
#auc
ROCRpred = prediction(as.numeric(predictLog),test$spam)#
as.numeric(performance(ROCRpred, "auc")@y.values)
ROCRpred = prediction(predictCART, test$spam)#
as.numeric(performance(ROCRpred, "auc")@y.values)
ROCRpred = prediction(predictRF, test$spam)#
as.numeric(performance(ROCRpred, "auc")@y.values)
# difference between test and train sets indicates whether overfit 
wordCount = rowSums(as.matrix(dtm))
hist(wordCount)
hist(log(wordCount))
emailsSparse$logWordCount = log(wordCount)
boxplot(emailsSparse$logWordCount~emailsSparse$spam)
#????emailsSparse$logWordCount???ν?ģ?? ??Ӧ??test, train????Ҫ??????
train2 = subset(emailsSparse, spl == TRUE)
test2 = subset(emailsSparse, spl == FALSE)
spam2CART = rpart(spam ~., data = train2, method = "class")
set.seed(123)
spam2RF = randomForest(spam ~., data = train2, method = "class")
prp(spam2CART)
predCART2 = predict(spam2CART, newdata = test2)
predRF2 = predict(spam2RF, newdata = test2, type = "prob")[,2]
table(test2$spam, as.numeric(predCART2[,2] > 0.5))
table(test2$spam, as.numeric(predRF2) > 0.5)
(1229+390) / nrow(test2)
(1305+389) / nrow(test2)
ROCRpred = prediction(as.numeric(predCART2[,2]), test2$spam)
as.numeric(performance(ROCRpred, "auc")@y.values)
ROCRpred = prediction(as.numeric(predRF2), test2$spam)
as.numeric(performance(ROCRpred, "auc")@y.values)

#Unit 6 Clustering 

#Demo 1
movies = read.table("movieLens.txt", header = FALSE, sep = "|", quote = "\"")
str(movies)
colnames(movies) = c("ID", "Title", "ReleaseDate","VideoReleaseDate", "IMDB", "Unknown", "Action", "Adventure", "Animation", "Childrens", "Comedy", "Crime", "Documentary", "Drama", "Fantasy", "FilmNoir", "Horror", "Musical", "Mystery", "Romance", "SciFi", "Thriller", "War", "Western")
str(movies)
#REMOVE VAR FROM DATASET
movies$ID = NULL
movies$ReleaseDate = NULL 
movies$VideoReleaseDate = NULL 
movies$IMDB = NULL
movies = unique(movies)
str(movies)
table(movies$Comedy)
table(movies$Western)
table(movies$Romance, movies$Drama)
distances = dist(movies[2:20], method = "euclidean")
clusterMovies = hclust(distances, method = "ward.D2")
plot(clusterMovies)
#k=10
clusterGroups = cutree(clusterMovies, k = 10)
tapply(movies$Action, clusterGroups, mean)
tapply(movies$Romance, clusterGroups, mean)
subset(movies, Title == "Men in Black (1997)")
clusterGroups[257]
cluster2 = subset(movies, clusterGroups ==2)
cluster2$Title[1:10]
#k=2
clusterGroups = cutree(clusterMovies, k = 2)
tapply(movies$Drama, clusterGroups, mean)
cluster2 = subset(movies, clusterGroups ==2)
cluster2

#Demo2
flower = read.csv("flower.csv", header=FALSE)
str(flower)
flowerMatrix = as.matrix(flower)
str(flowerMatrix)
flowerVector = as.vector(flowerMatrix)
str(flowerVector)
flowerVector2 = as.vector(flower)
str(flowerVector2)
distance = dist(flowerVector, method = "euclidean")
clusterIntensity = hclust(distance, method = "ward.D")
plot(clusterIntensity)
rect.hclust(clusterIntensity, k = 3, border = "red")
flowerClusters = cutree(clusterIntensity, k=3)
flowerClusters
tapply(flowerVector, flowerClusters, mean)
dim(flowerClusters) = c(50,50)
image(flowerClusters, axes = FALSE)
image(flowerMatrix, axes = FALSE, col = grey(seq(0,1, length=256)))

#Demo3 
healthy = read.csv("healthy.csv", header = FALSE)
healthyMatrix = as.matrix(healthy)
str(healthyMatrix)
image(healthyMatrix, axes = FALSE, col = grey(seq(0,1,length = 256)))
healthyVector = as.vector(healthyMatrix)
distance = dist(healthyVector, method = "euclidean")
str(healthyVector)
n = 365636
n*(n-1)/2
k = 5
set.seed(1)
KMC = kmeans(healthyVector, centers=k, iter.max = 1000)
str(KMC)
healthyClusters = KMC$cluster
KMC$centers[2]
dim(healthyClusters) = c(nrow(healthyMatrix), ncol(healthyMatrix))
image(healthyClusters, axes = FALSE, col = rainbow(k))

#Demo4
tumor = read.csv("tumor.csv", header = FALSE)
tumorMatrix = as.matrix(tumor)
tumorVector = as.vector(tumorMatrix)
install.packages("flexclust")
library(flexclust)
KMC.kcca = as.kcca(KMC, healthyVector)
tumorClusters = predict(KMC.kcca, newdata = tumorVector)
dim(tumorClusters) = c(nrow(tumorMatrix), ncol(tumorMatrix))
image(tumorClusters, axes = FALSE, col = rainbow(k))

#Uni6 Assignment 1: Daily Kos
dk = read.csv("dailykos.csv")
distance = dist(dk, method = "euclidean")
kosHierClust = hclust(distance, method = "ward.D")
plot(kosHierClust)
clusterGroups = cutree(kosHierClust, k = 7)
cluster1 = subset(dk, clusterGroups ==1)
cluster2 = subset(dk, clusterGroups ==2)
cluster3 = subset(dk, clusterGroups ==3)
cluster4 = subset(dk, clusterGroups ==4)
cluster5 = subset(dk, clusterGroups ==5)
cluster6 = subset(dk, clusterGroups ==6)
cluster7 = subset(dk, clusterGroups ==7)
nrow(cluster3) 
tail(sort(colMeans(cluster1)))
tail(sort(colMeans(cluster)))
set.seed(1000)
kmdk = kmeans(dk, centers=7)
kmdk
kcluster1 = subset(dk, kmdk$cluster ==1)
kcluster2 = subset(dk, kmdk$cluster ==2)
kcluster3 = subset(dk, kmdk$cluster ==3)
kcluster4 = subset(dk, kmdk$cluster ==4)
kcluster5 = subset(dk, kmdk$cluster ==5)
kcluster6 = subset(dk, kmdk$cluster ==6)
kcluster7 = subset(dk, kmdk$cluster ==7)
nrow(kcluster2)
table(clusterGroups,kmdk$cluster)##alternative method kclust = split(dk, kmdk$cluster)
tail(sort(colMeans(kcluster7)))

#Uni6 Assignment 2: Market Segmentation for Airlines 
airlines = read.csv("AirlinesCluster.csv")
summary(airlines)
#normalize data
install.packages("caret")
library(caret)
preproc = preProcess(airlines)
airlinesNorm = predict(preproc, airlines)
summary(airlinesNorm)
distance = dist(airlinesNorm, method = "euclidean")
HierClust = hclust(distance, method = "ward.D")
plot(HierClust)
clusterGroups = cutree(HierClust, k = 5)
cluster1 = subset(airlines, clusterGroups ==1)
nrow(cluster1)
tapply(airlines$Balance, clusterGroups, mean)
tapply(airlines$QualMiles, clusterGroups, mean)
tapply(airlines$BonusMiles, clusterGroups, mean)
tapply(airlines$BonusTrans, clusterGroups, mean)
tapply(airlines$FlightMiles, clusterGroups, mean)
tapply(airlines$FlightTrans, clusterGroups, mean)
tapply(airlines$DaysSinceEnroll, clusterGroups, mean)
tapply(airlines$None, clusterGroups, mean)
set.seed(88)
kmal = kmeans(airlinesNorm, centers=5, iter.max = 1000)
table(kmal$cluster)
table(clusterGroups)

#Uni6 Assignment 3: Stock Price Prediction
stocks = read.csv("StocksCluster.csv")
str(stocks)
table(stocks$PositiveDec)
6324 / (6324+5256)
sort(cor(stocks))
summary(stocks)
set.seed(144)
library(caTools)
spl = sample.split(stocks$PositiveDec, SplitRatio = 0.7)
stocksTrain = subset(stocks, spl == TRUE)
stocksTest = subset(stocks, spl == FALSE)
StocksModel = glm(PositiveDec ~., data = stocksTrain, family = 'binomial')
tmp_pred = predict(StocksModel, type = 'response')
table(stocksTrain$PositiveDec, tmp_pred > 0.5)
accuracy = (990 + 3640) / nrow(stocksTrain)
accuracy
pred = predict(StocksModel, newdata = stocksTest, type = 'response')
table(stocksTest$PositiveDec, pred > 0.5)
accuracy = (417 + 1553) / nrow(stocksTest)
table(stocksTest$PositiveDec)
bl_accuracy = 1897 / (1577 + 1897)
bl_accuracy
limitedTrain = stocksTrain 
limitedTrain$PositiveDec = NULL
limitedTest = stocksTest
limitedTest$PositiveDec = NULL
library(caret)
preproc = preProcess(limitedTrain)
normTrain = predict(preproc, limitedTrain)
normTest = predict(preproc, limitedTest)##subtract mean and divided by the sd from the training set
mean(normTrain$ReturnJan)
mean(normTest$ReturnJan)
set.seed(144)
km = kmeans(normTrain, centers = 3)
table(km$cluster)
##flexclust 
library(flexclust)
km.kcca = as.kcca(km, normTrain)
clusterTrain = predict(km.kcca)
clusterTest = predict(km.kcca, newdata = normTest)
table(clusterTest)
stocksTrain1 = subset(stocksTrain, clusterTrain == 1)
stocksTrain2 = subset(stocksTrain, clusterTrain == 2)
stocksTrain3 = subset(stocksTrain, clusterTrain == 3)
mean(stocksTrain1$PositiveDec)
mean(stocksTrain2$PositiveDec)
mean(stocksTrain3$PositiveDec)
stocksTest1 = subset(stocksTest, clusterTest == 1)
stocksTest2 = subset(stocksTest, clusterTest == 2)
stocksTest3 = subset(stocksTest, clusterTest == 3)
StocksModel1 = glm(PositiveDec ~., data = stocksTrain1, family = binomial)
StocksModel2 = glm(PositiveDec ~., data = stocksTrain2, family = binomial)
StocksModel3 = glm(PositiveDec ~., data = stocksTrain3, family = binomial)

summary(StocksModel1)
summary(StocksModel2)
summary(StocksModel3)

PredictTest1 = predict(StocksModel1, newdata = stocksTest1, type = 'response')
PredictTest2 = predict(StocksModel2, newdata = stocksTest2, type = 'response')
PredictTest3 = predict(StocksModel3, newdata = stocksTest3, type = 'response')

table(stocksTest1$PositiveDec, PredictTest1 > 0.5)
(43+639) / nrow(stocksTest1)
table(stocksTest2$PositiveDec, PredictTest2 > 0.5)
(277+812) / nrow(stocksTest2)
table(stocksTest3$PositiveDec, PredictTest3 > 0.5)
(119+123) / nrow(stocksTest3)

AllPredictions = c(PredictTest1, PredictTest2, PredictTest3)
AllOutcomes = c(stocksTest1$PositiveDec, stocksTest2$PositiveDec, stocksTest3$PositiveDec)
table(AllPredictions>0.5, AllOutcomes)
(439 + 1574) / (439 + 1574 + 323 + 1138)

#Unit 7 Data Visulisation 
#Data Exploration, Modeling and Sharing results

##Demon WHO 
WHO = read.csv("WHO.csv")
str(WHO)
plot(WHO$GNI, WHO$FertilityRate)
install.packages("ggplot2")
library(ggplot2)
scatterplot = ggplot(WHO, aes(x = GNI, y = FertilityRate))
scatterplot + geom_point()
scatterplot + geom_line()
scatterplot + geom_point(color = "blue", size = 3, shape = 15)
scatterplot + geom_point(color = "darkred", size = 3, shape = 8) + ggtitle("Fertility Rate vs. Gross National Income")
fertilityGNIplot = scatterplot + geom_point(color = "darkred", size = 3, shape = 8) + ggtitle("Fertility Rate vs. Gross National Income")
pdf("MyPlot.pdf")
print(fertilityGNIplot)
dev.off()# to close the file
#color the points by region 
ggplot(WHO, aes(x = GNI, y = FertilityRate, color = Region)) + geom_point()
ggplot(WHO, aes(x = GNI, y = FertilityRate, color = LifeExpectancy)) + geom_point()
ggplot(WHO, aes(x = FertilityRate, y = Under15)) + geom_point()
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point()
model = lm(Under15 ~ log(FertilityRate), data = WHO)
summary(model)
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm")
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm", level = 0.99)
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method = "lm", se = FALSE, color = 'orange')
ggplot(WHO, aes(x = FertilityRate, y = Under15, color = Region)) + geom_point() + scale_color_brewer(palette="Dark2")

##Demo2 Chicago Police 
mvt = read.csv("mvt.csv", stringsAsFactors = FALSE)
str(mvt)
mvt$Date = strptime(mvt$Date, format="%m/%d/%y %H:%M")
mvt$Weekday = weekdays(mvt$Date)
mvt$Hour = mvt$Date$hour
str(mvt)
table(mvt$Weekday)
WeekdayCounts=as.data.frame(table(mvt$Weekday))
str(WeekdayCounts)
library(ggplot2)
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group = 1))
WeekdayCounts$Var1 = factor(WeekdayCounts$Var1, ordered =TRUE, levels =c("Sunday", "Monday", "Tuesday", "Wednesday", " Thursday", "Friday", "Saturday"))
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group = 1)) + xlab("Day of the week") + ylab("Total Motor Vehicle Theft")
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group = 1), linetype =2)# make the line dashed 
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group = 1), alpha = 0.3)# make the line light in color
table(mvt$Weekday, mvt$Hour)
DayHourCounts = as.data.frame(table(mvt$Weekday, mvt$Hour))
str(DayHourCounts)
DayHourCounts$Hour = as.numeric(as.character(DayHourCounts$Var2))
ggplot(DayHourCounts, aes(x = Hour, y = Freq)) + geom_line(aes(group = Var1))
ggplot(DayHourCounts, aes(x = Hour, y = Freq)) + geom_line(aes(group = Var1, color = Var1, size =2))
DayHourCounts$Var1 = factor(DayHourCounts$Var1, ordered = TRUE, levels = c("Monday", "Tuesdy","Wednesday", " Thursday", "Friday", "Saturday", "Sunday"))
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq))
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill = Freq)) + scale_fill_gradient(name = "Total MV Thefts", low = "white", high = "red") + theme(axis.title.y = element_blank())#element_blank to get rid of one of the labels 
install.packages("maps")
install.packages("ggmap")
if(!requireNamespace("devtools")) 
install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup", force = TRUE)
library(maps)
library(ggmap)
register_google(key = "AIzaSyD-KCGr-_prpQMzVxK2duZLhrrhpao6pN8")
library(httr)
#set_config(use_proxy(url="127.0.0.1"))
chicago = get_map(location = "chicago", zoom = 11)
ggmap(get_googlemap())
ggmap(chicago)
LatLonCounts = as.data.frame(table(round(mvt$Longitude,2), round(mvt$Latitude,2)))
str(LatLonCounts)
LatLonCounts$Long = as.numeric(as.character(LatLonCounts$Var1))
LatLonCounts$Lat = as.numeric(as.character(LatLonCounts$Var2))
ggmap(chicago) + geom_point(data = LatLonCounts, aes(x = Long, y = Lat, color = Freq, size = Freq)) + scale_color_gradient(low = "yellow", high = "red")
ggmap(chicago) + geom_title(data = LatLonCounts, aes(x = Long, y = Lat, alpha = Freq), fill = "red")
str(LatLonCounts)
LatLonCounts2 = subset(LatLonCounts, Freq > 0)
str(LatLonCounts2)
1638 - 686
#Demo3: Murder 
murders = read.csv("murders.csv")
str(murders)
statesMap = map_data("state")
str(statesMap)
ggplot(statesMap, aes(x = long, y = lat, group = group)) + geom_polygon(fill = "white", color = "black")
murders$region = tolower(murders$State)
murderMap = merge(statesMap, murders, by="region")
str(murderMap)
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=Murders)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide = "legend")
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=Population)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide = "legend")
murderMap$MurderRate = murderMap$Murders/murderMap$Population * 100
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=MurderRate)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide = "legend")
##exclude Washington.Dc, an outlier in the prediction
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=MurderRate)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide = "legend", limits = c(0,10))
#which state has the highest gun ownership rate?
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=GunOwnership)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide = "legend")

##Recitation
library(ggplot2)
intl = read.csv("intl.csv")
str(intl)
ggplot(intl, aes(x=Region, y=PercentOfIntl)) + geom_bar(stat="identity") + geom_text(aes(label=PercentOfIntl))
intl = transform(intl, Region = reorder(Region, -PercentOfIntl))
str(intl)
intl$PercentOfIntl = intl$PercentOfIntl * 100
ggplot(intl, aes(x=Region, y = PercentOfIntl)) + 
geom_bar(stat="identity", fill = "darkblue") + 
geom_text(aes(label=PercentOfIntl), vjust=-0.4) + 
ylab("Percent of International Students") + 
theme(axis.title.x=element_blank(), axis.text.x=element_text(angle=45, hjust=1))
library(ggmap)
intlall = read.csv("intlall.csv", stringsAsFactors = FALSE)
head(intlall)
intlall[is.na(intlall)]=0
head(intlall)
world_map = map_data("world")
str(world_map)
world_map = merge(world_map, intlall, by.x="region", by.y="Citizenship")##x = world_map, y = intlall
str(world_map)
options(download.file.method = "libcurl")
install.packages("maps")
install.packages("maptools")
install.packages("mapdata")
install.packages("mapproj")##xcode-select --install
library(maps)
library(maptools)
library(mapdata)
library(mapproj)
library(ggmap)
#draw a world map
ggplot(world_map, aes(x=long, y=lat, group=group)) + 
  geom_polygon(fill="white", color ="black") +
  coord_map("mercator")
world_map = world_map(order(world_map$group, world_map$order))#reorder the worldmap data
ggplot(world_map, aes(x=long, y=lat, group=group)) + 
  geom_polygon(fill="white", color ="black") +
  coord_map("mercator")
table(intlall$Citizenship)
intlall$Citizenship[intlall$Citizenship=="China (People's Republic Of)"] = "China"
table(intlall$Citizenship)
world_map = merge(map_data("world"), intlall, by.x="region", by.y="Citizenship")
world_map = world_map(order(world_map$group, world_map$order))
ggplot(world_map, aes(x=long, y=lat, group = group)) + geom_polygon(aes(fill=Total), color = "black") + coord_map("mercator")
ggplot(world_map, aes(x=long, y=lat, group = group)) + geom_polygon(aes(fill=Total), color = "black") + coord_map("ortho", orientation = c(20,3,0))
ggplot(world_map, aes(x=long, y=lat, group = group)) + geom_polygon(aes(fill=Total), color = "black") + coord_map("ortho", orientation = c(-37,175,0))
ggplot(world_map, aes(x=long, y=lat, group))
#scales:Using Line Charts Instead 
install.packages("reshape2")
library(reshape2)
library(ggplot2)
households = read.csv("households.csv")
str(households)
# year group fraction
households[,1:2]
head(melt(households,id="Year"))
households[,1:3]
melt(households, id="Year")[1:10,]
ggplot(melt(households, id = "Year"), aes(x=Year, y=value, color = variable)) +geom_line(size=2) + geom_point(size=5) + ylab("PercentofHouse")

##Unit 7 Assignment 1:Election Forecasting Revisited 
library(ggplot2)
library(ggmap)
library(maps)
statesMap = map_data("state")
#The variable "order" defines the order to connect the points within each group
#the variable "region" gives the name of the state.
str(statesMap)
table(statesMap$group)
ggplot(statesMap, aes(x = long, y = lat, group = group)) + geom_polygon(fill = "white", color = "black")
polling = read.csv("PollingImputed.csv")
str(polling)
Train = subset(polling, Year < 2012)
Test = subset(polling, Year == 2012)
mod2 = glm(Republican~SurveyUSA+DiffCount, data=Train, family="binomial")
TestPrediction = predict(mod2, newdata=Test, type="response")
TestPredictionBinary = as.numeric(TestPrediction > 0.5)
predictionDataFrame = data.frame(TestPrediction, TestPredictionBinary, Test$State)
table(predictionDataFrame$TestPredictionBinary)
mean(predictionDataFrame$TestPrediction)
predictionDataFrame$region = tolower(predictionDataFrame$Test.State)
predictionMap = merge(statesMap, predictionDataFrame, by = "region")
predictionMap = predictionMap[order(predictionMap$order),]
str(predictionMap)
str(statesMap)
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPredictionBinary)) + geom_polygon(color = "black")
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPrediction))+ geom_polygon(color = "black") + scale_fill_gradient(low = "blue", high = "red", guide = "legend", breaks= c(0,1), labels = c("Democrat", "Republican"), name = "Prediction 2012")
predictionDataFrame$TestPrediction[predictionDataFrame$Test.State == 'Florida']
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPrediction)) + geom_polygon(color = "black", linetype = 1, alpha = 10, size =3) + scale_fill_gradient(low = "blue", high = "red", guide = "legend", breaks= c(0,1), labels = c("Democrat", "Republican"), name = "Prediction 2012")

##Unit 7 Assignment 2: Visualizing Network Data
edges = read.csv("edges.csv")
users = read.csv("users.csv")
str(edges)
str(users)
table(users$school)
tmp = subset(users, school != "")
table(tmp$locale)
#average number of friends per user 
 (146 * 2) / 59
table(users$gender,users$school)
install.packages("igraph")
library(igraph)
g = graph.data.frame(edges, FALSE, users)#the relation is not directed 
plot(g)
plot(g, vertex.size=5, vertex.label=NA)
table(degree(g)>=10) 
V(g)$size = degree(g)/2+2#change size of the dot
plot(g, vertex.label=NA)
#gender
V(g)$color = "black"
V(g)$color[V(g)$gender == "A"] = "red"
V(g)$color[V(g)$gender == "B"] = "gray"
plot(g, vertex.label=NA)
#school
V(g)$color = "black"
V(g)$color[V(g)$school == "A"] = "green"
V(g)$color[V(g)$school == "AB"] = "yellow"
plot(g, vertex.label=NA)
#locale
table(users$locale)
V(g)$color = "black"
V(g)$color[V(g)$locale == "A"] = "red"
V(g)$color[V(g)$locale == "B"] = "grey"
plot(g, vertex.label=NA, edge.width = 3)
?igraph.plotting
rglplot(g, vertex.label=NA, width = 30)
install.packages('rgl')
library(rgl)

##Unit 7 Assignment 3: Visualizing Network Data
tweets = read.csv("tweets.csv", stringsAsFactors = FALSE)
library(tm)
library(SnowballC)
install.packages("wordcloud")
library("wordcloud")
install.packages("RColorBrewer")
library("RColorBrewer")
corpus = Corpus(VectorSource(tweets$Tweet))
# to lower, removePunctuation, removeWords, stemDocument
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, removePunctuation)
stopwords('english')[1:10]
corpus = tm_map(corpus, removeWords, stopwords("english"))
frequencies = DocumentTermMatrix(corpus)
allTweets = as.data.frame(as.matrix(frequencies))
ncol(allTweets)# # of words depends on # of variables 
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25))
#remove the word apple
corpus = tm_map(corpus, removeWords, c("apple", stopwords("english")))
frequencies = DocumentTermMatrix(corpus)
allTweets = as.data.frame(as.matrix(frequencies))
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25))
str(tweets)
#question 3 
tweetsNeg = subset(allTweets, tweets$Avg <= -1)
wordcloud(colnames(tweetsNeg), colSums(tweetsNeg))
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25), random.order=FALSE)
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25), rot.per = 0.5)#50% of words are rotated 
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25), random.color = FALSE)#color depend on freq
#experiment with RColorBrewer
brewer.pal()
display.brewer.all()
display.brewer.all()#"YlOrRd"
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25), colors = brewer.pal(9,"Blues"))
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25), colors = brewer.pal(9, "Blues")[c(-5, -6, -7, -8, -9)])
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25), colors = brewer.pal(9, "Blues")[c(-1,-2,-3,-4)])
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25), colors = brewer.pal(9, "Blues")[c(-5, -6, -7, -8, -9)])
wordcloud(colnames(allTweets), colSums(allTweets), scale = c(2, 0.25), colors = brewer.pal(9, "Blues")[c(5,6,7,8,9)])

##Unit 7 Assignment 4: Visualizing Attributes of Parole Violators 
library(ggplot2)
parole = read.csv("parole.csv")
str(parole)
parole$male = as.factor(parole$male)
parole$state = as.factor(parole$state)
parole$crime = as.factor(parole$crime)
table(parole$male, parole$violator)
14 / (14+64)
ken = subset(parole, state == 2)
str(ken)
table
table(ken$crime, ken$state)
ggplot(data=parole, aes(x=age)) + geom_histogram(binwidth=5, boundary=0, color="blue", fill="cornflowerblue")#Q2
ggplot(data=parole, aes(x=age)) + geom_histogram(binwidth=5, boundary=0) + facet_grid(male~.)#change graph to top to bottom
ggplot(data=parole, aes(x=age)) + geom_histogram(binwidth=5, boundary=0) + facet_grid(.~male)#change graph to side by side
ggplot(data = parole, aes(x=age, fill=male)) + geom_histogram(binwidth=5, boundary=0)
#define our own palette
colorPalette = c("#000000", "#E69F00", "56B4E9", "009E73", "#F0E442", "#0072B2", "D55E00", "#CC79A7")
ggplot(data=parole, aes(x=age, fill = male)) + geom_histogram(binwidth=5, boundary=0, position="identity", alpha=0.5) + scale_fill_manual(values=colorPalette)
ggplot(data=parole, aes(x=time.served)) + geom_histogram(binwidth=0.1, boundary=0, color="blue", fill="cornflowerblue")#Q4
ggplot(data=parole, aes(x=time.served)) + geom_histogram(binwidth=1, boundary=0, color="blue", fill="cornflowerblue") +  facet_grid(.~crime)#Q4
#pay attention to the value of x and fill
ggplot(data=parole, aes(x=time.served, fill = crime)) + geom_histogram(binwidth=1, boundary=0, position="identity", alpha=0.3) + scale_fill_manual(values=colorPalette)





