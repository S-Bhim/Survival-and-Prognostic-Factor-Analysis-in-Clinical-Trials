if (!requireNamespace('survival', quietly=TRUE)) stop('Install survival before running.')
library(survival)
config <- list(seed=20261009L, years=365.25, horizon=5*365.25)
set.seed(config$seed)
options(stringsAsFactors=FALSE, scipen=6)
for (d in c('data','results','results/tables','results/figures')) dir.create(d, recursive=TRUE, showWarnings=FALSE)
cols <- c('#333333','#0072B2','#D55E00')
tab <- function(x, name) write.csv(x, file.path('results/tables', paste0(name,'.csv')), row.names=FALSE, na='')
fig <- function(name, draw, width=7, height=5) {
  for (ext in c('pdf','png')) {
    path <- file.path('results/figures',paste0(name,'.',ext))
    if(ext=='pdf') pdf(path,width=width,height=height, family='Helvetica') else png(path,width=width,height=height,units='in',res=300)
    par(mar=c(4.5,4.5,2.5,1),las=1,cex=.9,bty='l')
    tryCatch(draw(),finally=dev.off())
  }
}
rhs <- 'rx + age10 + sex + lognodes + obstruct + perfor + adhere + differ + extent + surg'
model_formula <- as.formula(paste('Surv(time,status) ~',rhs))
tidy_cox <- function(m) {
  z <- summary(m)
  data.frame(term=rownames(z$coefficients),HR=z$conf.int[,1],lower=z$conf.int[,3],upper=z$conf.int[,4],p=z$coefficients[,5])
}
