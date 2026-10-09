source('R/calculos.R')
h <- read_historico()
stopifnot(identical(as.integer(h$plazas),rep(30L,5)),
          identical(as.integer(h$matricula_final),c(27L,31L,29L,30L,34L)),
          identical(as.integer(h$solicitudes_primera_opcion),c(64L,65L,62L,90L,107L)),
          abs(tail(h$ratio_demanda,1)-107/30)<1e-10,
          simular_capacidad(2,30,10,0.8)$remanente_teorico_tras_lista == 0,
          simular_capacidad(4,27,2,1)$remanente_teorico_tras_lista == 5,
          simular_capacidad(0,30,0,1)$remanente_teorico_tras_lista == 0)
message('OK: 5 filas oficiales, ratios y reglas de simulación validadas.')
