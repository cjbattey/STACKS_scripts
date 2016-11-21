setwd("~/Desktop/")
library(data.table);library(plyr);library(magrittr)

#read in and clean up formatting for coords files
setwd("./mummer_out/coords/")
files <- list.files()
i <- 1
for(f in files){
  if(i==1){
    dat <- fread(f,sep=" ",data.table=F)
    i=i+1
  } else {
    tmp <- fread(f,sep=" ",data.table=F)
    dat <- rbind(tmp,dat)
    i=i+1
  }
}
colnames(dat) <- c("refStart","refStop","sep1","qStart","qStop","sep2","refLength","qLength","sep3",
                   "p.identity","sep4","names")
dat$refName <- strsplit(dat$names,"\t") %>% sapply(function(e) unlist(e)[1])
dat$qName <- strsplit(dat$names,"\t") %>% sapply(function(e) unlist(e)[2])

sum <- ddply(dat,.(qName,refName),summarize,totalMatch=sum(qLength)) %>% arrange(totalMatch)
sum2 <- ddply(sum,.(qName),summarize,chr=refName[totalMatch==max(totalMatch)],
             totalMatch=totalMatch[totalMatch==max(totalMatch)])
sum2 <- subset(sum2,totalMatch>1000)
a <- ddply(sum2,.(qName,chr),summarize,nRefs=length(unique(chr)))
write.table(a,"Canna_tgut2_chrXscaffold.txt",sep=" ")




