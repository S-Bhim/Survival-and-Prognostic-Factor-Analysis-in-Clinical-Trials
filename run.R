#!/usr/bin/env Rscript
# Execute from any directory; no packages are installed automatically.
args <- commandArgs(trailingOnly = FALSE)
entry <- sub('^--file=', '', args[grepl('^--file=', args)])
if (length(entry)) setwd(dirname(normalizePath(entry[1])))
source('R/00_config.R')
for (script in sprintf('R/%s.R', c('01_data','02_descriptive','03_km','04_cox','05_parametric','06_report'))) source(script)
source('tests/validate.R')
writeLines(capture.output(sessionInfo()), 'results/sessionInfo.txt')
saveRDS(list(config=config, km=km, cox=cox, ph=ph, aft=aft), 'results/models.rds')
files <- list.files('.', recursive=TRUE, full.names=TRUE)
files <- files[!grepl('manifest.csv$|^./library/',files)]
write.csv(data.frame(file=files, md5=unname(tools::md5sum(files))), 'results/manifest.csv', row.names=FALSE)
message('Analysis and validation complete. See results/report.html and results/.')
