###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
### MANIPULACI�N Y VISUALIZACI�N DE DATOS CON R Y TIDYVERSE                -----      
### Manipulaci�n de fechas con Lubridate                                   -----
### ggplot2 (parte 2)                                                      -----  
### 
### Autor: Amadeo Guzm�n
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#
#librerias ----
#

library(tidyverse)
library(readxl) #cargar datos desde Excel (.xlsx)
library(janitor) #"limpiar" encabezados y +++
library(ggthemes)
library(lubridate)


#
#Datos ----
#

(bd_pinguinos <- read_excel("bd_pinguinos_excel_dia2.xlsx",
                    sheet = "bd_pinguinos", #pesta�a de excel que vamos a usar
                    skip = 3)) #no vamos a considerar las 3 primeras filas

names(bd_pinguinos)

#limpiamos los encabezados
(datos <- clean_names(bd_pinguinos))

names(datos)

#exploramos la estructura de la base de datos y sus variables
glimpse(datos)

class(datos$fecha_muestreo)


#
#transformar la variable "fecha_muestreo" a formato fecha ----
#
datos %>% 
  mutate(fecha_muestreo_ok = dmy(fecha_muestreo)) 
  

"2020-2-23"
class("2020-2-23")

ymd("2020-2-23")
class(ymd("2020-2-23"))


#vamos a generar una nueva base de datos con datos en formato fecha
(datos_ok <- datos %>% 
  mutate(fecha_muestreo_ok = dmy(fecha_muestreo),
         .before=1) 
)


datos_ok %>% 
  group_by(fecha_muestreo_ok) %>% 
  summarise(culmen_l = median(culmen_length_mm)) %>% 
  #plot
  ggplot(aes(fecha_muestreo_ok, culmen_l)) +
  geom_line()


datos_ok %>% 
  group_by(fecha_muestreo_ok) %>% 
  summarise(culmen_l = median(culmen_length_mm)) %>% 
  #plot
  ggplot(aes(fecha_muestreo_ok, culmen_l)) +
  geom_line() +
  scale_x_date(date_labels = "%b-%Y")


datos_ok %>% 
  group_by(species,fecha_muestreo_ok) %>% 
  summarise(culmen_l = median(culmen_length_mm)) %>% 
  #plot
  ggplot(aes(fecha_muestreo_ok, culmen_l, color=species)) +
  geom_line(size=1) +
  geom_point(shape=21, fill="white", size=2) +
  scale_x_date(date_labels = "%b-%y", date_breaks = "1 month", expand = c(0,0)) +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 10)) +
  theme_minimal() +
  theme(axis.line.x = element_line(),
        axis.text.x = element_text(angle=90),
        legend.position = "none")


#No son los mejores gr�ficos......pueden mejorar y mucho, pero necesitamos crear nuevas variables


(datos_fechas <- datos_ok %>% 
    mutate(a�o = year(fecha_muestreo_ok),
           mes = month(fecha_muestreo_ok),
           mes_nombre = month(fecha_muestreo_ok, label = TRUE, abbr = FALSE),
           semana = week(fecha_muestreo_ok),
           dia_mes = day(fecha_muestreo_ok),
           dia_semana = wday(fecha_muestreo_ok),
           dia_semana_nombre = wday(fecha_muestreo_ok, label = TRUE, abbr = FALSE),
           .before=1) 
)


(lineas_1 <- datos_fechas %>% 
  group_by(species, sex, a�o, mes) %>% 
  summarise(culmen_l = median(culmen_length_mm)) %>% 
  filter(!is.na(a�o), !is.na(sex)) %>% 
  ggplot(aes(mes, culmen_l, color=species)) +
  geom_line(size=1) +
  geom_point(shape=21, fill="white", size=2) +
  scale_y_continuous(limits = c(20, 70), breaks = seq(0, 100, 10)) +
  scale_x_continuous(breaks = seq(1,12,1)) +
  scale_color_tableau()+
  theme_light() +
  theme(axis.line.x = element_line()) +
  facet_grid(sex~as.factor(a�o))
)

library(plotly)

ggplotly(lineas_1)


#### EJERCICIO ##################################################################+
#Haz un gr�fico (diferente al anterior) utilizando otros datos de formato fecha
#a�o, mes. semana, dia, dia de la semana, etc.


#################################################################################+


#
# Heatmap ----
#

(heatmap <- datos_fechas %>% 
  group_by(species, a�o, semana) %>% 
  summarise(culmen_l = median(culmen_length_mm)) %>% 
  filter(!is.na(a�o), !is.na(culmen_l)) %>% 
  #plot
  ggplot(aes(semana, species, fill=culmen_l)) +
  geom_tile(alpha=.9) +
  scale_x_continuous(breaks = seq(1,52,2), expand = c(0,0)) +
  scale_fill_viridis_c()+
  #scale_fill_viridis_b()+
  #scale_fill_viridis_b(direction = -1)+
  labs(y=NULL) +
  theme_light() +
  theme(panel.grid = element_blank(),
        strip.background.x = element_rect(color="grey40", fill="grey50"),
        strip.text.x = element_text(color="white", face="bold"),
        axis.line.x = element_line(),
        legend.position="bottom",
        legend.justification = "right",
        legend.key.width = unit(1,"cm"),
        axis.text.y = element_text(angle=90, hjust = 0.5, size=10, face="bold")) +
  facet_wrap(~as.factor(a�o))
)


#unir en una misma visualizaci�n 2 o + gr�ficos 
library(patchwork)

lineas_1 + heatmap

lineas_1 / heatmap +plot_layout(nrow = 2, heights = c(0.7, 0.3))




######### EJERCICIO ########################################################################+
#Con los elementos que hemos visto hoy genera 1, 2 o + gr�ficos, consolida todo en 1 trama
#y exporta el archivo en formato ".png"



###########################################################################################+



###################### FIN ############################
