stopifnot(nrow(os)==929L, !anyDuplicated(os$id), nrow(dfs)==nrow(os),
          all(dfs$time<=os$time),all(dfs$time<=rec$time),
          all(dfs$status %in% 0:1), all(complete.cases(cc[,vars])),
          cox$n==nrow(cc),all(is.finite(coef(cox))),
          all(vapply(aft,function(m)nrow(m$y)==nrow(cc),logical(1))),
          all(is.finite(comparison$AIC)),all(curves$survival>=0 & curves$survival<=1))
# Synthetic endpoint tests: recurrence first, death first, censoring first, tie.
t_r<-c(100,300,100,200);s_r<-c(1,0,0,1)
t_d<-c(400,200,300,200);s_d<-c(0,1,1,1)
t<-pmin(t_r,t_d);e<-as.integer((s_r==1&t_r==t)|(s_d==1&t_d==t))
stopifnot(identical(t,c(100,200,100,200)),identical(e,c(1L,1L,0L,1L)))
expected <- c('km_overall_survival','km_recurrence_or_death','schoenfeld','cox_forest','martingale','influence','parametric_survival','aft_cox_snell')
stopifnot(all(file.exists(file.path('results/figures',paste0(expected,'.png')))))
writeLines('PASS: patient structure, endpoint reconstruction, model cohorts, numerical outputs, figures and synthetic endpoint cases.','results/validation.txt')
