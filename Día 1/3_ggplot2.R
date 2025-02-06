###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
### TALLER DE INTRODUCCIÓN A R                                              -----      
### GGPLOT2 (básico)                                                        -----
### 
### Autor: Amadeo Guzmán
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#
##
### Visualizar datos con ggplot2 -----
##
#


# ggplot2 es un paquete que pertenece al universo Tidyverse y utiliza la gramática de los gráficos para construir sus visualizaciones
# funciona en base a capas de información


#
# 1.- Librerias -----
#
library(tidyverse)
library(readxl)


#
# 2.- Datos -----
#
(datos <- read_excel("bd_pinguinos_excel.xlsx"))

glimpse(datos)




#
##
### 3.- GGPLOT 2 -----
##
#

#
# _3.1 Elementos de Estética o aes() ----
#

ggplot()

ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g))

ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()


# Podemos modificar algunas características generales FIJAS: color y forma
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(color = "blue", shape=3) #fijamos un color determinado y una forma para cada dato



#Podemos agregar más elementos al gráfico, pero esta vez asociado a las VARIABLES de la base de datos
#Esto es necesario hacerlo dentro del parámetro aes()

# gráfico base
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point()

#color
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point()

#Reciclar código: copiar + pegar ;) y cambiar 1 elemento (color = sex)
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = sex)) +
  geom_point()



#color + forma
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species, shape = sex)) +
  geom_point()


#alternar estéticas visuales y características fijas
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(size=3)


#agregar transparencia a los puntos (para disminuir el efecto de la sobreposición)
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = species)) +
  geom_point(size=3, alpha = 0.5) #alpha toma valores entre 0 y 1


#NOTA: Una vez que mapeamos variables con propiedades estéticas, el paquete ggplot2 selecciona una escala razonable para usar con la estética elegida y construye una leyenda que explica la relación entre niveles y valores.



#################################### -- EJERCICIO -- ######################################################+
# Modificar los gráficos anteriores esta vez utilizando las variables "culmen_length_mm" y "culmen_depth_mm"
# y agregar una capa de color con una variable categórica que no sea la especie



#############################################################################################################+


#de momento hemos asignado el color solo a variables categóricas. Qué pasa si lo hacemos con una variable numérica?
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = culmen_length_mm)) +
  geom_point()



##########################################  EJERCICIO  ####################################################+
# ¿Qué pasa si asignamos el color a una variable cuantitativa, pero con una condición?? 
# ocupa la siguiente condición: color = culmen_length_mm >45




##########################################################################################################+

#al mismo ejemplo anterior le agregamos una nueva capa para mejorar la escala de color
ggplot(data = datos,
       mapping = aes(x = flipper_length_mm, y = body_mass_g, color = culmen_length_mm)) +
  geom_point(size=2) +
  scale_color_viridis_c() # existen una gran cantidad de escalas de color prediseñadas..... y también puedes hacer las tuyas



#IMPORTANTE: Hacer visualizaciones no es solo poner alguna variable en cada eje, algo de color y listo. Debemos explorar los datos e intentar encontrar las relaciones que puedan existir. Debemos abordar este problema desde diferentes perspectivas y evitar caer en posibles "sesgos" o malas interpretaciones.

#Ejemplo
#Existe algún tipo de relación entre las variables "culmen_length_mm" y "culmen_depth_mm"??
ggplot(data = datos,
       mapping = aes(x = culmen_length_mm, y = culmen_depth_mm)) +
  geom_point(size=2.5)

#Ajustamos una recta de regresión a estos datos 
ggplot(data = datos,
       mapping = aes(x = culmen_length_mm, y = culmen_depth_mm)) +
  geom_point(size=2.5) +
  geom_smooth(method = "lm")


#Esta relación es real?? Existen otras variables que puedan modificar el sentido de esta relación??
ggplot(data = datos,
       mapping = aes(x = culmen_length_mm, y = culmen_depth_mm, color=species)) +
  geom_point(size=2.5) +
  geom_smooth(method = "lm")

# Que cambió?

#Nota: Lo que acabamos de ver es un ejemplo de lo que en estadística y probabilidad se conoce como la "Paradoja de Simpson" --> Una tendencia que aparece en varios grupos de datos desaparece cuando estos grupos se combinan y en su lugar aparece la tendencia contraria para los datos agregados (https://es.wikipedia.org/wiki/Paradoja_de_Simpson#:~:text=En%20probabilidad%20y%20estad%C3%ADstica%2C%20la,contraria%20para%20los%20datos%20agregados.)




#
# _3.2 Otros objetos geométricos disponibles ----
#

## Histogramas
ggplot(data = datos, 
       mapping = aes(x=flipper_length_mm)) +
  geom_histogram(color="white")


count(datos, cut_width(flipper_length_mm, 2))


#el histograma tiene 1 problema --> Su aspecto puede variar dependiendo del número de rangos-barras (bins) que se ocupen
ggplot(data = datos, 
       mapping = aes(x=flipper_length_mm)) +
  geom_histogram(color="white", bins = 5)


## Una buena alternativa - > Distribución de densidad
ggplot(data = datos, 
       mapping = aes(x=flipper_length_mm)) +
  geom_density()

ggplot(data = datos, 
       mapping = aes(x=flipper_length_mm, color = island)) +
  geom_density()

#################################### -- EJERCICIO -- ########################################################+
# Como es la distribución de datos de la variable "flipper_length_mm" por especie. Puedes usar histograma,
# o un gráfico de densidad



# Si pudiste hacer el gráfico anterior..... ahora prueba usando el argumento "fill" en remplazo de "color"



#############################################################################################################+


## Gráfico de barras -> Recuentos
ggplot(data = datos,
       mapping = aes(x=species)) +
  geom_bar()

#como podemos ordenar la barras -> paquete "forcats"
ggplot(data = datos,
       mapping = aes(x = forcats::fct_infreq(species))) +
  geom_bar()


ggplot(data = datos,
       mapping = aes(x = forcats::fct_rev(fct_infreq(species)))) +
  geom_bar()



#vamos a agregar un nivel de información mediante la variable "sex" y 
#guardaremos nuestro gráfico como un objeto de nombre "g1"
(g1 <- ggplot(data = datos,
              mapping = aes(x = forcats::fct_rev(fct_infreq(species)), fill=sex)) +
    geom_bar()
)

class(g1)

g1 + 
  coord_flip()

#Que pasa si olvidamos los paréntesis?? -> Mira los warnings en la consola
g1 + 
  coord_flip

#podemos probar otros sistemas de coordenadas... no siempre es la mejor idea, pero sirve para explorar
g1 + 
  coord_polar()






## Gráficos de tipo Violin
ggplot(data = datos,
       mapping = aes(x= species, y=flipper_length_mm)) +
  geom_violin()

ggplot(data = datos,
       mapping = aes(x= species, y=flipper_length_mm, color= species)) +
  geom_violin()

ggplot(data = datos,
       mapping = aes(x= species, y=flipper_length_mm, fill= species)) +
  geom_violin(alpha=.5)


#mejoremos algunas caracteristicas
ggplot(data = datos,
       mapping = aes(x= species, y=flipper_length_mm, fill= species)) +
  geom_violin(alpha=.5, color="white") + #color del borde blanco
  scale_fill_tableau() #otra escala de color prediseñada




## Boxplot 
ggplot(data = datos,
       mapping = aes(x= species, y=flipper_length_mm)) +
  geom_boxplot()

## Boxplot  - horizontal
ggplot(data = datos,
       mapping = aes(x= species, y=flipper_length_mm)) +
  geom_boxplot() +
  coord_flip()


## Boxplot agregando otra variable de interés
ggplot(data = datos,
       mapping = aes(x= species, y=flipper_length_mm, fill=sex)) +
  geom_boxplot()


#si quieres eliminar la categoría NA (datos faltantes) puedes correr el siguiente código
datos %>% 
  filter(!is.na(sex)) %>% 
  ggplot(mapping = aes(x= species, y=flipper_length_mm, fill=sex)) +
  geom_boxplot()

#Nota: eliminar los datos faltantes y realizar otro tipo de manipulaciones de datos te permitirá explorar de mejor forma tus datos... esto es todo un tema por si mismo y se podría abordar en otro taller..... quizás......¿?




### Combinar capas geométicas
ggplot(data = datos,
       mapping = aes(x= species, y=flipper_length_mm, fill=species)) +
  geom_violin(alpha=.5, color="white") +
  geom_boxplot(alpha=.8)


#################################### -- EJERCICIO -- ########################################################+
# Una de las ventajas de hacer gráficos con ggplot2 es la posibilidad de combinar capas geométricas....
# Haz un gráfico combinando dos capas geométricas (diferente al gráfico anterior)




#############################################################################################################+


#
# _3.3 Agregar otra capa de información con facet_ ----
#

datos %>% 
  #manipulación de datos
  filter(!is.na(sex)) %>% 
  #gráfico
  ggplot(mapping = aes(x= species, y=flipper_length_mm, color=sex)) +
  geom_boxplot() +
  facet_wrap(~island)


datos %>% 
  #manipulación de datos
  filter(!is.na(sex)) %>% 
  #gráfico
  ggplot(mapping = aes(x= species, y=flipper_length_mm, fill=sex)) +
  geom_boxplot() +
  facet_wrap(~island, scales = "free_x")


datos %>% 
  #manipulación de datos
  filter(!is.na(sex)) %>% 
  #gráfico
  ggplot(mapping = aes(x= species, y=flipper_length_mm, fill=sex)) +
  geom_boxplot() +
  facet_grid(~island, scales = "free_x", space = "free")



#Otro ejemplo de la utilidad de facets.....
datos %>% 
  #manipulación de datos
  filter(!is.na(sex)) %>% 
  #gráfico
  ggplot(mapping = aes(culmen_length_mm, culmen_depth_mm, color=species)) +
  geom_point()


datos %>% 
  #manipulación de datos
  filter(!is.na(sex)) %>% 
  #gráfico
  ggplot(mapping = aes(culmen_length_mm, culmen_depth_mm, color=species)) +
  geom_point() +
  facet_wrap(~sex) +
  geom_smooth(method = "lm")



#
# _3.4 Agregar títulos, modificación de escalas y del aspecto general del gráfico con theme() ----
#


(graf_final <- datos %>% 
   #manipulación de datos
   filter(!is.na(sex)) %>% 
   #gráfico
   ggplot(mapping = aes(culmen_length_mm, culmen_depth_mm, fill=species)) +
   geom_point(shape=21, size=3, alpha=.8, color="white") +
   geom_smooth(method = "lm", alpha=.2, aes(color=species)) +
   #escala de color prediseñada
   scale_fill_tableau() +
   scale_color_tableau() +
   #titulos
   labs(title="Relación entre el largo y profundidad del culmen en pingüinos de la estación de investigación PALMER",
        subtitle="Dimensiones del culmen en las especies Adelle, Chinstrap y Gentoo.",
        x="\n Longitud del culmen (mm)",
        y="Profundidad del culmen (mm) \n", 
        color="Especie",
        fill="Especie",
        caption = "Fuente: Long Term Ecological Research Network") +
   #escalas eje x e y
   scale_x_continuous(limits = c(30, 60), breaks = seq(20, 60, 5)) +
   scale_y_continuous(limits = c(12, 24), breaks = seq(10, 24, 2)) +
   #aspecto general de la trama
   theme_minimal() +
   theme(axis.line.x = element_line())
)


graf_final + theme_dark()
graf_final + theme_fivethirtyeight()
graf_final + theme_igray()
graf_final + theme_map()
graf_final + theme_economist()
graf_final + theme_hc()
graf_final + theme_excel_new()
graf_final + theme_solarized()


graf_final


#Quieres guardar tú gráfico???
ggsave("gráfico_final.png", graf_final, dpi = 500, units = "cm", width = 25, height = 12)


#################################### -- EJERCICIO -- ############################################################+
# Siguiendo los pasos vistos en el taller y con todos los elementos del gráfico anterior, genera uno nuevo 
# y aguardalo en tu pc 




#################################################################################################################+


#Nota: Esto es lo general y el punto de partida para poder hacer mejores visualizaciones y explorar tus datos con mayor profundidad.

#########################################  FIN  #########################################+




#
##
### Bonus Track ----
##
#



#
# [BT_1] Interactividad -----
#
if(!require(plotly))       install.packages("plotly")

ggplotly(graf_final)


#
# [BT2] Errores comunes -----
#

#Comprueba la parte izquierda de tu consola: si es un +, significa que R no cree que hayas escrito una expresión completa y está esperando que la termines. En este caso, generalmente es mejor comenzar de nuevo desde cero presionando ESCAPE para cancelar lo que estabas haciendo y que quedo incompleto.

#Colocar el + en el lugar equivocado: SIEMPRE debe ubicarse al final de la línea, no al inicio.




#
# [BT3] Donde buscar ayuda -----
#

#En la consola de R escribe ?nombre_de_la_funcion y presiona enter. Te aparecerá la ayuda oficial que tiene R de capa paquete o función
#SAN GOOGLE -> una buena opción es copiar y pegar el mensaje de error tal cual en google o escribir lo que quieres hacer (es mejor si buscas en inglés). Generalmente las primeras opciones en la búsqueda te van a enviar a un foro de "Stack Overflow"..... ahí estas en el lugar correcto
#Puedes encontrar información y ejemplos de cómo usar cada paquete o función escribiendo el nombre de lo que quieres buscar agregando la letra R. Existen muchas páginas, blogs y talleres sobre diferentes temas relacionados a R
#En Twitter usando #Rstats


#Como no perderme en estas casi 500 líneas de código?? --> Mira en la parte superior derecha del editor (script) aparecen unas líneas horizonatales en forma de índice... haz click en ellas.....




