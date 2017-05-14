#####  TFM

## En esta ruta est? el script que nos ha enviado Israel por correo 
#setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM") ## ruta curro
setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset") ## ruta portatil
#setwd("~/GitHub/TFM") ##RUTA SERGIO


## Apertura del dataset
vuelos <- read.table("operations_leg.csv", header = T, sep = "^")




## 1. Primera visualizacion de los datos
summary(vuelos)

## 2. Eliminamos variables que no contienen informacion
vuelos$arrival_date <- NULL
vuelos$cabin_3_code <- NULL
vuelos$cabin_3_fitted_configuration <- NULL
vuelos$cabin_3_saleable <- NULL
vuelos$cabin_3_pax_boarded <- NULL
vuelos$cabin_3_rpk <- NULL
vuelos$cabin_3_ask <- NULL
vuelos$cabin_4_code <- NULL
vuelos$cabin_4_fitted_configuration <- NULL
vuelos$cabin_4_saleable <- NULL
vuelos$cabin_4_pax_boarded <- NULL
vuelos$cabin_4_rpk <- NULL
vuelos$cabin_4_ask <- NULL

summary(vuelos)

## Nos centraremos en la variable "general_status_code" .
vuelosCancelled <- vuelos[vuelos$general_status_code=="Cancelled",]   ## 1601 registros
vuelosDeparted <- vuelos[vuelos$general_status_code=="Departed",]     ## 220247 registros
vuelosLocked <- vuelos[vuelos$general_status_code=="Locked",]         ## 3 registros
vuelosOpen <- vuelos[vuelos$general_status_code=="Open",]             ## 154 registros
vuelosSuspended <- vuelos[vuelos$general_status_code=="Suspended",]   ## 7 registros

## 2.1 Analizamos cada dataframe para ver si tiene sentido incluirlo en el estudio
## 2.1.1 vuelosCancelled
str(vuelosCancelled)
summary(vuelosCancelled)

## Para este caso, las horas de salida y de llegada se encuentran vacias en la mayor parte de sus datos
library(lubridate)
vuelosCancelled$scheduled_time_of_departure <- ymd_hms(vuelosCancelled$scheduled_time_of_departure)
vuelosCancelled$estimated_time_of_departure <- ymd_hms(vuelosCancelled$estimated_time_of_departure)
vuelosCancelled$actual_time_of_departure <- ymd_hms(vuelosCancelled$actual_time_of_departure)
vuelosCancelled$scheduled_time_of_arrival <- ymd_hms(vuelosCancelled$scheduled_time_of_arrival)
vuelosCancelled$estimated_time_of_arrival <- ymd_hms(vuelosCancelled$estimated_time_of_arrival)
vuelosCancelled$actual_time_of_arrival <- ymd_hms(vuelosCancelled$actual_time_of_arrival)

summary(vuelosCancelled)

## Observamos que las fechas reales de salida y de llegada no estan indicadas, por lo que no es relevante para el estudio

## 2.2.2 vuelosLocked
str(vuelosLocked)
summary(vuelosLocked)

## Este DF tiene 3 registros. Ninguno de ellos tiene fechas indicadas de salida y llegada, por lo que no es relevante para el estudio

## 2.2.3 vuelosOpen
str(vuelosOpen)
summary(vuelosOpen)

## Este DF tiene 154 registros. Ninguno de ellos tiene fechas indicadas de salida y llegada, por lo que no es relevante para el estudio

## 2.2.4 vuelosSuspended
str(vuelosSuspended)
summary(vuelosSuspended)

## Este DF tiene 7 registros. Ninguno de ellos tiene fechas indicadas de salida y llegada, por lo que no es relevante para el estudio

## 2.2.5 vuelosDeparted
str(vuelosDeparted)
summary(vuelosDeparted)

vuelosDeparted$scheduled_time_of_departure <- ymd_hms(vuelosDeparted$scheduled_time_of_departure)
vuelosDeparted$estimated_time_of_departure <- ymd_hms(vuelosDeparted$estimated_time_of_departure)
vuelosDeparted$actual_time_of_departure <- ymd_hms(vuelosDeparted$actual_time_of_departure)
vuelosDeparted$scheduled_time_of_arrival <- ymd_hms(vuelosDeparted$scheduled_time_of_arrival)
vuelosDeparted$estimated_time_of_arrival <- ymd_hms(vuelosDeparted$estimated_time_of_arrival)
vuelosDeparted$actual_time_of_arrival <- ymd_hms(vuelosDeparted$actual_time_of_arrival)

summary(vuelosDeparted)

## En este DF se encuentran los datos que queremos estudiar, por lo tanto utilizaremos "vuelosDeparted"


## 3. Eliminamos variables innecesarias del DF
vuelosDeparted$snapshot_date <- NULL ## La fecha de captura de datos es irrelevante para el estudio
vuelosDeparted$snapshot_time <- NULL ## La hora de captura de datos es irrelevante para el estudio
vuelosDeparted$estimated_time_of_departure <- NULL  ## La fecha estimada de salida es irrelevante para el estudio
vuelosDeparted$estimated_time_of_arrival <- NULL    ## La fecha estimada de llegada es irrelevante para el estudio
##vuelosDeparted$est_blocktime <- NULL  ## El tiempo de vuelo estimado es irrelevante para el estudio



## Una vez tenemos los datos que queremos estudiar, realizamos un analisis y transformacion de variables si fuera necesario
str(vuelosDeparted)
## Se observa que hay variables que deben ser transformadas.

## 4. Transformacion de datos

### 4.1 flight_number
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$flight_number)
summary(vuelosDeparted$flight_number)

### Esta variable esta guardada como entero. Al ser un numero de vuelo lo transformamos a factor
vuelosDeparted$flight_number <- as.factor(vuelosDeparted$flight_number)

options(max.print=999999)  ### incrementar la salida del summary
summary(vuelosDeparted$flight_number, maxsum = 1100)

str(vuelosDeparted$flight_number)
unique(vuelosDeparted$flight_number)  ## 1045 vuelos distintos
table(vuelosDeparted$flight_number)

### 4.2 flight_date
## (COMPLETADA)
###############################################################################################

## Comprobamos la necesidad de esta variable
fechasVuelos <- subset(vuelosDeparted, select = c("flight_date","actual_time_of_departure","actual_time_of_arrival", "act_blocktime", "routing"))

fechasVuelos$fecha <- as.Date(fechasVuelos$actual_time_of_departure)
str(fechasVuelos)

fechasVuelos$flight_date <- as.Date(fechasVuelos$flight_date)

head(fechasVuelos,20)
tail(fechasVuelos,20)

## Comprobamos si alguna fecha no coincide
fechaIncorrecta <- fechasVuelos[fechasVuelos$flight_date!=fechasVuelos$fecha,]

str(fechaIncorrecta)  ## Existen 432 fechas de vuelos que no coinciden con las fechas reales de salida
head(fechaIncorrecta)
#### Existen fechas de vuelo que no corresponden a las fechas reales de salida

## Comprobamos que la variable "actual_time_of_departure" no tiene NAs
summary(vuelosDeparted$actual_time_of_departure)

## Eliminamos del DF la variable flight_date.
## Aunque existen fechas que no coinciden, nos guiamos por la variable actual_time_of_departure para determinar 
## la fecha de salida de los vuelos
vuelosDeparted$flight_date <- NULL

summary(vuelosDeparted)


### 4.3 board_point 
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$board_point)
summary(vuelosDeparted$board_point, maxsum = 160)
table(vuelosDeparted$board_point)

### Esta variable no contiene NAs y se almacena como factor, por lo que no la modificaremos



### 4.4 board_lat
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$board_lat)
summary(vuelosDeparted$board_lat)

### Esta variable no contiene NAs y se almacena como numeric, de momento la dejamos asi


### 4.5 board_lon
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$board_lon)
summary(vuelosDeparted$board_lon)

### Esta variable no contiene NAs y se almacena como numeric, de momento la dejamos asi



### 4.6 board_country_code ( y off_country_code )
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$board_country_code)
summary(vuelosDeparted$board_country_code)

### Variable almacenada como factor
### Existen NAs. Comprobamos la latitud y longitud de los NAs

### 4.6.1 Dataframe de codigos de paises de salida con sus latitudes y longitudes
vuelosCodeLatLonBoard <- subset(vuelosDeparted, select=c("board_country_code", "board_lat", "board_lon"))
vuelosCodeLatLonBoard <- unique(vuelosCodeLatLonBoard)

vuelosCodeLatLonBoard[is.na(vuelosCodeLatLonBoard$board_country_code)==TRUE,]
### se observa que los NA tienen la misma latitud y longitud, por lo que se trata de un ?nico aeropuerto


### 4.6.2. Comprobamos si los datos de aeropuertos de llegada guardan estas latitudes
vuelosCodeLatLonArrive <- subset(vuelosDeparted, select = c("off_country_code","off_lat","off_lon"))
vuelosCodeLatLonArrive <- unique(vuelosCodeLatLonArrive)

vuelosCodeLatLonArrive[is.na(vuelosCodeLatLonArrive$off_country_code)==TRUE,]
### Se observa que en los datos de llegadas tambien existen NA con los mismos valores para latitud y longitud 

### 4.6.3 Para salidas y llegadas de vuelos, si buscamos la ruta realizada en funcion de latitud y longitud 
### observamos que el codigo de aeropuerto corresponde a WDH
unique(subset(vuelosDeparted, vuelosDeparted$board_lon==17.08323 & vuelosDeparted$board_lat==-22.55941, select = c("routing")))
unique(subset(vuelosDeparted, vuelosDeparted$off_lon==17.08323 & vuelosDeparted$off_lat==-22.55941, select = c("routing")))

### Buscando en internet el codigo de aeropuerto encontramos varias paginas donde se indica
### que el codigo WDH corresponde a Namibia:
### http://www.mundocity.com/vuelos/aeropuertos/windhoek+wdh.html
### https://es.wikipedia.org/wiki/Aeropuerto_Internacional_de_Windhoek_Hosea_Kutako

### 4.6.4 Como el aeropuerto es de Namibia sustituiremos los NAs por NM.
### Comprobamos si existe el codigo de aeropuerto escogido en los aeropuertos de salida y de llegada
vuelosCodeLatLonBoard[vuelosCodeLatLonBoard$board_country_code=="NM",]
vuelosCodeLatLonArrive[vuelosCodeLatLonArrive$off_country_code=="NM",]

### 4.6.5 Sustituimos NAs por NM en los datos de salida y de llegada
summary(vuelosDeparted$board_country_code)  ## NAs -> 826 valores
vuelosDeparted$board_country_code <- as.character(vuelosDeparted$board_country_code)
vuelosDeparted$board_country_code <- replace(vuelosDeparted$board_country_code, is.na(vuelosDeparted$board_country_code), "NM")
vuelosDeparted$board_country_code <- as.factor(vuelosDeparted$board_country_code)
summary(vuelosDeparted$board_country_code)  ## NM -> 826 valores

summary(vuelosDeparted$off_country_code)  ## NAs -> 812 valores
vuelosDeparted$off_country_code <- as.character(vuelosDeparted$off_country_code)
vuelosDeparted$off_country_code <- replace(vuelosDeparted$off_country_code, is.na(vuelosDeparted$off_country_code), "NM")
vuelosDeparted$off_country_code <- as.factor(vuelosDeparted$off_country_code)
summary(vuelosDeparted$off_country_code)  ## NM -> 812 valores


summary(vuelosDeparted)

### 4.7 departure_date
## (COMPLETADA)
###############################################################################################

### Comprobamos la necesidad de esta variable
departure <- subset(vuelosDeparted, select = c("departure_date","actual_time_of_departure"))

head(departure,10)
tail(departure,10)

## Comprobamos si la variable "actual_time_of_departure" tiene algun NA
summary(vuelosDeparted$actual_time_of_departure)
## No existen NAs en "actual_time_of_departure"

## obtenemos las fechas de la variable actual_time_of_departure
departure$fechaReal <- as.Date(departure$actual_time_of_departure)

str(departure)

## Buscamos fechas que no coincidan
departure$departure_date <- as.Date(departure$departure_date)
fechaErronea <- departure[departure$departure_date!=departure$fechaReal,]

str(fechaErronea)
## Existen 385 fechas erroneas

## Como existen fechas erroneas eliminaremos la variable "departure_date". Utilizaremos la variable 
## "actual_time_of_departure" en su lugar
vuelosDeparted$departure_date <- NULL

summary(vuelosDeparted)


### 4.8 off_point
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$off_point)
table(vuelosDeparted$off_point)

### Esta variable no contiene NAs y esta almacenada como tipo factor, por lo tanto no se hacen modificaciones


### 4.9 off_lat
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$off_lat)
summary(vuelosDeparted$off_lat)

### Variable que no contiene NAs y almacenada como tipo numeric. Por ahora no se hacen cambios


### 4.10 off_lon
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$off_lon)
summary(vuelosDeparted$off_lon)

### Variable que no contiene NAs y almacenada como tipo numeric. Por ahora no se hacen cambios


### 4.11 distance
## (COMPLETADA)
###############################################################################################
str(vuelosDeparted$distance)
summary(vuelosDeparted$distance)

### Esta variable no contiene NAs y se encuentra almacenado como int. No haremos cambios en este campo



### 4.12 scheduled_time_of_departure
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$scheduled_time_of_departure)
summary(vuelosDeparted$scheduled_time_of_departure)

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que de momento no se modificara



### 4.13 actual_time_of_departure
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$actual_time_of_departure)
summary(vuelosDeparted$actual_time_of_departure)

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que de momento no se modificara




### 4.14 scheduled_time_of_arrival
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$scheduled_time_of_arrival)
summary(vuelosDeparted$scheduled_time_of_arrival)

### Esta variable no contiene NAs y ya fue transformada a Date, por lo que de momento no se modificara



### 4.15 actual_time_of_arrival  
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$actual_time_of_arrival)
summary(vuelosDeparted$actual_time_of_arrival)

### Esta variable ya fue transformada a tipo Date pero contiene NAs, por lo que hay que determinar si es posible sustituir 
### los NAs por algun valor determinado en funcion de otras variables existentes

## 4.15.1
vuelosFechaNula <- vuelosDeparted[is.na(vuelosDeparted$actual_time_of_arrival)==TRUE,]
str(vuelosFechaNula)  ## 3770 vuelos con fecha nula

## 4.15.2 Para aquellos casos en los que la fecha actual de llegada es nula, utilizaremos la suma de la fecha programada
## de llegada mas el retraso de llegada para obtener una fecha real de llegada del vuelo
vuelosDeparted2 <- vuelosDeparted
vuelosDeparted2$actual_time_of_arrival2 <- vuelosDeparted2$scheduled_time_of_arrival+minutes(vuelosDeparted2$arrival_delay)

## Comprobamos que la fechas calculadas (programada + retraso de salida) coinciden con las fechas actuales que ya tenemos
fechasIncorrectas <- vuelosDeparted2[vuelosDeparted2$actual_time_of_arrival!=vuelosDeparted2$actual_time_of_arrival2,]

fechasIncorrectas <- subset(fechasIncorrectas, 
                            select = c("scheduled_time_of_departure", "departure_delay", "actual_time_of_departure",
                                       "scheduled_time_of_arrival","arrival_delay","actual_time_of_arrival","actual_time_of_arrival2",
                                       "act_blocktime"))

str(fechasIncorrectas)  ## 7669 fechas incorrectas con NAs en "actual_time_of_arrival"

## Eliminamos NAs
fechasIncorrectas <- fechasIncorrectas[is.na(fechasIncorrectas$actual_time_of_arrival)==FALSE,]
str(fechasIncorrectas)  ## 3899 fechas incorrectas sin NAs en actual_time_of_arrival
head(fechasIncorrectas,1)

## 4.15.3 Al haber realizado estos pasos nos hemos dado cuenta de que NO TIENE SENTIDO calcular el tiempo
## actual de llegada en base al tiempo de llegada programado mas el retraso de salida, ya que puede haber 
## datos que no cumplan con este criterio, como por ejemplo el siguiente:
head(fechasIncorrectas,1)
## Con este dato se observa lo siguiente:
## La suma de la hora planificada de salida mas el retraso de salida no corresponde con la hora real de salida.
## Lo mismo ocurre con la hora planificada de llegada y la hora real de llegada. Sin embargo, la diferencia de 
## tiempo entre ambas fechas coincide con el blocktime indicado.
## ESTE DATO ES PERFECTAMENTE VALIDO, pero si nos basamos en la suma correspondiente a la fecha planificada de salida 
## mas el retraso de salida y en la fecha planificada de llegada mas el retraso de llegada este dato no seria valido.
## Por lo tanto, no tiene sentido calcular fechas reales en base a fechas planificadas y retrasos



## 4.15.4 Debido a que es imposible calcular con certeza la fecha de llegada de vuelos en base a datos del dataset, 
## descartaremos aquellos registros cuya variable "actual_time_of_arrival" sea nula.
vuelosDeparted <- vuelosDeparted[is.na(vuelosDeparted$actual_time_of_arrival)==FALSE,]

summary(vuelosDeparted)





### 4.16 departure_delay
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$departure_delay)
summary(vuelosDeparted$departure_delay)

## La variable no contiene NAs y se encuentra almacenada como int, por ahora no haremos modificaciones



### 4.17 arrival_delay 
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$arrival_delay)
summary(vuelosDeparted$arrival_delay)

## La variable no contiene NAs y se encuentra almacenada como int, por ahora no haremos modificaciones




### 4.18 sched_blocktime
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$sched_blocktime)
summary(vuelosDeparted$sched_blocktime)

## Este campo esta almacenado como int y no contiene NAs. De momento no se modificara




### 4.19 act_blocktime 
## (COMPLETADA)
## Tiempo de vuelo. Diferencia entre hora de llegada y hora de salida. Indicado en minutos
###############################################################################################

str(vuelosDeparted$act_blocktime)
summary(vuelosDeparted$act_blocktime)

## Dato almacenado como entero.
## No existen nulos pero existen valores negativos. (Estos valores negativos no tienen sentido)

negativos <- vuelosDeparted[vuelosDeparted$act_blocktime<0,]
head(negativos)


## 4.19.1 almacenamos en una nueva variable la diferencia entre la fecha de llegada y la fecha de salida
vuelosDeparted2 <- vuelosDeparted
vuelosDeparted2$BlocktimeNEW <- as.integer(
                    difftime(vuelosDeparted2$actual_time_of_arrival, vuelosDeparted2$actual_time_of_departure, units = "mins"))

head(vuelosDeparted2)

## Comprobamos si hay registros donde la nueva variable calculada (BlocktimeNEW) sea diferente a act_blocktime
str(vuelosDeparted2)
tiemposDiferentes <- vuelosDeparted2[vuelosDeparted2$act_blocktime!=vuelosDeparted2$BlocktimeNEW,]

str(tiemposDiferentes)
head(tiemposDiferentes)


fechasRetrasos <- subset(tiemposDiferentes, 
                select = c("actual_time_of_departure","actual_time_of_arrival",
                           "act_blocktime","BlocktimeNEW","routing"))

head(fechasRetrasos,5)

table(fechasRetrasos$routing)

## Obtenemos diferentes rutas de ejemplo
## AMV-LEU      AMV +1            
## CNF-LEU      CNF -5

fechasRetrasos$difTiempoMin <- fechasRetrasos$BlocktimeNEW - fechasRetrasos$act_blocktime

### AMV-LEU
tiempoRuta <- fechasRetrasos[fechasRetrasos$routing=="AMV-LEU",]
str(tiempoRuta)
head(tiempoRuta, 54)


unique(tiempoRuta$difTiempoMin)
## AMV es el aeropuerto de Amderma, en Rusia
## Este unique da como resultado -120 y -60. Estos valores indican las diferencias horarias para la ruta AMV-LEU
## que coinciden con el horario de verano y horario de invierno en europa. Es decir, en diferentes articulos como
## este (http://www.elmundo.es/elmundo/2011/02/08/ciencia/1297174335.html, de 2011) se indica que Rusia suprime el
## cambio horario, sin embargo la Union Europea lo mantiene y, por tanto, en invierno hay dos horas de diferencia 
## entre Rusia y Europa pero en verano solo hay 1 hora de diferencia
## Si utilizamos la ruta CNF-LEU ocurre lo mismo. Las diferencias encontradas son por los diferentes husos horarios
## y los cambios horarios establecidos localmente en verano e invierno


## Como se puede observar con la ruta anterior, los valores negativos son correctos ya que se obtienen en funcion
## de la zona horaria y los cambios horarios de cada pais





### 4.20 aircraft_type
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$aircraft_type)
summary(vuelosDeparted$aircraft_type)

## Este campo no contiene NAs y esta almacenado como tipo factor. No realizaremos cambios.





### 4.21 aircraft_registration_number
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$aircraft_registration_number)
summary(vuelosDeparted$aircraft_registration_number)

## Este campo no contiene NAs y esta almacenado como tipo factor. No realizaremos cambios.




### 4.22 general_status_code
## (COMPLETADA)
###############################################################################################
## Este campo se analizo en un principio.





### 4.23 routing
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$routing)
summary(vuelosDeparted$routing, maxsum = 357)

## Este campo se almacena como factor y no contiene NAs.





### 4.24 cabin_1_code / cabin_2_code 
## (COMPLETADA)
###############################################################################################

## Por los correos tenemos que los codigos son los siguientes: 
### Y economy, W premium eco, J business, F first


str(vuelosDeparted$cabin_1_code)
summary(vuelosDeparted$cabin_1_code)

## Se almacena como factor, todos los datos de esta variable son Y (economy)

str(vuelosDeparted$cabin_2_code)
summary(vuelosDeparted$cabin_2_code)

## Se almacena como factor. Tiene 93506 registros vacios (que no NAs) y 122971 registros con J (business)

## Comprobamos los registros vacios
cabin2Vacio <- vuelosDeparted[trimws(vuelosDeparted$cabin_2_code)=="",]
head(cabin2Vacio)

## Comprobamos si algun registro con cabin_2_code vacio tiene valores almacenados en algun campo de cabin_2
cabin2ask <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_ask)==FALSE,]
cabin2saleable  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_saleable)==FALSE,]
cabin2fitted_configuration  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_fitted_configuration)==FALSE,]
cabin2pax_boarded  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_pax_boarded)==FALSE,]
cabin2rpk  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_rpk)==FALSE,]
cabin2ask  <- cabin2Vacio[is.na(cabin2Vacio$cabin_2_ask)==FALSE,]

str(cabin2ask)
str(cabin2saleable)
str(cabin2fitted_configuration)
str(cabin2pax_boarded)
str(cabin2rpk)
str(cabin2ask)

## No existen datos anomalos





### 4.25 cabin_1_fitted_configuration / cabin_2_fitted_configuration -> Numero de asientos
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$cabin_1_fitted_configuration)
summary(vuelosDeparted$cabin_1_fitted_configuration)

## Esta variable se almacena como int y no contiene NAs.

str(vuelosDeparted$cabin_2_fitted_configuration)
summary(vuelosDeparted$cabin_2_fitted_configuration)

## Esta variable se almacena como int y tiene 93506 NAs, que coinciden con los registros vacios del
## campo "cabin_2_code".

## Comprobamos los registros vacios
cabin2Vacio <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_fitted_configuration)==TRUE,]
summary(cabin2Vacio)

## Estos datos coinciden con los datos de cabin_2_code. Todo OK.





### 4.26 cabin_1_saleable / cabin_2_saleable  -> numero de asientos en venta
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$cabin_1_saleable)
summary(vuelosDeparted$cabin_1_saleable)

## No contiene NAs y se almacena como entero

str(vuelosDeparted$cabin_2_saleable)
summary(vuelosDeparted$cabin_2_saleable)

## Campo almacenado como entero y contiene 93547 NAs, Son mas NAs de los que aparecen en el campo anterior


## Estudiamos los NAs de esta variable
cabinNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_saleable)==TRUE,]

str(cabinNA)
summary(cabinNA)
head(cabinNA)

## Se observa que hay 41 registros con cabin_2_code = J, que son lo que hacen la diferencia de esta variable
## con respecto a los NAs existentes en cabin_2_code

cabinJ <- cabinNA[cabinNA$cabin_2_code=="J",]

str(cabinJ)
summary(cabinJ)
head(cabinJ)


## Estos 41 registros deben ser eliminados
vuelosDeparted <- vuelosDeparted[trimws(vuelosDeparted$cabin_2_code)=="" | 
                            (vuelosDeparted$cabin_2_code=="J" & is.na(vuelosDeparted$cabin_2_saleable)==FALSE),]







### 4.27 cabin_1_pax_boarded / cabin_2_pax_boarded 
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$cabin_1_pax_boarded)
summary(vuelosDeparted$cabin_1_pax_boarded)

## Campo almacenado como entero. Existen 3540 NAs

## Comprobacion de los NAs
cabinPaxNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_1_pax_boarded)==TRUE,]

str(cabinPaxNA)
summary(cabinPaxNA)

## Las variables cabin_1_... y cabin_2_... son NAs. Eliminamos estos 3540 registros
vuelosDeparted <- vuelosDeparted[is.na(vuelosDeparted$cabin_1_pax_boarded)==FALSE,]

## cabin_2_pax_boarded

str(vuelosDeparted$cabin_2_pax_boarded)
summary(vuelosDeparted$cabin_2_pax_boarded)

## Campo almacenado como entero. Existen 89966 NAs 

## Obtenemos los NAs
cabinPaxNA <- vuelosDeparted[is.na(vuelosDeparted$cabin_2_pax_boarded)==TRUE,]

summary(cabinPaxNA)
## Haciendo el summary existen 198 registros con el campo "cabin_2_code" = J
cabinPaxNAJ <- cabinPaxNA[cabinPaxNA$cabin_2_code=="J",]

summary(cabinPaxNAJ)

## eliminamos estos 198 registros, ya que no tiene datos en los campos cabin_2_...
vuelosDeparted <- vuelosDeparted[trimws(vuelosDeparted$cabin_2_code)=="" | 
                                   (vuelosDeparted$cabin_2_code=="J" & is.na(vuelosDeparted$cabin_2_pax_boarded)==FALSE),]

summary(vuelosDeparted)





### 4.28 cabin_1_rpk / cabin_2_rpk  Beneficio en funcion de los pasajeros o unidad tipica para evaluar la demanda 
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$cabin_1_rpk)
summary(vuelosDeparted$cabin_1_rpk)

## Campo almacenado como entero.

str(vuelosDeparted$cabin_2_rpk)
summary(vuelosDeparted$cabin_2_rpk)

## Campo almacenado como entero. Existen 89966 NAs





### 4.29 cabin_1_ask / cabin_2_ask  -> unidad tipica para evaluar la oferta
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$cabin_1_ask)
summary(vuelosDeparted$cabin_1_ask)

## Campo almacenado como int. No contiene NAs

str(vuelosDeparted$cabin_2_ask)
summary(vuelosDeparted$cabin_2_ask)

## Campo almacenado como int. Contiene 89966 NAs, que corresponden a los valores cabin_1... que no tienen cabin_2...




### 4.30 total_rpk
### (COMPLETADA)
###############################################################################################

str(vuelosDeparted$total_rpk)
summary(vuelosDeparted$total_rpk)

## Campo almacenado como entero





### 4.31 total_ask
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$total_ask)
summary(vuelosDeparted$total_ask)

## Campo almacenado como int. No existen NAs





### 4.32 load_factor
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$load_factor)
summary(vuelosDeparted$load_factor)

## Campo almacenado como num. No existen NAs






### 4.33 total_pax
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$total_pax)
summary(vuelosDeparted$total_pax)

## Campo almacenado como int. No existen NAs




### 4.34 total_no_shows
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$total_no_shows)
summary(vuelosDeparted$total_no_shows)

## Campo almacenado como int. No existen NAs




### 4.35 total_cabin_crew 
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$total_cabin_crew)
summary(vuelosDeparted$total_cabin_crew)

## Campo almacenado como int. No existen NAs





### 4.36 total_technical_crew
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$total_technical_crew)
summary(vuelosDeparted$total_technical_crew)

## Campo almacenado como int. No existen NAs





### 4.37 total_baggage_weight
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$total_baggage_weight)
summary(vuelosDeparted$total_baggage_weight)

## Campo almacenado como int. No existen NAs





### 4.38 number_of_baggage_pieces
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$number_of_baggage_pieces)
summary(vuelosDeparted$number_of_baggage_pieces)

## Campo almacenado como int. No existen NAs





### 4.39 file_sequence_number
## (COMPLETADA)
###############################################################################################

str(vuelosDeparted$file_sequence_number)
summary(vuelosDeparted$file_sequence_number)

## Campo almacenado como factor. No existen los valores 1, 2 y 3. Existen los valores P (220229)
## Al ser siempre el mismo valor la eliminamos del conjunto de datos

vuelosDeparted$file_sequence_number <- NULL




### RESULTADO DEL DATAFRAME QUE UTILIZAREMOS PARA A?ADIR DATOS CLIMATICOS
str(vuelosDeparted)   ## 212698 objetos
str(vuelos)           ## original -> 222012 objetos




### 5. Creacion de nuevas variables en el dataframe
## 5.1. Mes de salida del vuelo
vuelosDeparted$mesSalida <- as.integer(month(vuelosDeparted$actual_time_of_departure))
## 5.2. Dia de salida del vuelo
vuelosDeparted$diaSalida <- as.integer(day(vuelosDeparted$actual_time_of_departure))
## 5.3. Hora de salida del vuelo
vuelosDeparted$horaSalida <- format(vuelosDeparted$actual_time_of_departure,'%H:%M:%S')
vuelosDeparted$horaSalida <- as.factor(vuelosDeparted$horaSalida)


## 5.4 Mes de llegada del vuelo
vuelosDeparted$mesLlegada <- as.integer(month(vuelosDeparted$actual_time_of_arrival))
## 5.5 Dia de llegada del vuelo
vuelosDeparted$diaLlegada <- as.integer(day(vuelosDeparted$actual_time_of_arrival))
## 5.6 Hora de llegada del vuelo
vuelosDeparted$horaLlegada <- format(vuelosDeparted$actual_time_of_arrival, "%H:%M:%S")
vuelosDeparted$horaLlegada <- as.factor(vuelosDeparted$horaLlegada)




## 5.7. Dia de la semana para la salida de los vuelos
vuelosDeparted$diaSemanaSalida <- weekdays(as.Date(vuelosDeparted$actual_time_of_departure))
vuelosDeparted$diaSemanaSalida <- as.factor(vuelosDeparted$diaSemanaSalida)
## 5.8. Dia de la semana para la llegada de los vuelos
vuelosDeparted$diaSemanaLlegada <- weekdays(as.Date(vuelosDeparted$actual_time_of_arrival))
vuelosDeparted$diaSemanaLlegada <- as.factor(vuelosDeparted$diaSemanaLlegada)



## diahora <- subset(vuelosDeparted, select = c("actual_time_of_departure","mesSalida","diaSalida","horaSalida",
##                                             "diaSemanaSalida", "actual_time_of_arrival","mesLlegada","diaLlegada",
##                                             "horaLlegada","diaSemanaLlegada"))

summary(vuelosDeparted)
str(vuelosDeparted)


tail(vuelosDeparted, 1)

##escribimos el dataframe resultante para reusarlo en la siguiente fase
write.csv('vuelosDeparted.csv',x = vuelosDeparted)
###

