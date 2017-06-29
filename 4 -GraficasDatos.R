
## Archivo donde se pintaran graficas de las variables del dataset con el fin de analizarlas.

setwd("C:/Users/epifanio.mayorga/Desktop/Master/TFM/archivos_datos_drive") ## ruta curro


## Apertura del dataset
vuelos <- read.table("vuelosCompletoGraficas.csv", header = T, sep = ",")

str(vuelos)

## Eliminamos variables creadas al guardar el fichero
vuelos$X <- NULL
vuelos$index <- NULL

str(vuelos)
summary(vuelos)



## Graficas de variables
library(ggplot2)

plot(vuelosDeparted$mesLlegada, vuelosDeparted$arrival_delay)
ggplot(vuelosDeparted$mesSalida, vuelosDeparted$arrival_delay)
beanplot(vuelosDeparted$diaLlegada, vuelosDeparted$arrival_delay)


str(vuelosDeparted)

## graficas de retraso de llegada en base a variables categoricas
ggplot(vuelosDeparted,aes(airline_code,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(flight_number,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(board_point,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(board_country_code,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(off_point,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(off_country_code,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(aircraft_type,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(aircraft_registration_number,arrival_delay)) + geom_violin(scale = "count")
#### ggplot(vuelosDeparted,aes(general_status_code,arrival_delay)) + geom_violin(scale = "count") no tiene sentido
#ggplot(vuelosDeparted,aes(routing,arrival_delay)) + geom_violin(scale = "count")
#### ggplot(vuelosDeparted,aes(cabin_1_code,arrival_delay)) + geom_violin(scale = "count") no tiene sentido
ggplot(vuelosDeparted,aes(cabin_2_code,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(mesSalida,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(anyoSalida,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(diaSalida,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(horaSalida,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(mesLlegada,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(anyoLlegada,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(diaLlegada,arrival_delay)) + geom_violin(scale = "count")
#ggplot(vuelosDeparted,aes(horaLlegada,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(diaSemanaSalida,arrival_delay)) + geom_violin(scale = "count")
ggplot(vuelosDeparted,aes(diaSemanaLlegada,arrival_delay)) + geom_violin(scale = "count")


## graficas de retraso en base a variables numericas
ggplot(vuelosDeparted, aes(x = board_lat, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = board_lon, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = off_lat, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = off_lon, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = distance, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = departure_delay, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = act_blocktime, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_fitted_configuration, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_saleable, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_pax_boarded, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_rpk, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = cabin_1_ask, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = load_factor, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_pax, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_no_shows, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_cabin_crew, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_technical_crew, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = total_baggage_weight, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
ggplot(vuelosDeparted, aes(x = number_of_baggage_pieces, y = arrival_delay)) + geom_point() + geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

