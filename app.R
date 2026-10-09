# MAEs | Dashboard de capacidad - datos historicos oficiales + hipotesis de simulacion
# Ejecutar en RStudio: shiny::runApp()
packages <- c('shiny', 'bslib', 'plotly', 'ggplot2', 'DT', 'scales', 'bsicons')
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop(paste('Instala primero:', paste(missing, collapse = ', '),
                          '\nEjecuta source("scripts/instalar_dependencias.R")'))

library(shiny)
library(bslib)
library(plotly)
library(ggplot2)
library(DT)
source('R/calculos.R', encoding = 'UTF-8')
h <- read_historico()
src <- 'https://www.uma.es/facultad-de-ciencias-economicas-y-empresariales/navegador_de_ficheros/Ciencias_Economicas_y_Empresariales/descargar/Calidad/MAEs/AutoinformeSeguim_MAES_25-26.pdf'
legal <- 'https://www.juntadeandalucia.es/boja/2026/84/46'
navy <- '#12233F'; blue <- '#1E4B79'; teal <- '#008D91'; gold <- '#D39D4F'

ui <- page_navbar(
  title = div('MAEs ', span(' | Análisis de capacidad', class='brand-light')),
  theme = bs_theme(version=5, bg='#F4F7FA', fg=navy, primary=blue, secondary=teal,
                   base_font=font_google('Inter')),
  header = tagList(tags$head(tags$link(rel='stylesheet', type='text/css', href='styles.css')),
                   div(class='top-note', 'PROPUESTA EXPLORATORIA  •  NO ES UN INFORME OFICIAL DE VACANTES  •  2024/25 PROVISIONAL')),
  nav_panel('01 · Resumen',
    div(class='intro-block',
        div(class='eyebrow','DECISIÓN ACADÉMICA · 2026/27'),
        h2('Evaluar capacidad adicional, sin alterar la prelación'),
        p('Cinco cursos oficiales permiten observar demanda histórica. La ocupación y la lista de espera actual requieren verificación por la UMA/DUA.')),
    layout_columns(col_widths=c(3,3,3,3),
      value_box(title='Oferta histórica por año', value='30', showcase=bsicons::bs_icon('people'), theme='primary'),
      value_box(title='Solicitudes 1.ª opción · 2024/25', value='107', showcase=bsicons::bs_icon('graph-up'), theme='info'),
      value_box(title='Matrícula final · 2024/25', value='34', showcase=bsicons::bs_icon('mortarboard'), theme='success'),
      value_box(title='Demanda / oferta · 2024/25', value='3,57×', showcase=bsicons::bs_icon('bar-chart'), theme='warning')),
    layout_columns(col_widths=c(7,5),
      card(card_header('Evolución de solicitudes en primera opción'), plotlyOutput('demanda_plot', height='335px')),
      card(card_header('Capacidad y matrícula final'), plotlyOutput('ocupacion_plot', height='335px'))),
    card(class='notice-card',card_header('Lectura para el comité'),
         tags$ul(tags$li('Demanda elevada no equivale a plazas vacantes en 2026/27.'),
                 tags$li('El antecedente de 34 matrículas frente a 30 plazas es un indicador histórico, no una autorización nueva.'),
                 tags$li('Cualquier ampliación debe respetar las listas y las resoluciones del procedimiento DUA.')))),
  nav_panel('02 · Simulador',
    div(class='intro-block',div(class='eyebrow','SIMULACIÓN DE ESCENARIOS · HIPÓTESIS'),
        h2('¿Cuándo podrían quedar plazas tras la lista ordinaria?'),
        p('Todos los controles inferiores son supuestos inventados por el usuario. No son datos actuales de la UMA.')),
    layout_sidebar(
      sidebar=sidebar(width=315,
        div(class='side-heading','PARAMETRIZACIÓN'),
        sliderInput('adicionales','Plazas adicionales hipotéticas', min=0,max=6,value=2,step=1),
        sliderInput('matriculados','Matrículas actuales hipotéticas',min=20,max=36,value=30,step=1),
        sliderInput('espera','Personas en lista ordinaria hipotética',min=0,max=40,value=10,step=1),
        sliderInput('aceptacion','Aceptación hipotética en lista',min=0,max=100,value=80,step=5,post='%'),
        helpText('El escenario no es una estimación de admisión individual.'),
        actionButton('reset','Reiniciar supuestos',class='btn-outline-secondary')),
      div(
        layout_columns(col_widths=c(4,4,4),
          value_box('Capacidad simulada',textOutput('k_cap'), theme='primary'),
          value_box('Personas que aceptarían',textOutput('k_aceptan'),theme='info'),
          value_box('Remanente teórico',textOutput('k_rem'),theme='warning')),
        layout_columns(col_widths=c(7,5),
          card(card_header('Sensibilidad: ampliación de 0 a 6 plazas'),plotlyOutput('sim_plot',height='340px')),
          card(card_header('Desglose del escenario'),tableOutput('detalle'),div(class='micro','El remanente está sujeto a reglas de adjudicación y no implica asignación a ningún solicitante.'))),
        card(card_header('Matriz de escenarios (no probabilidades)'),DTOutput('tabla_escenarios'))))),
  nav_panel('03 · Evidencia y riesgos',
    div(class='intro-block',div(class='eyebrow','EVIDENCIA Y CONTROL'),h2('Lo que sabemos y lo que debemos verificar')),
    layout_columns(col_widths=c(6,6),
      card(card_header('Evidencia pública · verificada'),
           tags$ul(tags$li('Oferta MAEs: 30 plazas anuales en los cinco cursos estudiados.'),
                   tags$li('Matrícula final: 27, 31, 29, 30 y 34.'),
                   tags$li('Solicitudes en primera opción: 64, 65, 62, 90 y 107.'),
                   tags$li('El dato 2024/25 consta como provisional.'))),
      card(card_header('Variables sin confirmar · 2026/27'),
           tags$ul(tags$li('Matrículas efectivas y pendientes de formalizar.'),
                   tags$li('Personas activas en la lista de espera ordinaria.'),
                   tags$li('Viabilidad docente y administrativa de una ampliación.'),
                   tags$li('Criterio concreto de la Comisión DUA sobre solicitudes condicionadas.')))),
    card(card_header('Preguntas operativas para valorar la capacidad'),
       tags$ol(tags$li('¿Hay suficientes recursos docentes y espacios disponibles para una ampliación acotada?'),
               tags$li('¿Cuántas plazas adicionales, si procede, pueden autorizarse sin deteriorar indicadores de calidad?'),
               tags$li('¿Cómo impactaría la ampliación en la lista ordinaria y en la expectativa de agotamiento?'),
               tags$li('¿Quién valida el número de matriculados y la lista en la última adjudicación?')))),
  nav_panel('04 · Datos y fuentes',
    div(class='intro-block',div(class='eyebrow','REPRODUCIBILIDAD'),h2('Trazabilidad antes que persuasión vacía')),
    card(card_header('Serie histórica del autoinforme UMA'),DTOutput('data_table')),
    card(card_header('Documentación y criterios'),
      p(tags$a(href=src,target='_blank','Autoinforme de Seguimiento MAEs 2025/26, pág. 17 (tabla IN01, IN02, IN03)')),
      p(tags$a(href=legal,target='_blank','Resolución DUA 2026/27, BOJA n.º 84, artículo 14')),
      p('Fuentes locales: data/historico_uma.csv y R/calculos.R. Datos provisionales identificados. No se han utilizado datos personales ni registros de candidaturas.'),
      downloadButton('descargar_datos', 'Descargar CSV oficial transcrito'))),
  footer = div(class='footer-note','MAEs · Nota de trabajo no institucional | Guido Armas · Octubre 2026 | UMA/DUA son la autoridad competente')
)

server <- function(input, output, session) {
  observeEvent(input$reset,{
    updateSliderInput(session,'adicionales',value=2)
    updateSliderInput(session,'matriculados',value=30)
    updateSliderInput(session,'espera',value=10)
    updateSliderInput(session,'aceptacion',value=80)
  })
  sim <- reactive(simular_capacidad(input$adicionales,input$matriculados,
                                    input$espera,input$aceptacion/100))
  serie <- reactive(escenarios_tabla(input$matriculados,input$espera,input$aceptacion/100))
  output$demanda_plot <- renderPlotly({
    p <- ggplot(h, aes(x=curso,y=solicitudes_primera_opcion,group=1,
                         text=paste0(curso,': ',solicitudes_primera_opcion,' solicitudes (1.ª opción)'))) +
      geom_area(fill=teal,alpha=0.13)+geom_line(color=blue,linewidth=1.2)+
      geom_point(size=3.6,color=teal)+geom_text(aes(label=solicitudes_primera_opcion),vjust=-0.9,color=navy,size=4)+
      ylim(0,125)+labs(x=NULL,y='Solicitudes · primera opción')+theme_minimal(base_size=12)+
      theme(panel.grid.minor=element_blank())
    ggplotly(p, tooltip='text') |> layout(margin=list(l=40,r=30,t=10,b=35))
  })
  output$ocupacion_plot <- renderPlotly({
    plot_ly(h, x=~curso) |>
      add_bars(y=~plazas,name='Oferta',marker=list(color='#A2B4C6'),
               hovertemplate='%{x}: %{y} plazas<extra></extra>') |>
      add_bars(y=~matricula_final,name='Matrícula final',marker=list(color=teal),
               hovertemplate='%{x}: %{y} matriculados<extra></extra>') |>
      layout(barmode='group',margin=list(l=30,r=10,t=10,b=35),
             legend=list(orientation='h',y=1.18),xaxis=list(title=''),yaxis=list(title='Personas'))
  })
  output$k_cap <- renderText(sim()$capacidad_hipotetica)
  output$k_aceptan <- renderText(sim()$aceptaciones_hipoteticas)
  output$k_rem <- renderText(sim()$remanente_teorico_tras_lista)
  output$sim_plot <- renderPlotly({
    s <- serie()
    plot_ly(s, x=~plazas_adicionales,y=~remanente_teorico_tras_lista,type='bar',
            marker=list(color=ifelse(s$plazas_adicionales==input$adicionales,gold,blue)),
            hovertemplate='+%{x} plazas: %{y} remanentes teóricos<extra></extra>') |>
      layout(margin=list(l=40,r=15,t=12,b=35),xaxis=list(title='Plazas adicionales (hipótesis)',dtick=1),
             yaxis=list(title='Remanente teórico',rangemode='tozero'))
  })
  output$detalle <- renderTable({
    s <- sim()
    data.frame(Indicador=c('Oferta base','Ampliación hipotética','Matrícula supuesta','Lista ordinaria supuesta',
                           'Aceptación supuesta','Plazas sin ocupar antes de espera',
                           'Remanente tras espera'),
               Valor=c(s$oferta_base,s$plazas_adicionales,s$matriculados_hipoteticos,
                       s$espera_ordinaria_hipotetica,paste0(round(100*s$tasa_aceptacion_hipotetica),'%'),
                       s$capacidad_no_ocupada,s$remanente_teorico_tras_lista))
  },striped=TRUE,hover=TRUE,spacing='s',bordered=FALSE)
  output$tabla_escenarios <- renderDT({
    d <- serie()[,c('plazas_adicionales','capacidad_hipotetica','aceptaciones_hipoteticas','remanente_teorico_tras_lista')]
    names(d)<-c('Ampliación','Capacidad total','Aceptaciones ordinarias hipotéticas','Remanente teórico')
    datatable(d, rownames=FALSE,options=list(pageLength=7,dom='t',ordering=TRUE)) |>
      formatStyle('Remanente teórico',backgroundColor=styleInterval(0,c('#FFF4E3','#DDF3EE')))
  })
  output$data_table <- renderDT({
    d <- h[,c('curso','plazas','matricula_final','solicitudes_primera_opcion','ratio_demanda','provisional')]
    names(d) <- c('Curso','Plazas','Matrícula final','Solicitudes 1.ª opción','Ratio demanda','Provisional')
    datatable(d,rownames=FALSE,options=list(dom='t',ordering=FALSE)) |>
      formatRound('Ratio demanda',digits=2)
  })
  output$descargar_datos <- downloadHandler(
    filename=function() 'historico_maes_uma.csv',
    content=function(file) file.copy('data/historico_uma.csv',file))
}
shinyApp(ui,server)
