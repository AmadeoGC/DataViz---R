###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
### TALLER DE INTRODUCCIÓN A R                                             -----      
### MANIPULACIÓN Y VISUALIZACIÓN DE DATOS CON R Y TIDYVERSE                -----
### 
### Autor: Amadeo Guzmán
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#Hoy vamos a aprender a manipular bases datos con las librerias que forman parte de Tidyverse
#Aprenderemos a usar 6 funciones (existen muchas funciones que no vamos a ver hoy, pero estas son algunas de las más importantes)

#   - select()      -> Seleccionar un subconjunto de variables de nuestra base de datos
#   - filter()      -> Seleccionar las filas que cumplen con una o más condiciones ( ==, >=, <=, <, >, !=)
#   - mutate()      -> Crear nuevas variables o modificar las existentes
#   - group_by()    -> Agrupar datos en base a una(s) característica(s)
#   - summarize()   -> Aplicar cálculos a diferentes subconjuntos de datos
#   - arrange()     -> Ordenar resultados de formas ascendente o descendente

#Tambien aprenderemos a vincular estas funciones y los gráficos de ggplot mediante el uso del operador pipe %>%



#
##
###  MANIPULACIÓN Y TRANSFORMACIÓN DE DATOS ----------------------------------------------------
##
#


#librerias
library(tidyverse)
library(readxl) #cargar datos desde Excel (.xlsx)
library(janitor) #"limpiar" encabezados y +++
library(skimr)
library(ggthemes)


#Datos
(bd_pinguinos <- read_excel("bd_pinguinos_excel_dia2.xlsx",
                    sheet = "bd_pinguinos", #pestaña de excel que vamos a usar
                    skip = 3)) #no vamos a considerar las 3 primeras filas

names(bd_pinguinos)

#limpiamos los encabezados
(datos <- clean_names(bd_pinguinos))

names(datos)


#Explorar base de datos
dim(datos)
glimpse(datos)




#---------------+
### select() ----
#---------------+
#Seleccionar un subconjunto de variables de nuestra base de datos
?select

#Ejemplo1: Seleccionamos variables especificando sus nombres
select(datos, "species", "island", "body_mass_g")

#Ejemplo2: seleccionamos en base a posición
select(datos, 1,2,3)   #Seleccionamos las 3 primeras variables
select(datos, 1,5:8)   #Seleccionamos la variable 1 y despues de la 3 a la 6

#Ejemplo3: eliminamos 1 o más variables
select(datos, -7, -8)
select(datos, -c(7, 8))


#ejemplo4: seleccionamos en base a alguna caracteristica en el nombre de la variable
select(datos, contains("mm"))    #seleccionamos variables que contengan la palabra "mm"
select(datos, contains("cul"))    #seleccionamos variables que contengan la palabra "mm"

select(datos, starts_with("c"))  #seleccionamos variables que comienzan con "c"
select(datos, 1, ends_with("d")) #seleccionamos la primera variable de la base de datos y las variables que terminan con "d"


#ejemplo5: seleccionar en base al tipo de columna
select_if(datos, is.numeric)
select_if(datos, is.character)



#Ejemplo6: cambiamos el orden y eliminamos algunas variables. 
#Además, vamos a guardar este proceso en el objeto datos_2... será nuestra nueva base de datos
(datos_2 <- select(datos, "species", "sex",  everything(), -8))

#comparemos....
head(datos, 2)
head(datos_2, 2)



#---------------+
### filter() -----
#---------------+
#Seleccionar las filas que cumplen con alguna condición( ==, >=, <=, <, >, !=)
?filter

#algunos ejemplos de como podemos aplicar filtros en la base de datos
filter(datos_2, species == "Gentoo")
filter(datos_2, species != "Gentoo") #para eliminar un elemento ocupamos !=
filter(datos_2, body_mass_g >= 6000)


### filtrar en base a multiples variables o condiciones
#&
filter(datos_2, species == "Chinstrap", sex == "MALE")  #Utilizar la coma "," entre cada variable es equivalente a la expresión "&"

#o
filter(datos_2, species == "Chinstrap" | sex == "MALE") #o 


#Si queremos seleccionar diferentes elementos de una variable debemos ocupar el operador %in%
#en este caso aplicaremos el filtro en nuestra base de datos "datos_2"
#y lo guardaremos en otro objeto

(datos_con_filtro <- filter(datos_2, island %in% c("Biscoe", "Dream"))) 


############################# EJERCICIO ##################################################+
# de la base de datos "datos_con_filtro" selecciona solo hembras de la especie Chinstrap
# con un valor de flipper_length_mm mayor o igual a 200



##########################################################################################+



#---------------+
### mutate() -----
#---------------+
#crear nuevas variables o sobreescribir las existentes... por defecto siempre se agregan al final
?mutate

#crear una nueva variable numérica numérica "relacion_culmen"
#guardamos el resultado en un nuevo objeto
(datos_con_filtro_mutate <- mutate(datos_con_filtro, 
                                   relacion_culmen = culmen_length_mm/culmen_depth_mm))

#crear una nueva variable categórica
(datos_con_filtro_mutate_2 <- mutate(datos_con_filtro_mutate, 
                                     species_gentoo = if_else(species == "Gentoo", "Sí", "No"))
)

View(datos_con_filtro_mutate_2)


#IMPORTANTE: En este proceso de seleccionar (select), filtrar (filter) y crear nuevas variables (mutate)
#hemos generado una serie de nuevas bases de datos que vamos guardando en diferentes objetos... 
#lo cual en un flujo de trabajo NO es muy práctico.... para solucionar este problema existe un operador
#el cual combina las salidas de una función con las entradas de una siguiente función -> pipe %>%



#-----------------------------+
# Uso del operador pipe  %>% -----
#-----------------------------+
# %>% este operador se podría traducir como "luego"... vincula lo que se va haciendo en cada función 

datos %>%  
  filter(species=="Chinstrap")

datos %>%  
  filter(species=="Chinstrap") %>% 
  select("species", "sex", everything(), -8)



#replicaremos todos los procesos que hicimos anteriormente (select, filter y mutate) 
#en un solo flujo de trabajo con %>%..... y lo guardaremos en el objeto "datos_ok"

(datos_ok <- datos %>% 
    select("species", "sex",  everything(), -8) %>% 
    filter(island %in% c("Biscoe", "Dream")) %>% 
    mutate(relacion_culmen = round(culmen_length_mm/culmen_depth_mm, 1), #round(,1) -> redondear con 1 decimal
           species_gentoo = if_else(species == "Gentoo", "Sí", "No"))
)


View(datos_ok)



#-----------------------------+
### group_by() + summarize() -----
#-----------------------------+
#las funciones group_by() y summarize() nos permiten aplicar cálculos a diferentes subconjuntos de datos, 
#generando un nuevo data frame con estos resultados
?group_by
?summarize


#Ejemplo1: determinar el promedio de la variable flipper_length_mm 
#para la especie Gentoo en machos y hembras
datos_ok %>%  
  filter(species=="Gentoo") %>% 
  group_by(sex) %>% 
  summarize(Promedio_flipper_length = mean(flipper_length_mm, na.rm=TRUE)) 


datos_ok %>%  
  filter(species=="Gentoo", !is.na(sex)) %>% 
  group_by(sex) %>% 
  summarize(Promedio_flipper_length = mean(flipper_length_mm, na.rm=TRUE),
            mediana_flipper_length = median(flipper_length_mm, na.rm=TRUE),
            sd_flipper_length = sd(flipper_length_mm, na.rm = TRUE)) 



#################### Ejercicio #############################################################+
# Determinar el promedio de la variable body_mass_g de pingüinos machos por especie e isla



############################################################################################+


#determinar la mediana, percentil 25 y percentil 75 de body_mass_g por especie
#expresar resultados en kilos
datos_ok %>% 
  group_by(species) %>% 
  summarise(mediana= median(body_mass_g, na.rm = TRUE)/1000,
            p25 = quantile(body_mass_g, 0.25, na.rm=TRUE)/1000,
            p75 = quantile(body_mass_g, 0.75, na.rm=TRUE)/1000)



#Podemos aplicar diferentes funciones en varias columnas con accross()
#necesitamos tener instalada la libreria dplyr versión 1.0.2
datos_ok %>% 
  group_by(species) %>%
  summarise(across(c("culmen_length_mm", "flipper_length_mm"), median, na.rm = TRUE),
            n = n()) %>%
  filter(n >= 2)

datos_ok %>% 
  group_by(species) %>%
  summarise(across(contains("mm"), median, na.rm = TRUE),
            n = n()) %>%
  filter(n >= 2)


datos_ok %>% 
  group_by(species) %>%
  summarise(across(c("culmen_length_mm", "flipper_length_mm"),
                   list(media = mean, 
                        mediana = median, 
                        desv.estd = sd), 
                   na.rm = TRUE),
            n = n())



#De momento solo hemos visto como manipular nuestra base de datos para obtener un resumen de información
#pero podemos hacer mucho más....... 1 ejemplo (bonus track)

# ....modelo de regresión.
datos_ok %>% 
  filter(species == "Gentoo") %>% 
  summarise(
    broom::tidy(lm(body_mass_g ~ flipper_length_mm))
  )



#repetimos el modelo de regresión lineal pero esta vez por sexo
datos_ok %>% 
  filter(!is.na(sex)) %>% 
  group_by(sex) %>%
  summarise(
    broom::tidy(lm(body_mass_g ~ flipper_length_mm))
  )


#----------------+
### arrange()  -----
#----------------+
#Ordenar resultados de formas ascendente o descendente (por defecto es en forma ascendente)
?arrange

#obtener valor promedio de la variable "relacion_culmen" por especie y ordenarlo en forma ascendente
datos_ok %>%
  group_by(species) %>%              #agrupamos por especie
  summarize(media_relacion_culmen = mean(relacion_culmen, na.rm = TRUE))  %>%  
  arrange(media_relacion_culmen) #ordenamos los resultados de foma ascendente (IMC)


#descendente + ggplot
datos_ok %>%
  filter(!is.na(sex)) %>% 
  group_by(species, sex) %>%              
  summarize(media_relacion_culmen = mean(relacion_culmen, na.rm = TRUE))  %>%  
  arrange(desc(media_relacion_culmen)) %>%  
   #gráfico
  ggplot(aes(fct_reorder(species, media_relacion_culmen), media_relacion_culmen)) +
  geom_col(aes(fill=if_else(media_relacion_culmen > mean(media_relacion_culmen), "A", "B"))) +
  scale_fill_manual(values = c("firebrick", "grey50")) +
  coord_flip() +
  facet_wrap(~sex) +
  theme_light() +
  theme(axis.line.x = element_line(),
        axis.ticks = element_line(),
        legend.position = "none",
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        strip.background.x = element_rect(fill="grey40", color="grey40")) +
  geom_hline(aes(yintercept = mean(media_relacion_culmen)), lty=2, color="darkblue") +
  geom_text(aes(label=round(media_relacion_culmen,1)), size=3, hjust=1.5, vjust=0.25, color="white") +
  labs(y="\nRelación entre largo y ancho del culmen",
       x="Especies\n")



########################## FIN ####################################################################

#
# BT: pivot_longer() + ggplot2
#

datos %>% 
  pivot_longer(culmen_length_mm:body_mass_g, names_to = "variables", values_to = "valor", 
               values_drop_na = TRUE) %>% 
  ggplot(aes(species, valor, fill=species)) +
  geom_boxplot(alpha=.6, outlier.color = NA) +
  geom_jitter(width = .2, alpha=0.5, shape=21, size=3, color="white") +
  scale_fill_tableau() +
  facet_wrap(~variables, scales = "free") +
  coord_flip() +
  labs(x=NULL,
       y="\nescala ajustada al valor de cada variable") +
  theme_light()+
  theme(legend.position = "none",
        strip.background.x = element_rect(fill="grey50", color = "grey50"),
        strip.text.x = element_text(size=11))



