paquetes <- c('shiny','bslib','bsicons','plotly','ggplot2','DT','scales','rmarkdown','knitr')
instalar <- setdiff(paquetes, rownames(installed.packages()))
if (length(instalar)) install.packages(instalar, repos='https://cloud.r-project.org')
message('Dependencias instaladas. Ejecuta shiny::runApp().')
