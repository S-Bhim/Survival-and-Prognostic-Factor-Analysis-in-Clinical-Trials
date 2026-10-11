data('cancer',package='survival')
raw <- colon
stopifnot(nrow(raw)==1858L, length(unique(raw$id))==929L,
          !anyDuplicated(raw[c('id','etype')]),all(raw$status %in% 0:1),all(raw$time>0))
write.csv(raw,'data/colon_raw.csv',row.names=FALSE)
os <- raw[raw$etype==2,]
rec <- raw[raw$etype==1,]
rec <- rec[match(os$id,rec$id),]
stopifnot(identical(os$id,rec$id))
baseline <- c('rx','age','sex','nodes','obstruct','perfor','adhere','differ','extent','surg','node4')
for(v in baseline) stopifnot(isTRUE(all.equal(os[[v]],rec[[v]])))
# First observed recurrence or death; censored at the shorter observation window.
# A later event beyond either record's censoring window cannot establish DFS.
end_time <- pmin(rec$time,os$time)
end_event <- as.integer((rec$status==1 & rec$time==end_time) | (os$status==1 & os$time==end_time))
dfs <- os
dfs$time <- end_time; dfs$status <- end_event
os$rx <- factor(os$rx,levels=c('Obs','Lev','Lev+5FU'))
os$sex <- factor(os$sex,levels=0:1,labels=c('Female','Male'))
os$differ <- factor(os$differ,levels=1:3,labels=c('Well','Moderate','Poor'))
os$extent <- factor(os$extent,levels=1:4,labels=c('Submucosa','Muscle','Serosa','Contiguous'))
for(v in c('obstruct','perfor','adhere','surg')) os[[v]] <- factor(os[[v]],levels=0:1)
os$age10 <- os$age/10
os$lognodes <- log1p(os$nodes)
vars <- all.vars(model_formula)
cc <- os[complete.cases(os[,vars]),]
cc <- droplevels(cc)
missingness <- data.frame(variable=baseline, missing=vapply(os[baseline],function(x)sum(is.na(x)),integer(1)))
tab(missingness,'missingness')
disagree <- with(os,!is.na(nodes) & !is.na(node4) & (nodes>4)!=as.logical(node4))
tab(os[disagree,c('id','nodes','node4')],'node_discrepancies')
tab(data.frame(endpoint=c('Overall survival','Reconstructed recurrence-or-death'),patients=c(nrow(os),nrow(dfs)),events=c(sum(os$status),sum(dfs$status)),censored=c(sum(os$status==0),sum(dfs$status==0))),'endpoints')
tab(data.frame(total=nrow(os),complete_cases=nrow(cc),excluded=nrow(os)-nrow(cc),node_disagreements=sum(disagree)),'cohort_flow')
write.csv(os,'data/overall_survival.csv',row.names=FALSE)
write.csv(dfs,'data/recurrence_or_death.csv',row.names=FALSE)
saveRDS(list(os=os,dfs=dfs,cc=cc),'data/analysis_data.rds')
