rows <- list()
for(g in levels(os$rx)) {
  d <- os[os$rx==g,]
  add <- function(variable,level,value) data.frame(treatment=g,variable=variable,level=level,value=value)
  rows[[length(rows)+1]] <- add('Patients','',as.character(nrow(d)))
  for(v in c('age','nodes')) {
    q <- quantile(d[[v]],c(.25,.5,.75),na.rm=TRUE)
    rows[[length(rows)+1]] <- add(v,'Median [IQR]',sprintf('%.1f [%.1f, %.1f]',q[2],q[1],q[3]))
    rows[[length(rows)+1]] <- add(v,'Missing',as.character(sum(is.na(d[[v]]))))
  }
  for(v in c('sex','obstruct','perfor','adhere','differ','extent','surg')) {
    counts <- table(d[[v]],useNA='ifany')
    for(j in seq_along(counts)) rows[[length(rows)+1]] <- add(v,names(counts)[j],sprintf('%d (%.1f%%)',counts[j],100*counts[j]/nrow(d)))
  }
}
long_baseline <- do.call(rbind,rows)
wide_baseline <- reshape(long_baseline,idvar=c('variable','level'),timevar='treatment',direction='wide')
names(wide_baseline) <- sub('^value\\.','',names(wide_baseline))
tab(wide_baseline,'baseline')
followup <- survfit(Surv(time,1-status)~1,data=os)
tab(data.frame(method='Reverse Kaplan-Meier',median_days=unname(summary(followup)$table['median'])),'followup')
