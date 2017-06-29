
setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM/archivos_datos_drive") ## ruta curro


## Apertura del dataset
vuelos <- read.table("vuelosFinal.csv", header = T, sep = ",")
vuelos$X <- NULL
vuelos$index <- NULL
str(vuelos)
summary(vuelos)
