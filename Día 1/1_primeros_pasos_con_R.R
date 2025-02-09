###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
### TALLER DE INTRODUCCI�N A R                                           -----      
### PRIMEROS PASOS CON R                                                 -----
### 
### Autor: Amadeo Guzm�n
###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



#
##
### 1.- Algunas definiciones y consideraciones previas ----
##
#

# Cada l�nea de texto que se escribe despu�s del s�mbolo # R no lo considera como un elemento a ejecutar --> Sirve para hacer comentarios, poner t�tulos de secci�n, links de pag. web, etc.
# En general, NO se recomienda usar acentos y ocupar la letra �
# R es un lenguaje de programaci�n orientado a OBJETOS --> todo lo podemos guardar en un objeto y ocuparlo cuando sea necesario
# Para almacenar datos en un objeto debes ocupar el operador de asignaci�n  <-  (atajao teclado: ALT-)
# IMPORTANTE --> Para ejecutar un c�digo en R puedes: (1) poner el cursor sobre el c�digo y apretar Ctrl + Enter; (2) seleccionar el c�digo y hacer clik en "Run"



#
##
###  2.- Operaciones b�sicas ----------------------------------------------------------------------------
##
#

#suma
2+10

#resta
15-3

#Multiplicaci�n
555*1238

#Divisi�n
300/15

#Potencia
3^7

#Operaciones relacionales 
10>3

10 != 10
10 == 10




#
##
### 3.- Estructuras de datos ------------------------------------------------------------------------
##
#


### 3.1.- Vectores ----

100
is.vector(100) #estructura mas sencilla en R

vec1 <- 100 #almacenamos el valor 100 en un objeto mediante el operador <-
vec1

(vec1 <- 100) #puedes usar parentesis para ejecutar el c�digo e imprimir de inmediato el resultado en la consola
is.vector(vec1)


vec10 <- c(1:10) #secuencia de datos con :
vec10
is.vector(vec10)
class(vec10)


#vector de texto
(vec_txt <- c("a", "b", "c"))
length(vec_txt) #n� elementos del vector
is.vector(vec_txt)
class(vec_txt)


vec2 <- c(1, 2, 3, "a") #si intentamos crear un vector con ditintos tipos de datos... R realiza coerci�n (forzar)
vec2
is.vector(vec2)
class(vec2)


#Operaciones con vectores / objetos
x <- 5
y <- 10

x+1
y/2

x+y

#Operaciones relacionales con vectores
x
y

x < y

x == y

y >= x


#### EJERCICIO #################################################################+
#Crear dos vectores (objetos) z1 y z2 con los elementos A y a respectivamente 
#comprobar si z1 es igual a z2


################################################################################+




### 3.2.- Data Frame ----
#crear data frame en R (solo de ejemplo)
(v1 <- c(10:20))
(v2 <- c(100:110))
(v3 <- c("a","a","a","a","b","b","b","b","c","c", "c"))

(df <- data.frame(v1,v2,v3))

#IMPORTANTE -> en una base de datos cada columna es una variable y cada fila es una observaci�n/individuo/unidad



#Veamos una data frame """real""""
iris
?iris

#conocer nuestro data frame
dim(iris)
names(iris)


### Podemos explorar elementos espec�ficos de nuestra base de datos 
### mediante el uso de 2 operadores $ y [,]

### Operador $ -> extraer elementos de una variable determinada (columna)
iris$Petal.Length
iris$Sepal.Length


### EJERCICIO #####################################
#explorara los registros del vector  "Species"


###################################################



### Operador [,] -> Acceder a elementos ya sea en [filas , columnas]
#Columnas
iris[,3]   #posici�n
iris[,3:5]

iris[,"Sepal.Length"]  #nombre
iris[, c("Sepal.Length", "Petal.Length")]

#Filas
iris[5,]
iris[1:5,]
iris[c(1,5,120), ]

#Filas y columnas
iris[1:10 , 3:5]



### EJERCICIO #############################################################
#explorara los registros de las columnas species en las filas 12, 60 y 112


###########################################################################




