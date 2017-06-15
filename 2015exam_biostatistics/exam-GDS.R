#��������
data <- read.table("GDS4013.txt", header = T)
#�����ݱ�׼��
data <- scale(data)
#���NULLֵ
any(is.na(data))
data <- na.omit(data)

#����ÿ�鷽��ͬ���Լ���P-value
pval <- apply(data,1,function(x){return(var.test(x[1:10],x[11:18])$p.value)})
#���߼����������������P-value,ͬ��T����ͬ��F���������P-value
tpval <- sapply(1:length(pval),function(i){
  if(pval[i]<=0.05){
    tmp<-t.test(data[i,1:10],data[i,11:18],var.equal=F,alternative="less")$p.value}
  else{
    tmp<-t.test(data[i,1:10],data[i,11:18],var.equal=T,alternative="less")$p.value}
  return(tmp)
})
#�ҳ��в���������ľ�������
names(tpval) <- rownames(data)
tpval[tpval<0.05]
length(tpval[tpval<0.05])
sort(tpval, decreasing = F)[1:20]
# FDR���� ȥ��������
ad_tpval <- p.adjust(tpval,method="fdr")
length(ad_tpval[ad_tpval<0.05])
ad_tpval[ad_tpval<0.05]

# ����������֯�ļ׻�������
methy <- read.table("methylation.txt")

nonsig_gene.name <- names(tpval[tpval>0.05])
sig_gene.name    <- names(tpval[tpval<=0.05])
set.seed(1234)
nonsig_gene      <- sample(nonsig_gene.name,200)
sig_gene         <- sample(sig_gene.name,200)

# ������Ӧ����
non.sig.data     <- methy[methy$V1 %in% nonsig_gene,2]
sig.data         <- methy[methy$V1 %in% sig_gene,2]

# ����
var.test(non.sig.data, sig.data)
t.test(non.sig.data, sig.data, var.equal = T)

# power����
# install.packages("pwr")
library(pwr)
# �ؼ��Ǽ���ЧӦֵd(�����Ƕ���������ЧӦֵ����)
# ���㹫ʽ�ο���https://en.wikipedia.org/wiki/Effect_size
# ����������һ�����ܷ������дΪ������������ƽ��ֵ
var1 <- var(non.sig.data)
var2 <- var(sig.data)
delta_all <- sqrt((var1+var2)/2)
d <- abs(mean(non.sig.data)-mean(sig.data))/delta_all
d
power <- pwr.t.test(n=200, d=d, sig.level = .05, 
                    type = "two.sample", alternative = "two.sided")
power


# PCA
# color <- rep(c("blue", "red"), c(10,8))
# pca   <- prcomp(t(data))
# summary(pca)
# compo1 <- pca$x[,1]
# compo2 <- pca$x[,2]
# plot(compo1, compo2, col=color)

