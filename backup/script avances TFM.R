#####  TFM

## En esta ruta está el script que nos ha enviado Israel por correo 
setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM")

## Apertura del dataset
vuelos <- read.table("operations_leg.csv", header = T, sep = "^")

## Visualizacion de los datos
tail(vuelos,5)

## datos del csv
str(vuelos)
summary(vuelos)

## 1. Transformacion de variables
##### snapshot_date
vuelos$snapshot_date = as.Date(vuelos$snapshot_date, format = "%Y/%m/%d")

##### snapshot_time
vuelos$snapshot_hour <- as.integer(gsub(":[0-9][0-9]:[0-9][0-9]$","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$snapshot_time)))    ## hora
vuelos$snapshot_minutes <- as.integer(gsub(":[0-9][0-9]$","", gsub("^[0-9][0-9]:","",gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$snapshot_time))))   ## min
vuelos$snapshot_seconds <- as.integer(gsub("^[0-9][0-9]:[0-9][0-9]:","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$snapshot_time)))   ## seg
vuelos$snapshot_time <- NULL

##### flight_date
vuelos$flight_date = as.Date(vuelos$flight_date, format = "%Y/%m/%d")

##### departure_date
vuelos$departure_date = as.Date(vuelos$departure_date, format = "%Y/%m/%d")

##### scheduled_time_of_departure
vuelos$scheduled_time_of_departure_hour <- as.integer(gsub(":[0-9][0-9]:[0-9][0-9]$","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$scheduled_time_of_departure)))    ## hora
vuelos$scheduled_time_of_departure_minutes <- as.integer(gsub(":[0-9][0-9]$","", gsub("^[0-9][0-9]:","",gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$scheduled_time_of_departure))))   ## min
vuelos$scheduled_time_of_departure_seconds <- as.integer(gsub("^[0-9][0-9]:[0-9][0-9]:","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$scheduled_time_of_departure)))   ## seg
vuelos$scheduled_time_of_departure = as.Date(vuelos$scheduled_time_of_departure, format = "%Y/%m/%d")

##### estimated_time_of_departure.  Existen NAs -> hay que ver que hacer con ello
#vuelos$estimated_time_of_departure_hour <- as.integer(gsub(":[0-9][0-9]:[0-9][0-9]$","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$estimated_time_of_departure)))    ## hora
#vuelos$estimated_time_of_departure_minutes <- as.integer(gsub(":[0-9][0-9]$","", gsub("^[0-9][0-9]:","",gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$estimated_time_of_departure))))   ## min
#vuelos$estimated_time_of_departure_seconds <- as.integer(gsub("^[0-9][0-9]:[0-9][0-9]:","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$estimated_time_of_departure)))   ## seg
#vuelos$estimated_time_of_departure = as.Date(vuelos$estimated_time_of_departure, format = "%Y/%m/%d")

##### actual_time_of_departure. Existen NAs -> hay que ver que hacer con ello
#vuelos$actual_time_of_departure_hour <- as.integer(gsub(":[0-9][0-9]:[0-9][0-9]$","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$actual_time_of_departure)))    ## hora
#vuelos$actual_time_of_departure_minutes <- as.integer(gsub(":[0-9][0-9]$","", gsub("^[0-9][0-9]:","",gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$actual_time_of_departure))))   ## min
#vuelos$actual_time_of_departure_seconds <- as.integer(gsub("^[0-9][0-9]:[0-9][0-9]:","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$actual_time_of_departure)))   ## seg
#vuelos$actual_time_of_departure = as.Date(vuelos$actual_time_of_departure, format = "%Y/%m/%d")

##### scheduled_time_of_arrival
vuelos$scheduled_time_of_arrival_hour <- as.integer(gsub(":[0-9][0-9]:[0-9][0-9]$","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$scheduled_time_of_arrival)))    ## hora
vuelos$scheduled_time_of_arrival_minutes <- as.integer(gsub(":[0-9][0-9]$","", gsub("^[0-9][0-9]:","",gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$scheduled_time_of_arrival))))   ## min
vuelos$scheduled_time_of_arrival_seconds <- as.integer(gsub("^[0-9][0-9]:[0-9][0-9]:","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$scheduled_time_of_arrival)))   ## seg
vuelos$scheduled_time_of_arrival = as.Date(vuelos$scheduled_time_of_arrival, format = "%Y/%m/%d")

##### estimated_time_of_arrival
vuelos$estimated_time_of_arrival_hour <- as.integer(gsub(":[0-9][0-9]:[0-9][0-9]$","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$estimated_time_of_arrival)))    ## hora
vuelos$estimated_time_of_arrival_minutes <- as.integer(gsub(":[0-9][0-9]$","", gsub("^[0-9][0-9]:","",gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$estimated_time_of_arrival))))   ## min
vuelos$estimated_time_of_arrival_seconds <- as.integer(gsub("^[0-9][0-9]:[0-9][0-9]:","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$estimated_time_of_arrival)))   ## seg
vuelos$estimated_time_of_arrival = as.Date(vuelos$estimated_time_of_arrival, format = "%Y/%m/%d")

##### actual_time_of_arrival
vuelos$actual_time_of_arrival_hour <- as.integer(gsub(":[0-9][0-9]:[0-9][0-9]$","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$actual_time_of_arrival)))    ## hora
vuelos$actual_time_of_arrival_minutes <- as.integer(gsub(":[0-9][0-9]$","", gsub("^[0-9][0-9]:","",gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$actual_time_of_arrival))))   ## min
vuelos$actual_time_of_arrival_seconds <- as.integer(gsub("^[0-9][0-9]:[0-9][0-9]:","", gsub("^[0-2][0-9][0-9][0-9]-[0-1][0-9]-[0-3][0-9] ","",vuelos$actual_time_of_arrival)))   ## seg
vuelos$actual_time_of_arrival = as.Date(vuelos$actual_time_of_arrival, format = "%Y/%m/%d")





summary(vuelos)
