
install.packages('mlr',dependencies = T)
install.packages('XML')
library(mlr)

library(scmamp)
library(plotrix)

xalan <- read.csv("R/assignment/xalan-2.4.csv")
xalan$bug = ifelse(xalan$bug == '0',0,1)

task = makeClassifTask(data=xalan[4:22],target=xalan$bug)





make_and_evaluate_model <- function() {
  a <- NULL
  for(x in bugs) {
    if(x > 0)
      a <-c(a, as.integer(1))
    else
      a <-c(a, as.integer(0))
  }
  train_data <- features
  train_data$bugs <- a
  
  ## 1) 定义分类任务
  task = makeClassifTask(data = train_data, target = "bugs")
  learners <- c( 
    "classif.naiveBayes",     #朴素贝叶斯分类器
    "classif.svm",            #支持向量机
    "classif.gbm",            #梯度推进机
    "classif.lda",            #线性判别分析
    "classif.mlp",            #多层感知器
    "classif.randomForest",   #随机森林
    "classif.rpart",          #决策树
    "classif.glmnet",         #GLM with Lasso or Elasticnet Regularization
    "classif.nnet",           #神经网络
    "classif.multinom"        #多元回归
  )
  n = nrow(train_data)
  final.per = NULL  #
  #进行十种方法学习#10次10折交叉验证
  for( x in 1:10 ) {
    #数据集划分,10折交叉验证
    folds <- caret::createFolds(y = train_data$bugs, k = 10)
    #进行一次10折交叉验证	
    for(i in 1:10 ) {
      test.set = folds[[i]]
      train.set = setdiff(1:n, test.set)
      for( l in learners ) {
        ## 2) 定义学习器(线性判别分析)
        learner = makeLearner(l, predict.type = "prob")
        final.mmce = 0  #误差
        final.acc = 0   #精度
        model = train(learner, task, subset = train.set) ## 3) 拟合模型
        pred = predict(model, task = task, subset = test.set) ## 4) 预测模型
        res = performance(pred, measures = list(mmce, acc, auc ))  ## 5) 评估性能 平均误分类误差和精度
        m_auc = unname(res['auc'])
        m_ce = (m_auc - 0.5) / 0.5
        #加入数据帧
        new.per <- data.frame(l, unname(res['mmce']), unname(res['acc']), unname(res['auc']), m_ce)
        final.per <- rbind(final.per, new.per)
      }
    }
  }
  names(final.per) <- c('learn method', 'mmce', 'acc', 'auc', 'ce')
  write.csv(final.per, "/R/assignment/performance.csv")
}

#获取统计数据
get_data <- function() {
  data <- read.csv(file = "/R/assignment/performance.csv")
  mauc <- array(data$auc, c(100, 10))
  m_auc <- NULL
  for(i in 1:100) {
    nf <- data.frame(mauc[i,1], mauc[i,2], mauc[i,3], mauc[i,4], mauc[i,5],
                     mauc[i,6], mauc[i,7], mauc[i,8], mauc[i,9], mauc[i,10])
    m_auc <- rbind(m_auc, nf)
  }
  name <- c('nB', 'svm', 'gbm', 'lda', 'mlp',
            'rF', 'rpart', 'glm', 'nn', 'mnom')
  names(m_auc) <- name
  png(file = "/R/assignment/performance.png")
  boxplot(m_auc)
  dev.off()
  m_auc
}

#e.作CD图比较统计差别
graph_cd <- function(data) {
  png(file = "/R/assignment/CD.png")
  plotCD(results.matrix = data, alpha = 0.05)
  dev.off()
}

#f.画算法图比较统计差别
graph_algorithm <- function(data) {
  data <- filterData(data, remove.cols=1)  #过滤数据
  res <- postHocTest(data, test = "friedman", use.rank=TRUE, correct="bergmann")
  png(file = "/R/assignment/algorithm.png")
  drawAlgorithmGraph(res$corrected.pval, res$summary)
  dev.off()
}

#g.作heatmap图展示模型在测试集上的结果
graph_heatmap <- function(data) {
  library(plotrix)
  m <- as.matrix(data)
  png(file = "/R/assignment/heatmap.png")
  heatmap(m) #m 矩阵
  dev.off()
}

############################ 主程序开始 ####################################
#设置当前目录

data <- read.csv(file = "R/assignment/xalan-2.4.csv")

features <- data[,4:9] # 取出指定数据  4-9列
bugs <- data[,24]      # 24列
metrics <- c('wmc', 'dit', 'noc', 'cbo', 'rfc', 'lcom') #度量指标

#任务步骤
#calc_statis(features)                 #a.描述性统计信息,输出结果"statis.csv"
#calc_cor(features)                    #b.计算相关系数及显著性统计,输出结果"cor.csv"

make_and_evaluate_model()             #c.构建模型并评估

graph_data <- get_data()                   #获取作图数据
graph_data
#graph_cd(graph_data)                       #e.作CD图
#graph_algorithm(graph_data)                #f.作Algorithm图
#graph_heatmap(graph_data)                  #g.作heatmap图
