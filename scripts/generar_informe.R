source('scripts/instalar_dependencias.R')
rmarkdown::render('report/informe_maes.Rmd',output_file='informe_maes.html',
                  output_dir=getwd(), knit_root_dir=getwd(), quiet=TRUE)
message('Informe creado: informe_maes.html')
