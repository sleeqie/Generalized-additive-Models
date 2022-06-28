#library(wr)
#load("/Users/adedamolayusuf/Desktop/Advanced-DA/agriculture_data_gam.Rda")
#data_short <- data_short
#write.csv(data_short, "data_short.csv")
#task: You are provided with agricultural data for 131 municipalities 
#in the region of Quebec between 1971 and 2006. 
#Using GAM models your task is to infer the evolution of the 
#agricultural production and determine if population density data 
#and distance from Montreal can be used as co variate predictors.

#Are population density data and distance from Montreal
#independent variables? or factors that can predict the agricultural
#production?
#agricultural production= cattle.

#data loading and inspection
gamdata = read.csv("data_short.csv")
gamdata
library(mgcv)
library(ggplot2)
library(gratia)
#devtools::install_github('gavinsimpson/gratia')

gamdata$Pork.....km2. <- as.numeric(as.character(gamdata$Pork.....km2.))
head(gamdata)
summary(gamdata)

#checking the lm and gam for the separate variables 
#cattle
#linear
lm(log(Cattle....km2. +1) ~ Distance.from.Montreal..km., data = gamdata)
plot(log(Cattle....km2. +1) ~ Distance.from.Montreal..km., data = gamdata, xlab="Distance",
     ylab="Cattle/Km2") 
#gam with two variables
a <- gam(log(Cattle....km2. +1)~ s(Distance.from.Montreal..km.) + s(Human.population....km2.), data = gamdata, method = "REML")
par(mfrow = c(1, 2))
plot(a, main="Covariates and Cattle density",
     ylab="Cattle(km2)")
coef(a)
summary(a)
#gam with three variables
moda <- gam(log(Cattle....km2. +1)~ s(Distance.from.Montreal..km.) + s(Human.population....km2.) + s(Year, k = 4), data = gamdata, method = "REML")
summary(moda)
draw(moda)
appraise(moda)
plot(moda, shade = TRUE, shade.col = "turquoise")
plot(moda, pages = 1, shade = TRUE, shade.col = "turquoise" )

#Cattle and covariates over time.
ggplot(gamdata, aes(Distance.from.Montreal..km., Cattle....km2., 
)) +
  geom_point(aes(size= Human.population....km2., color = Year)) +
  labs(y="Cattle density", x="Distance from montreal")


#poultry
lm(log(Poultry....km2. +1) ~ Distance.from.Montreal..km., data = gamdata)
plot(log(Poultry....km2. +1) ~ Distance.from.Montreal..km., data = gamdata, xlab="Distance",
     ylab="Poultry/Km2") 

b <- gam(log(Poultry....km2. +1)~ s(Distance.from.Montreal..km.) + s(Human.population....km2. , k=4), data = gamdata, method = "REML")
b
par(mfrow = c(1, 2))
plot(b, main="Covariates and Poultry density",
     ylab="Poultry(km2)")
coef(b)
summary(b)

modb <- gam(log(Poultry....km2. +1)~ s(Distance.from.Montreal..km.) + s(Human.population....km2.) + s(Year, k = 4), data = gamdata, method = "REML")
summary(modb)
draw(modb)
appraise(modb)
plot(modb, pages = 1, shade = TRUE, shade.col = "turquoise" )

#crops
lm(log(Crops.... +1) ~ Distance.from.Montreal..km., data = gamdata)
plot(log(Crops.... +1) ~ Distance.from.Montreal..km., data = gamdata, xlab="Distance",
     ylab="Crops/Km2") 

c <- gam(log(Crops.... +1)~ s(Distance.from.Montreal..km.) + s(Human.population....km2., k= 4), data = gamdata, method = "REML")
c
par(mfrow = c(1, 2))
plot(c, main="Covariates and Crop density",
     ylab="Crop(km2)")
coef(c)
summary(c)

modc <- gam(log(Crops.... +1) ~ s(Distance.from.Montreal..km.) + s(Human.population....km2.) + s(Year, k = 4), data = gamdata, method = "REML")
summary(modc)
draw(modc)
appraise(modc)
plot(modc, pages = 1, shade = TRUE, shade.col = "turquoise" )

#pork
lm(log(Pork.....km2. +1) ~ Distance.from.Montreal..km., data = gamdata)
plot(Pork.....km2. ~ Distance.from.Montreal..km., data = gamdata, xlab="Distance",
     ylab="Pork/Km2") 

d <- gam(log(Pork.....km2. +1)~ s(Distance.from.Montreal..km.) + s(Human.population....km2., k=4), data = gamdata, method = "REML")
d
par(mfrow = c(1, 2))
plot(d, main="Covariates and Pork density",
     ylab="Pork(km2)")
coef(d)
summary(d)

modd <- gam(log(Pork.....km2. +1) ~ s(Distance.from.Montreal..km.) + s(Human.population....km2.) + s(Year, k = 4), data = gamdata, method = "REML")
summary(modd)
draw(modd)
appraise(modd)
plot(modd, pages = 1, shade = TRUE, shade.col = "turquoise" )








#box plot of evolution of agric production over time.
boxplot(log(Cattle....km2. +1) ~ Year, data = gamdata)
boxplot(log(Cattle....km2. +1) ~ Year, data=gamdata,
            col=(c("grey","yellow")),
            main="Boxplot of cattle density over time", xlab="Year",
            ylab="Cattle(km2)")

boxplot(log(Poultry....km2. +1) ~ Year, data = gamdata)
boxplot(log(Poultry....km2. +1) ~ Year, data=gamdata,
        col=(c("red","blue")),
        main="Boxplot of poultry density over time", xlab="Year",
        ylab="Poultry(km2)")

boxplot(log(Crops.... +1)  ~ Year, data = gamdata)
boxplot(log(Crops.... +1) ~ Year, data=gamdata,
        col=(c("green","blue")),
        main="Boxplot of Crop density over time", xlab="Year",
        ylab="Crop(km2)")

boxplot(log(Pork.....km2. +1) ~ Year, data = gamdata)
boxplot(log(Pork.....km2. +1) ~ Year, data=gamdata,
        col=(c("pink","blue")),
        main="Boxplot of Pork density over time", xlab="Year",
        ylab="Crop(km2)")

#Checking out cattle density for the first 30 municipalities
#cattle
ggplot(gamdata[1:100, ], aes(x=MUNICIPALITY_NAME, y=Cattle....km2. )) + 
  geom_point(size=3) + 
  geom_segment(aes(x=MUNICIPALITY_NAME, 
                   xend=MUNICIPALITY_NAME, 
                   y=0, 
                   yend=log(Cattle....km2.))) + 
  labs(title="Lollipop Chart", 
       subtitle="Cattle density for the first 60 municipalities", 
    ) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6))

#poultry
ggplot(gamdata[1:100, ], aes(x=MUNICIPALITY_NAME, y=Poultry....km2.)) + 
  geom_point(size=3) + 
  geom_segment(aes(x=MUNICIPALITY_NAME, 
                   xend=MUNICIPALITY_NAME, 
                   y=0, 
                   yend=(Poultry....km2.))) + 
  labs(title="Lollipop Chart", 
       subtitle="Poultry density for the first 60 municipalities", 
  ) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6))

#crops
ggplot(gamdata[1:100, ], aes(x=MUNICIPALITY_NAME, y=Crops.... )) + 
  geom_point(size=3) + 
  geom_segment(aes(x=MUNICIPALITY_NAME, 
                   xend=MUNICIPALITY_NAME, 
                   y=0, 
                   yend=(Crops.... ))) + 
  labs(title="Lollipop Chart", 
       subtitle="Crop density for the first 60 municipalities", 
  ) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6))

#pork
ggplot(gamdata[1:100, ], aes(x=MUNICIPALITY_NAME, y=Pork.....km2.)) + 
  geom_point(size=3) + 
  geom_segment(aes(x=MUNICIPALITY_NAME, 
                   xend=MUNICIPALITY_NAME, 
                   y=0, 
                   yend=(Pork.....km2. ))) + 
  labs(title="Lollipop Chart", 
       subtitle="Pork density for the first 60 municipalities", 
  ) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6))







