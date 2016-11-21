library(plyr);library(zoo);library(ggplot2)
sam <- read.delim("~/Dropbox/ruhu/rad/stacks/output/beehum/batch_1.fst_S_platycercus-S_calliope.tsv")
z <- read.csv("~/Desktop/Canna_tgut2_ChromScaffoldPairs.csv")
names(z) <- c("row","Chr","tgut_chr","n")
sam <- merge(sam,z,all.x=T,by="Chr")
#levels(sam$tgut_chr) <- c("chr1","chr1A","chr1B","chr2","chr3","chr4","chr4A","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13","chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chr23","chr24","chr25","chr26","chr27","chr28","chrLGE22","chrZ","NA")
#sam$tgut_chr[is.na(sam$tgut_chr)] <- "NA"
sam <- arrange(sam,tgut_chr,Chr,BP)
sam$row <- 1:nrow(sam)
sam$smooth <- rollmean(sam$AMOVA.Fst,k=50,fill="extend") 

#plot fst by chromosome
fst <- ddply(sam,.(tgut_chr),summarize,mean.fst=mean(AMOVA.Fst)) 
ggplot(fst,aes(x=tgut_chr,y=mean.fst))+theme_bw()+theme()+theme(axis.text.x = element_text(angle = 90, hjust = 1,vjust=0.5))+
  geom_bar(stat="identity")+
  geom_hline(aes(yintercept=mean(subset(fst,tgut_chr != "chrZ")$mean.fst)),col="red")+
  geom_hline(aes(yintercept=mean(subset(fst,tgut_chr != "chrZ")$mean.fst)*1.25),col="blue",alpha=0.5)

#by SNP
ggplot(sam,aes(x=row,y=AMOVA.Fst,col=tgut_chr))+theme_bw()+
  theme(legend.position="none",axis.title.x=element_blank(),axis.text.x=element_blank(),
        panel.grid=element_blank(),axis.ticks = element_blank())+
  scale_color_manual(values=rep(c("grey60","grey80"),length(levels(sam$tgut_chr))/2+1))+
  #scale_color_manual(values=rep(brewer.pal(12,"Paired"),length(levels(sam$tgut_chr))/12+1))+
  annotate(geom="text",x=ddply(sam,.(tgut_chr),summarize,r=mean(row))$r,
           y=-.05,size=2.5,
           label=strsplit(levels(sam$tgut_chr),"chr") %>% sapply(function(e) e[2]) %>% append("NA"))+
  geom_point(size=0.25)+
  geom_point(data=subset(sam,Fisher.s.P<0.05),aes(x=row,y=AMOVA.Fst),col="red",size=0.25)+
  geom_line(aes(x=row,y=smooth),col="black")

