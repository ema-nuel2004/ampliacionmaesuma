# MAEs · Observatorio de demanda y simulador de capacidad

**Proyecto independiente | RStudio + Shiny + R Markdown | Curso 2026/27**

> **Advertencia importante:** no es una herramienta oficial de la UMA ni del DUA. Los datos históricos son públicos y verificables. **No conocemos el número de matriculados o de aspirantes en lista de espera de 2026/27.** Las cifras del simulador son únicamente escenarios hipotéticos, NO probabilidades de admisión.

## Arranque rápido (RStudio)

1. Descarga y descomprime el ZIP, o clona este repositorio.
2. Abre `MAEs_Capacidad.Rproj` en RStudio.
3. Ejecuta `source('scripts/instalar_dependencias.R')` (requiere conexión a internet la primera vez).
4. Ejecuta `shiny::runApp()` para abrir la aplicación.
5. Para crear el informe HTML: `source('scripts/generar_informe.R')`.

## Qué contiene

| Ubicación | Función |
|---|---|
| `app.R` | Dashboard Shiny interactivo de cuatro pestañas |
| `R/calculos.R` | Modelo de escenarios documentado y funciones de carga |
| `data/historico_uma.csv` | Serie oficial 2020/21–2024/25 (cinco filas) |
| `report/informe_maes.Rmd` | Informe HTML reproducible, con parámetros |
| `scripts/validar_datos.R` | Pruebas aritméticas reproducibles (sin dependencias externas) |
| `.github/workflows/check.yml` | Verificación automática en GitHub Actions |
| `www/styles.css` | Estilo visual corporativo |
| `data/diccionario.md` | Definiciones, límites y fuentes |

## Publicación en GitHub

Crea un repositorio vacío y **sube todo el contenido de esta carpeta a la raíz** (incluidas `.github/` y los archivos ocultos). Puedes hacerlo en github.com con **Add file → Upload files**. También puedes usar Git:

```bash
git init
git add .
git commit -m "Initial MAEs demand and capacity analytics"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/maes-capacidad-analitica.git
git push -u origin main
```

El sitio de GitHub almacena código, **no ejecuta Shiny automáticamente**. Para ofrecer una URL interactiva, publícalo en [shinyapps.io](https://www.shinyapps.io/) o en un servidor Shiny y vincula esa URL en el repositorio.

## Lógica de simulación

```text
capacidad = 30 + ampliación hipotética
aceptaciones_espera = techo(espera ordinaria hipotética × tasa de aceptación hipotética)
plazas_sin_ocupar = max(0, capacidad − matrícula hipotética)
remanente_teórico = max(0, plazas_sin_ocupar − aceptaciones_espera)
```

**Interpretación:** remanente teórico NO equivale a admisión, ni indica que se haya agotado de hecho la lista. La aceptación agregada es una hipótesis de sensibilidad, no una probabilidad individual ni una previsión. Para un análisis real se necesitan datos oficiales de lista, oferta y matrícula.

## Fuentes y cita

- Universidad de Málaga. *Autoinforme de seguimiento del Máster en Análisis Económico y Empresarial 2025/26*, tabla IN01–IN03, pág. 17. [PDF oficial](https://www.uma.es/facultad-de-ciencias-economicas-y-empresariales/navegador_de_ficheros/Ciencias_Economicas_y_Empresariales/descargar/Calidad/MAEs/AutoinformeSeguim_MAES_25-26.pdf).
- Junta de Andalucía. *Procedimiento de admisión de másteres 2026/27*, artículo 14. [BOJA oficial](https://www.juntadeandalucia.es/boja/2026/84/46).

**2024/25 es provisional.** La demanda de primera opción no es el tamaño de la lista de espera.

## Licencia

Código de ejemplo bajo licencia MIT; los documentos oficiales enlazados pertenecen a sus titulares y no se redistribuyen. Se han omitido pasaportes, emails privados y capturas personales.
