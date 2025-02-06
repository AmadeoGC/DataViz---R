

library(tidyverse)
library(fs)
library(readxl)

#
### Importar desde Excel
#

# Priemro un par de ejemplos

#importar primera hoja
read_excel("madrid_temp.xlsx") # Por defecto, la función read_excel() importa la primera hoja. Para importar una hoja diferente es necesario indicarlo con el argumento sheet o bien el número o el nombre (segundo argumento).

#importar hoja 3
read_excel("madrid_temp.xlsx", 3)


#creamos una ruta
path <- "madrid_temp.xlsx"

path %>%
  excel_sheets()


#ahora ocupamos map() que nos permitira leer multipls hojas... crea una lista de elementos 1 lista para cada hoja de excel
(mad <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map(read_excel,
      path = path)
)

class(mad)
str(mad)


#con map_df() que es una variante de map(), vamos a unir todas las tablas por fila. Si fuese necesario unir por columna se debería usar map_dfc().
(mad <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map_df(read_excel,
         path = path)
)

class(mad)
str(mad)


#ejemplo para crear una columna con el nombre de la hoja de excel
(mad <- path %>%
  excel_sheets() %>%
  set_names() %>%
  map_df(read_excel,
         path = path,
         .id = "yr2") #lo creamos con este argumento .id
)

str(mad)



#
#
# ¿Pero cómo importamos múltiples archivos de Excel? -------------------------
#
#

#de momento solo hemos visto opciones para importar y combinar las diferentes pestañas de un único archivo
#ahora veremos como importar multiples archivos Excel y combinar sus hojas
#lo vamos a hacer con la función dir_ls() del paquete {fs}

#dir_ls() nos entrega un listado de los elementos que estan en nuestro directorio de trabajo
dir_ls()

#podemos filtrar los archivos que queremos
dir_ls(regexp = "xlsx") 


#Importamos los dos archivos de Excel que tenemos --> Sin unir
dir_ls(regexp = "xlsx") %>%
  map(read_excel)


#uniendo con una nueva columna
dir_ls(regexp = "xlsx") %>%
  map_df(read_excel, .id = "city")


#de momento solo hemos importado la primera hoja de excel de cada archivo..... debemos crear una función, que repita lo que hicimos anteriormente

read_multiple_excel <- function(path) {
  path %>%
    excel_sheets() %>% 
    set_names() %>% 
    map_df(read_excel, path = path)
}


#Aplicamos nuestra función creada para importar múltiples hojas de varios archivos Excel.
#por separado
(data <- dir_ls(regexp = "xlsx") %>% 
  map(read_multiple_excel)
)

str(data)


#unir todas
data_df <- dir_ls(regexp = "xlsx") %>% 
  map_df(read_multiple_excel,
         .id = "city")

str(data_df)

data_df


















