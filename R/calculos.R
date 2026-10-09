# Analisis MAEs | Funciones de negocio auditables
# Datos reales 2026/27 sobre matriculas y espera NO disponibles publicamente.
read_historico <- function(path = 'data/historico_uma.csv') {
  x <- utils::read.csv(path, stringsAsFactors = FALSE, fileEncoding = 'UTF-8')
  stopifnot(nrow(x) == 5L, !anyNA(x[c('plazas', 'matricula_final', 'solicitudes_primera_opcion')]))
  x$ratio_demanda <- x$solicitudes_primera_opcion / x$plazas
  x$tasa_matricula_oferta <- x$matricula_final / x$plazas
  x
}

simular_capacidad <- function(adicionales = 2L, matriculados = 30L,
                             espera = 10L, aceptacion = 0.8,
                             oferta_base = 30L) {
  stopifnot(adicionales >= 0, matriculados >= 0, espera >= 0,
            aceptacion >= 0, aceptacion <= 1, oferta_base > 0)
  total <- as.integer(oferta_base + adicionales)
  aceptan <- as.integer(ceiling(espera * aceptacion))
  disponibles <- max(0L, total - as.integer(matriculados))
  despues <- max(0L, disponibles - aceptan)
  data.frame(
    oferta_base = as.integer(oferta_base),
    plazas_adicionales = as.integer(adicionales),
    capacidad_hipotetica = total,
    matriculados_hipoteticos = as.integer(matriculados),
    espera_ordinaria_hipotetica = as.integer(espera),
    tasa_aceptacion_hipotetica = aceptacion,
    aceptaciones_hipoteticas = aceptan,
    capacidad_no_ocupada = disponibles,
    remanente_teorico_tras_lista = despues
  )
}

# La cifra residual NO equivale a una plaza adjudicable al solicitante;
# no modela calendario, confirmaciones, cupos ni reglas de prelacion.

escenarios_tabla <- function(matriculados, espera, aceptacion,
                            incrementos = 0:6) {
  do.call(rbind, lapply(incrementos, function(n) {
    simular_capacidad(n, matriculados, espera, aceptacion)
  }))
}
