distributions <- c('exponential','weibull','lognormal','loglogistic')
aft <- setNames(lapply(distributions,function(d)survreg(model_formula,data=cc,dist=d,x=TRUE,y=TRUE)),distributions)
comparison <- do.call(rbind,lapply(names(aft),function(n){m<-aft[[n]];data.frame(distribution=n,n=nrow(cc),events=sum(cc$status),logLik=as.numeric(logLik(m)),parameters=attr(logLik(m),'df'),AIC=AIC(m),BIC=BIC(m),scale=m$scale)}))
comparison$delta_AIC <- comparison$AIC-min(comparison$AIC)
comparison$akaike_weight <- exp(-comparison$delta_AIC/2)/sum(exp(-comparison$delta_AIC/2))
comparison <- comparison[order(comparison$AIC),]; tab(comparison,'parametric_comparison')
aft_table <- do.call(rbind,lapply(names(aft),function(n){m<-aft[[n]]; b<-coef(m); se<-sqrt(diag(vcov(m)))[seq_along(b)];data.frame(distribution=n,term=names(b),time_ratio=exp(b),lower=exp(b-1.96*se),upper=exp(b+1.96*se),p=2*pnorm(-abs(b/se)))}))
tab(aft_table,'aft_time_ratios')
# Marginal standardized fitted survival: average predictions over observed CC covariates.
grid <- seq(0,max(cc$time),length.out=180)
standardized <- list()
for(d in distributions) for(g in levels(cc$rx)) {
  nd <- cc; nd$rx <- factor(g,levels=levels(cc$rx)); lp<-predict(aft[[d]],newdata=nd,type='lp')
  survival_curve <- vapply(grid,function(t)mean(1-psurvreg(t,mean=lp,scale=aft[[d]]$scale,distribution=d)),numeric(1))
  standardized[[paste(d,g)]] <- data.frame(distribution=d,treatment=g,days=grid,survival=survival_curve)
}
curves <- do.call(rbind,standardized);tab(curves,'standardized_aft_curves')
fig('parametric_survival',function(){par(mfrow=c(2,2),mar=c(4,4,3,1));for(d in distributions){plot(0,0,type='n',xlim=range(grid/config$years),ylim=c(0,1),xlab='Years',ylab='Standardized survival',main=d);for(j in 1:3){s<-curves[curves$distribution==d & curves$treatment==levels(cc$rx)[j],];lines(s$days/config$years,s$survival,col=cols[j],lwd=2)};legend('bottomleft',levels(cc$rx),col=cols,lwd=2,bty='n',cex=.7)}},width=9,height=8)
# Cox-Snell diagnostic accounts for censoring; a good fit follows y=x.
fig('aft_cox_snell',function(){par(mfrow=c(2,2),mar=c(4,4,3,1));for(d in distributions){m<-aft[[d]];lp<-predict(m,type='lp');z<-(log(cc$time)-lp)/m$scale;r<-switch(d,exponential=exp(z),weibull=exp(z),lognormal=-pnorm(z,lower.tail=FALSE,log.p=TRUE),loglogistic=-plogis(z,lower.tail=FALSE,log.p=TRUE));stopifnot(all(is.finite(r)));f<-survfit(Surv(r,cc$status)~1);plot(f$time,-log(pmax(f$surv,1e-12)),type='s',xlab='Cox-Snell residual',ylab='Estimated cumulative hazard',main=d,xlim=c(0,3),ylim=c(0,3));abline(0,1,lty=2,col=cols[3])}},width=9,height=8)
