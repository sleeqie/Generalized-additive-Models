#Introduction

#AIM:  We aim to investigate the spatiotemporal variability of jack mackerel 
#and to assess the relationships between catch per unit effort (CPUE) 
#and environmental and seasonal variables.

#Spatiotemporal, or spatial temporal, is used in data analysis when data is 
#collected across both space and time. It describes a phenomenon in a 
#certain location and time — for example, shipping movements across a 
#geographic area over time. A person uses spatial-temporal reasoning to 
#solve multi-step problems by envisioning how objects move in space and time.

#UNIVARIATE ANALYSIS
#Reading the file
gamdata = read.csv("fish.csv")
gamdata
library(mgcv)
# Examining the data 
head(gamdata)
# Fit a linear model
gam1 <- lm(CPUE ~ Month, data = gamdata)
# Visualize the model
#Seasonal variation in T. japonicus CPUE
boxplot(CPUE ~ Month, data = gamdata) 
boxplot(CPUE ~ Month, data=gamdata, notch=FALSE,
        col=(c("gold","red")),
        main="Boxplot of resource density in four seasons", xlab="Months") 



#MULTIPLE REGRESSION ANALYSIS
# Fit the model
#GAM analysis on the impact of each factor on T. japonicus CPUE: (A) Month, (B) sea level anomaly, (C) Depth, (D) sea surface temperature, (E) sea surface salinity.
#Interpreting GAM outputs
#Statistical summaries

#1. An edf of 1 is equivalent to a straight line. An edf of 2 is equivalent to a quadratic curve, and so on, with higher edfs describing more wiggly curves.
#2. A significant smooth term is one where you can not draw a horizontal line through the 95% confidence interval.
#3. The Ref.df and F columns are test statistics used in an ANOVA test to test overall significance of the smooth. The result of this test is the p-value

gamall <- gam(log(CPUE + 1) ~  s(Month, k = 4) + s(SLA) + s(Depth) + s(SST, k = 4) + s(SSS, k = 4), 
                data = gamdata, method = "REML") 
#check model statistics
summary(gamall)
# Plot the model
plot(gamall, pages = 1, shade = TRUE, shade.col = "DarkGreen")

#model statistics for each environmental factor
summary (gam(log(CPUE + 1) ~  s(Month, k = 4), data = gamdata, method = "REML"))
summary (gam(log(CPUE + 1) ~  s(SLA), data = gamdata, method = "REML"))
summary (gam(log(CPUE + 1) ~  s(SST), data = gamdata, method = "REML"))
summary ( gam(log(CPUE + 1) ~  s(SSS), data = gamdata, method = "REML"))
summary (gam(log(CPUE + 1) ~  s(Depth), data = gamdata, method = "REML"))

#Checking with model factors
summary (gam(log(CPUE + 1) ~  s(Month, k = 4) + s(SLA), data = gamdata, method = "REML"))
summary (gam(log(CPUE + 1) ~  s(Month, k = 4) + s(SLA) + s(Depth), data = gamdata, method = "REML"))
summary (gam(log(CPUE + 1) ~  s(Month, k = 4) + s(SLA) + s(Depth) + s(SSS), data = gamdata, method = "REML"))
summary (gam(log(CPUE + 1) ~  s(Month, k = 4) + s(SLA) +s(Depth) +s(SSS) +s(SST),data = gamdata, method = "REML")) 

#Visualizations using SLA as an example
?plot.gam
gamsla<-gam(log(CPUE + 1) ~  s(SLA), data = gamdata, method = "REML")
plot(gamsla)
plot(gamsla, rug = TRUE)
plot(gamsla, rug = TRUE, residuals = TRUE,
     pch = 1, cex = 1)
plot(gamsla, se = TRUE)
plot(gamsla, shade = TRUE)
# Plot the weight effect
plot(gamsla, select = 1, shade = TRUE, shade.col = "hotpink")
# Make another plot adding the intercept value and uncertainty
plot(gamsla, select = 1, shade = TRUE, shade.col = "hotpink", 
     shift = coef(gamsla)[1], seWithMean = TRUE)

#model checking
#Now that we can fit and plot GAMs, we need some checks to make sure that we have well-fit models. There are several pitfalls we need to look out for when fitting GAMs. 
gam.check(gamall) #we can see that our p values are not significant, so they passed the test, None has significant patterns in their residuals and both have enough basis functions.
#the k value or number of basis functions.
#we can increase k value to solve for low pvalue
#small p-values indicate that residuals are not randomly distributed. This often means there are not enough basis functions. 

#plots
#1. Q-Q plot: which compares the model residuals to a normal distribution. A well-fit model's residuals will be close to a straight line
#2. Histogram: histogram of residuals. We would expect this to have a symmetrical bell shape.
#3. Plot of residual values: These should be evenly distributed around zero.
#4. plot of response against fitted values: A perfect model would form a straight line. We don't expect a perfect model, but we do expect the pattern to cluster around the 1-to-1 line.


#Checking concurvity

# When two variables or covariates in a model are strongly correlated, it's difficult to fit the model, 
#because the outcome variable could be responding to either one. We call this phenomenon collinearity, 
#and it can result in poorly fit models with large confidence intervals. In general, 
#we avoid putting multiple collinear variables into the same model.

#With GAMs, we have an additional potential pitfall. Even if two variables aren't collinear, 
#they may have concurvity, that is, one may be a smooth curve of another. 


#What is important is that you should always look at the worst case, and if the value is high (say, over 0.8), 
#inspect your model more carefully.

concurvity(gamsla, full = TRUE)
concurvity(gamall, full = TRUE)
concurvity(gamall, full = FALSE)

#Spatial GAMs and Interactions
summary (gam(Month ~ s(Lon, k = 4, Lat), # <-- 2 variables 
    data = gamdata, method = "REML"))

gam2d1<- (gam(CPUE ~ s(Lon, k = 4, Lat), 
              data = gamdata, method = "REML"))

#Mixing interaction and single terms
summary (gam(CPUE ~ s(Lon, k = 4, Lat) + s(Month, k= 4),
    data = gamdata, method = "REML"))

gam2d2 <- (gam(CPUE ~ s(Lon, k = 4, Lat) + s(Month, k= 4),
               data = gamdata, method = "REML"))

summary(gam(CPUE ~ s(Lon, k = 4, Lat) + Month + Depth,
    data = gamdata, method = "REML"))

gam2d3<-gam(CPUE ~ s(Lon, k = 4, Lat) + Depth,
     data = gamdata, method = "REML")

#2d plots
plot(gam2d1)
plot(gam2d1, scheme = 1)
plot(gam2d2)
plot(gam2d2, scheme = 1)
plot(gam2d3)
plot(gam2d3, scheme = 1)
#Setting a heat map
plot(gam2d3, scheme = 2)
#using vis for more intuition
vis.gam(x = gam2d3,                # GAM object
        view = c("Lon", "Lat"),   # variables
        plot.type = "persp")    # kind of plot 

vis.gam(x = gam2d3,                # GAM object
        view = c("Lon", "Lat"),   # variables
        plot.type = "persp", se= 2)

#Too far
#The too.far argument is an important one in using these plots to inspect your model. too.far indicates what predictions should not be plotted because they are too far from the actual data.
vis.gam(gam2d3, view = c("Lon", "Lat"), plot.type = "contour", too.far = 0.1)
vis.gam(gam2d3, view = c("Lon", "Lat"), plot.type = "contour", too.far = 0.05)


#You can also control the rotation angle of your perspective plots. The theta parameter controls horizontal rotation, the phi parameter controls vertical rotation, and the r parameter controls how zoomed in the plot is. Plots with low r values have lots of distortion or parallax, while plots with high r values have little sense of perspective.
vis.gam(gam2d3, view = c("Lon", "Lat"), plot.type = "persp", theta = 220)
vis.gam(gam2d3, view = c("Lon", "Lat"), plot.type = "persp", phi = 55)
vis.gam(gam2d3, view = c("Lon", "Lat"), plot.type = "persp", r = 0.1)

#Tensor smooths. Tensor smooths let us model interactions that operate on different scales, such as space and time.
plot(gam(CPUE ~ te(Lon, k = 4, Lat), data = gamdata, method = "REML"))
plot(gam(CPUE ~ te(Lon, Lat, k = c(4, 4)), data = gamdata, method = "REML"))
plot(gam(CPUE ~ s(Lon, k= 4) + s(Lat) + ti(SLA, SST), data = gamdata, method = "REML"))
plot(gam(CPUE ~ s(Lon, k= 4) + s(Lat) + ti(SLA, SST), data = gamdata, method = "REML"))


#
library(mgcv)
library  rr

# Fit the model
tensor_gam <- gam(CPUE ~ te(Lon, Lat) + s(SST),
                  data = gamdata, method = "REML")

# Summarize and plot
summary(tensor_gam)
plot(tensor_gam, scheme = 2)

# Fit the model
tensor_gam2 <- gam(CPUE ~ te(Lon, SLA) + s(Lat) + ti(Lon, SLA, Lat), 
                   data = gamdata, method = "REML")

# Summarize and plot
summary(tensor_gam2)
plot(tensor_gam2, pages = 1)

#GEOSPATIAL VARIATION
#Relationship between oceanographic factors and T. japonicus CPUE
#select rows and coloumns in r
head(gamdata)
gamdata


#SST AND CPUE
#1. 
tensor_gam <- gam(CPUE ~ te(Lon, Lat, k =4) + s(SST),
                  data = gdnov, method = "REML")
plot(tensor_gam, scheme = 2)
vis.gam(gam2d3, view = c("Lon", "Lat"), plot.type = "contour", too.far = 0.1)
vis.gam(gam2d3, view = c("Lon", "Lat"), plot.type = "contour", too.far = 0.05)

#2. 
sst<-ggplot(gamdata, aes(Lon, Lat, z = SST)) + labs(y="Latitude", x="Longitude",
        title="Relationship between SST and CPUE") +
  geom_contour_fill(na.fill = TRUE) + geom_jitter(aes(size= CPUE)) + 
  theme(legend.position="left") + labs(fill = "SST (°C)")
  sst + facet_wrap( ~ Month, nrow=3)

#SSS AND CPUE
sss<-ggplot(gamdata, aes(Lon, Lat, z = SSS)) + labs(y="Latitude", x="Longitude",
      title="Relationship between SSS and CPUE") +
  geom_contour_fill(na.fill = TRUE) + geom_jitter(aes(size= CPUE)) + 
  theme(legend.position="left") + labs(fill = "SSS (PSU)")
sss + facet_wrap( ~ Month, nrow=3)

#Depth AND CPUE

depth<-ggplot(gamdata, aes(Lon, Lat, z = Depth)) + labs(y="Latitude", x="Longitude",
        title="Relationship between Water Depth and CPUE") +
  geom_contour_fill(na.fill = TRUE) + geom_jitter(aes(size= CPUE)) + 
  theme(legend.position="left") + labs(fill = "Depth")
depth + facet_wrap( ~ Month, nrow=3)




gg<-ggplot(gamdata, aes(Lat,Lon)) + labs(y="Latitude", x="Longitude",
     title="Seasonal variation of fishing ground gravity of T. japonicus in the Beibu Gulf") 
gg
gg+geom_contour_fill(aes(fill = stat(level_d)))


#Spatial and temporal variability 
#of T. japonicus CPUE based on time and location at
#the Beibu Gulf

install.packages("scatterplot3d")
library(scatterplot3d)
aa<-scatterplot3d(
  gamdata[,c(2,4,3,5 )], pch = 19,
  main = "Spatial and temporal variability 
of T. japonicus CPUE", highlight.3d=TRUE,
  col.grid="lightblue",
  grid = TRUE, box = FALSE, type= "h",
  mar = c(3, 3, 0.5, 3),       
)

aa + facet_wrap( ~ Year)


?scatterplot3d


















