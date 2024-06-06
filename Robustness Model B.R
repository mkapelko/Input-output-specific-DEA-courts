
install.packages("Benchmarking")

library(Benchmarking)

setwd("C:\\R PLIKI")

dat1 <- read.table("regionalmulti.txt", header = TRUE)
x1 <- with(dat1, cbind(x1,x2,x3,x4,x5,x6,x7))
y1<- with(dat1, cbind(y1,y2,y3))


me<- mea(x1,y1, RTS = "vrs", ORIENTATION="in-out") 


table.in=matrix(nrow=1565,ncol=2)
table.in[,1]=c(1: 1565)
table.in[,2]= me$eff


capture.output(table.in, file="multieff.txt")


capture.output(me$direc, file="multieffspec.txt")




