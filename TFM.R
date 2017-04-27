#####  TFM

## En esta ruta está el script que nos ha enviado Israel por correo 
setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM")

## Apertura del dataset
vuelos <- read.table("operations_leg.csv", header = T, sep = "^")


### (1). eliminar variables innecesarias
vuelos2 <- vuelos
vuelos2$snapshot_date <- NULL
vuelos2$snapshot_time <- NULL
vuelos2$airline_code <- NULL
vuelos2$arrival_date <- NULL
vuelos2$estimated_time_of_departure <- NULL
vuelos2$estimated_time_of_arrival <- NULL
vuelos2$est_blocktime <- NULL
vuelos2$cabin_3_code <- NULL
vuelos2$cabin_3_fitted_configuration <- NULL
vuelos2$cabin_3_saleable <- NULL
vuelos2$cabin_3_pax_boarded <- NULL
vuelos2$cabin_3_rpk <- NULL
vuelos2$cabin_3_ask <- NULL
vuelos2$cabin_4_code <- NULL
vuelos2$cabin_4_fitted_configuration <- NULL
vuelos2$cabin_4_saleable <- NULL
vuelos2$cabin_4_pax_boarded <- NULL
vuelos2$cabin_4_rpk <- NULL
vuelos2$cabin_4_ask <- NULL



##################################################
## (2). Transformacion de datos

### (2.1). flight_number
###############################################################################################

str(vuelos2$flight_number)
summary(vuelos2$flight_number)

### Esta variable esta guardada como entero. Al ser un numero de vuelo lo transformamos a factor
vuelos2$flight_number <- as.factor(vuelos2$flight_number)

options(max.print=999999)  ### incrementar la salida del summary
summary(vuelos2$flight_number, maxsum = 1100)

unique(vuelos2$flight_number)
vuelos2[vuelos2$flight_number=="9999",]

######  Preguntas sobre esta variable
# ¿Son correctos los valores 0 y 9999?


### (2.2). flight_date
###############################################################################################

str(vuelos2$flight_date)
summary(vuelos2$flight_date, maxsum = 835)

### Esta variable se muestra como factor, se debe cambiar a DATE

vuelos2$flight_date <- as.Date(vuelos2$flight_date)

### No existen fechas nulas al pasar los datos
######  Preguntas sobre esta variable


### (2.3). board_point
###############################################################################################

str(vuelos2$board_point)
summary(vuelos2$board_point, maxsum = 159)

### Esta variable se almacena como factor, por lo que no la modificaremos


### (2.4). board_lat
###############################################################################################

str(vuelos2$board_lat)
summary(vuelos2$board_lat)

### Esta variable se almacena como numeric, de momento la dejamos asi


### (2.5). board_lon
###############################################################################################

str(vuelos2$board_lon)
summary(vuelos2$board_lon)

### Esta variable se almacena como numeric, de momento la dejamos asi



### (2.6) board_country_code ( y off_country_code )
###############################################################################################

str(vuelos2$board_country_code)
summary(vuelos2$board_country_code)

### Variable almacenada como factor
### Exsiten NAs. Se debe determinar un procedimiento para asignar codigos de embarque de cada pais en
###              funcion de la latitud y longitud

### (2.6.1). Dataframe de codigos de paises de salida con sus latitudes y longitudes
vuelosCodeLatLonBoard <- subset(vuelos2, select=c("board_country_code", "board_lat", "board_lon"))
vuelosCodeLatLonBoard <- unique(vuelosCodeLatLonBoard)

vuelosCodeLatLonBoard[is.na(vuelosCodeLatLonBoard$board_country_code)==TRUE,]
### se observa que los NA tienen la misma latitud y longitud, por lo que se trata de un único aeropuerto

head(vuelos2[is.na(vuelos2$board_country_code)== TRUE,],5)
head(vuelosCodeLatLonBoard[vuelosCodeLatLonBoard$board_lon==17.08323,],5)

### (2.6.2). Comprobamos si los datos de aeropuertos de llegada guardan estas latitudes
vuelosCodeLatLonArrive <- subset(vuelos2, select = c("off_country_code","off_lat","off_lon"))
vuelosCodeLatLonArrive <- unique(vuelosCodeLatLonArrive)

summary(vuelosCodeLatLonArrive)

head(vuelosCodeLatLonArrive[vuelosCodeLatLonArrive$off_lon==17.08323,],5)
head(vuelosCodeLatLonArrive[vuelosCodeLatLonArrive$off_lat==-22.55941,],5)

### Se observa que en los datos de llegadas tambien existen NA con los mismos valores para latitud y longitud 

### (2.6.3). Para salidas y llegadas de vuelos, si buscamos la ruta realizada en funcion de latitud y longitud 
### observamos que el codigo de aeropuerto corresponde a WDH
unique(subset(vuelos2, vuelos2$board_lon==17.08323 & vuelos2$board_lat==-22.55941, select = c("routing")))
unique(subset(vuelos2, vuelos2$off_lon==17.08323 & vuelos2$off_lat==-22.55941, select = c("routing")))

### Buscando en internet el codigo de aeropuerto encontramos varias paginas donde se indica
### que el codigo WDH corresponde a Namibia:
### http://www.mundocity.com/vuelos/aeropuertos/windhoek+wdh.html
### https://es.wikipedia.org/wiki/Aeropuerto_Internacional_de_Windhoek_Hosea_Kutako

### (2.6.4). Como el aeropuerto es de Namibia sustituiremos los NAs por NM.
### Comprobamos si existe el codigo de aeropuerto escogido en los aeropuertos de salida y de llegada
vuelosCodeLatLonBoard[vuelosCodeLatLonBoard$board_country_code=="NM",]
vuelosCodeLatLonArrive[vuelosCodeLatLonArrive$off_country_code=="NM",]

### (2.6.5). Sustituimos NAs por NM en los datos de salida y de llegada
summary(vuelos2$board_country_code)  ## NAs -> 829 valores
vuelos2$board_country_code <- as.character(vuelos2$board_country_code)
vuelos2$board_country_code <- replace(vuelos2$board_country_code, is.na(vuelos2$board_country_code), "NM")
vuelos2$board_country_code <- as.factor(vuelos2$board_country_code)
summary(vuelos2$board_country_code)  ## NM -> 829 valores

summary(vuelos2$off_country_code)  ## NAs -> 815 valores
vuelos2$off_country_code <- as.character(vuelos2$off_country_code)
vuelos2$off_country_code <- replace(vuelos2$off_country_code, is.na(vuelos2$off_country_code), "NM")
vuelos2$off_country_code <- as.factor(vuelos2$off_country_code)
summary(vuelos2$off_country_code)  ## NM -> 815 valores


### (2.7). departure_date
###############################################################################################

str(vuelos2$departure_date)
summary(vuelos2$departure_date, maxsum = 835)

### Esta variable esta almacenada como tipo factor. La pasamos a tipo Date
vuelos2$departure_date <- as.Date(vuelos2$departure_date)


### (2.8). off_point
###############################################################################################

str(vuelos2$off_point)
summary(vuelos2$off_point, maxsum = 161)

### Esta variable esta almacenada como tipo factor y por lo tanto no se hacen modificaciones


### (2.9). off_lat
###############################################################################################

str(vuelos2$off_lat)
summary(vuelos2$off_lat)

### Variable almacenada como tipo numeric. Por ahora no se hacen cambios


### (2.10). off_lon
###############################################################################################

str(vuelos2$off_lon)
summary(vuelos2$off_lon)

### Variable almacenada como tipo numeric. Por ahora no se hacen cambios


### (2.11). distance
###############################################################################################
str(vuelos2$distance)
summary(vuelos2$distance)

### El valor se encuentra almacenado como int. No haremos cambios en este campo

### Visualizamos las apariciones de cada valor
table(vuelos2$distance)


### (2.12). scheduled_time_of_departure
###############################################################################################

str(vuelos2$scheduled_time_of_departure)
summary(vuelos2$scheduled_time_of_departure)

### La variable se encuentra almacenada como factor. Debemos cambiar el tipo de la variable a Date
### teniendo en cuenta que tambien vienen almacenadas la hora, minuto y segundo

### Utilizamos lubridate para el manejo de fechas
head(vuelos2$scheduled_time_of_departure, 10)

library(lubridate)

vuelos2$scheduled_time_of_departure <- ymd_hms(vuelos2$scheduled_time_of_departure)


### (2.13). actual_time_of_departure
###############################################################################################
vuelos2$actual_time_of_departure <- vuelos$actual_time_of_departure
str(vuelos2$actual_time_of_departure)
summary(vuelos2$actual_time_of_departure)

### (2.13.1). La variable se encuentra almacenada como factor. Debemos cambiar el tipo de la variable a Date
### teniendo en cuenta que tambien vienen almacenadas la hora, minuto y segundo

### Utilizamos lubridate para el manejo de fechas
head(vuelos2$actual_time_of_departure, 10)

vuelos2$actual_time_of_departure <- ymd_hms(vuelos2$actual_time_of_departure)

### (2.13.2). Al hacer de nuevo un summary vemos que existen NAs (1765), por lo que estudiaremos la forma de 
### obtener la fecha programada en fucion de las variables scheduled_time_of_departure, departure_delay,
### sched_blocktime y act_blocktime

fechasVuelos <- subset(vuelos2, select = c("scheduled_time_of_departure","actual_time_of_departure","departure_delay","sched_blocktime","act_blocktime"))

fechasVuelosNA <- fechasVuelos[is.na(fechasVuelos$actual_time_of_departure)==TRUE,]

### (2.13.3). Si el campo "departure_delay" no es nulo podemos determinar que "actual_time_of_departure" es igual
### a la suma de "scheduled_time_of_departure" y "departure_delay"
fechasVuelosNA[is.na(fechasVuelosNA$departure_delay)==FALSE,]

### El numero de registros del campo departure_delay no nulos son los siguientes
NoNulos <- fechasVuelosNA[is.na(fechasVuelosNA$departure_delay)==FALSE,]
length(NoNulos$departure_delay)
### 118 valores no nulos

head(fechasVuelosNA, 5)

### (2.13.4). Sumar los retrasos de salida a la salida programada y asi dar valor a la salida real

vuelos2$actual_time_of_departure <- vuelos2$scheduled_time_of_departure + minutes(vuelos2$departure_delay)

### Si volvemos a hacer un summary vemos que los NAs han disminuido. Antes habia 1765 y ahora hay 1647,
### que corresponden con los valores no nulos en departure_delay

### (2.13.5). El siguiente paso es determinar los minutos a sumar o restar a cada fecha de salida programada
### para almacenarla como fecha de salida real (Tiene toda la pinta de que sera la media de retrasos de 
### las salidas)







pM <- head(prueba,5)
pM
pM2 <- pM

pM3 <- head(fechasVuelosNA,10)

pM2$actual_time_of_departure <- pM2$scheduled_time_of_departure + minutes(pM2$departure_delay)
pM3
pM3$actual_time_of_departure <- pM3$scheduled_time_of_departure + minutes(pM3$departure_delay)
pM2
pM3
result2 <- retrasoRealSalida(pM$scheduled_time_of_departure, pM$actual_time_of_departure, pM$departure_delay)

pM$scheduled_time_of_departure
pM$departure_delay
result

pruebaModificada$actual_time_of_departure <- 
  retrasoRealSalida(pruebaModificada$scheduled_time_of_departure, pruebaModificada$actual_time_of_departure, pruebaModificada$departure_delay)



str(vuelos2)
summary(vuelos2)

head(vuelos2, 1)


library(lubridate)
ymd_hms(vuelos2$actual_time_of_departure)


ejemFecha <- head(vuelos2$actual_time_of_departure, 10)
class(ejemFecha)
ejemFecha
ej <- as.Time(ejemFecha, format = "%Y-%m-%d %H:%M:%S")
class(ej)


f1 <- ej[1]


?as.date

?date

vuelos2$actual_time_of_departure = as.Date(vuelos2$actual_time_of_departure, format = "%Y/%m/%d %H:%M:%S")
vuelos2$actual_time_of_arrival = as.Date(vuelos2$actual_time_of_arrival, format = "%Y/%m/%d %h:%m:%s")
head(vuelos2[vuelos2$actual_time_of_departure > vuelos2$actual_time_of_arrival ,],5)


barplot(vuelos2$flight_date)

boxplot(as.Date(vuelos2$flight_date), xlab="flight_date")
boxplot(as.Date(vuelos2$actual_time_of_departure), xlab="actual_time_of_departure")
boxplot(as.Date(vuelos2$actual_time_of_arrival), xlab="actual_time_of_arrival")

str(vuelos2$actual_time_of_arrival)

summary(vuelos2)
