###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
### TALLER DE INTRODUCCIÓN A R                                              -----      
### VISUALIZACIÓN Y TRANSFORMACIÓN DE DATOS CON R Y TIDYVERSE (PARTE 1)     -----
### 
### Autor: Amadeo Guzmán
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#
##
### 1.- Algunas definiciones y consideraciones previas ----
##
#

# Cada línea de texto que se escribe después del símbolo # R no lo considera como un elemento a ejecutar --> Sirve para hacer comentarios, poner títulos de sección, links de pag. web, etc.
# En general, NO se recomienda usar acentos y ocupar la letra ñ
# R es un lenguaje de programación orientado a OBJETOS --> todo lo podemos guardar en un objeto y ocuparlo cuando sea necesario
# Un paquete es un conjunto de funciones y datos específicos para cada tema.
# Una función es una secuencia de códigos guardada como un OBJETO de R que toma variables de entrada, realiza un proceso y nos devuelve un resultado
# Un data frame es una colección rectangular de variables (columnas) y observaciones (filas) -> Cada columna DEBE ser una variable y cada fila DEBE ser una observación
# IMPORTANTE --> Para ejecutar un código en R puedes: (1) poner el cursor sobre el código y apretar Ctrl + Enter; (2) seleccionar el código y hacer clik en "Run"



#
##
### 2.- Cargar librerías al entorno de trabajo -----
##
#

### instalar paquetes en el pc --> Solo se hace 1 vez 
#install.packages(c("tidyverse", "lubridate", "janitor", "ggthemes", "scales"))

#Cada vez que abrimos una nueva sesión de R debemos cargar las librerías que vamos a ocupar (No instalar, solo cargar)
library(tidyverse)
library(ggthemes)


#install.packages("skimr")
if(!require(skimr))       install.packages("skimr")




#
##
### 3.- Datos ----- 
##
#

# Ver nuestro directorio de trabajo
getwd()


# Cargar la base de datos (.csv) desde nuestra carpeta de trabajo y lo guardamos en el objeto "datos"
datos <- read.csv2("bd_pinguinos.csv", header = TRUE)



# con la función head() vemos por defecto las primeras 6 líneas de cada base de datos
head(datos)
tail(datos)

head(datos, 1) #tambien podemos elegir el número de filas que queremos ver


View(datos)    #para ver toda la base de datos


#Seleccionar columnas (vectores) específicos de una base de datos -> Operador $
datos$species

levels(datos$species)



#
##
### 4.- Explorar la base de datos -----
##
#


dim(datos)     #cantidad de filas y columnas del dataframe
names(datos)   #nombres de las variables
glimpse(datos) #resumen de las características de cada variable

#Importante -> tipos de columnas [texto: <chr> | var. cuantitativas: <dbl> <int>]


#resumen general de todo el data set
summary(datos)

skim(datos)


#Tambien podemos generar tablas de contingencia que nos permite conocer la distribución de número datos entre categorías
table(datos$species, datos$island)
prop.table(table(datos$species, datos$island))*100



########################## -- EJERCICIO -- #############################+
# como es la distribución de datos según la especie de pingüino y sexo
# obtener registros en n° datos y proporción


########################################################################+



#
##
### 5.- Visualizar datos con R-base -----
##
#


### hist() ----
?hist

hist(datos$flipper_length_mm)

hist(datos$body_mass_g)
hist(datos$body_mass_g/1000)


### boxplot() ----
?boxplot

# distribución simple
boxplot(datos$flipper_length_mm)

# distribución x especies
boxplot(datos$flipper_length_mm ~ datos$species)
boxplot(datos$flipper_length_mm ~ datos$species, notch = TRUE, col = c("orange","red", "green"))
boxplot(datos$flipper_length_mm ~ datos$species, plot=FALSE)$out



### plot() ----
?plot

#var. cuantitativas
plot(x = datos$flipper_length_mm, y = datos$body_mass_g)

plot(datos$flipper_length_mm, datos$body_mass_g,
     xlab= "Flipper Length (mm)", ylab = "Body Mass (gr)", main = "Plot 1", col = "blue")


plot(density(datos$flipper_length_mm, na.rm = TRUE))


#var. cualitativas (categorías / factor)
plot(datos$species)
plot(datos$island)

plot(datos$species, datos$island)




#
##
### 6.- Librerias para EDA (exploratory Data Analysis) -----
##
#

library(funModeling)

# DescripciÃ³n variables categÃ³ricas
?freq
freq(datos$species)
freq(datos$island)
freq(datos)

# DescripciÃ³n numÃ©rica
?profiling_num
profiling_num(datos$flipper_length_mm) #range_80 corresponde a los valores entre p10 y p90
profiling_num(datos)


# Grafico
plot_num(datos)




library(inspectdf)
#Coeficientes de correlación entre variables
inspect_cor(datos)  #otros metodos disponibles "Kendall" y "spearman"
inspect_cor(datos, with_col = "flipper_length_mm") #asignar una variable de referencia

show_plot(inspect_cor(datos))


show_plot(inspect_cor(datos, with_col = "flipper_length_mm"))




