## Script para normalizar y aplicar modelos

#cambiar esta ruta por donde esten los datos
#setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset") ## ruta portatil
setwd("C:/Users/sergi/Downloads/TFM-master222/TFM-master") ## ruta portatil

vuelos <- read.table("vuelosFinal.csv", header = T, sep = ",")
vuelos$X <- NULL


## 1. Normalizacion de los datos de entrada

## 1.1 Tabla de normalizacion de cada variable
obtenerTablaNormalizacion <- function(df){
  
  nombresdf <- colnames(df)
  nombres <- vector()
  maximos <- vector()
  minimos <- vector()
  
  for (i in 1:length(df)){
    nombres[i] <- nombresdf[i]
    if(is.numeric(df[,i])){
      vectorDatos <- df[,i]
      
      maximos[i] <- max(vectorDatos, na.rm = TRUE)
      minimos[i] <- min(vectorDatos, na.rm = TRUE)
    }
    else{
      maximos[i] <- 0
      minimos[i] <- 0
    }
    
  }
  maximos <- as.factor(maximos)
  minimos <- as.factor(minimos)
  
  dfaux <- as.data.frame(list(nombres,maximos,minimos), col.names = c("Columna","Maximo","Minimo"))
  return(dfaux)
  
}


## 1.2. Normalizar dataframe
## funcion que normaliza un dataframe (hay que mejorarle en los casos donde existen NAs)
normalizarDF <- function(df){
  
  ## df <- dataframe a normalizar
  for (i in 1:length(df)){
    columna <- vector()
    if(is.numeric(df[,i])){
      vectorDatos <- df[,i]
      maximo <- max(vectorDatos, na.rm = TRUE)
      minimo <- min(vectorDatos, na.rm = TRUE)
      for (j in 1:length(vectorDatos)){
        if(is.na(vectorDatos[j])){
          columna[j] = minimo
        }else{
          columna[j] = (vectorDatos[j]-minimo)/(maximo - minimo)
        }
      }
      df[,i] = columna
    }
  }
  
  return(df)
  
}


tablaVuelosNormalizados <- obtenerTablaNormalizacion(vuelos)
vuelosNormalizado <- normalizarDF(vuelos)

write.csv('tablaVuelosNormalizados.csv',x = tablaVuelosNormalizados)
write.csv('vuelosFinalNormalizado.csv',x = vuelosNormalizado)



## 2. Aplicacion de modelos
vuelosNormalizado <- read.table("vuelosNormalizado.csv", header = T, sep = ",")
vuelosNormalizado$X<-NULL
vuelosNormalizado$est_blocktime<-NULL
vuelosNormalizado$index<-NULL


###Modelo de regresión lineal del retraso de llegada.
##cogemos una muestra aleatoria
indices <- sample( 1:nrow( vuelosNormalizado ), 150000 )
muestra <- vuelosNormalizado[ indices, ]


##### modelos de regresion de variables con todas variables del dataframe
modelCom1 =lm(arrival_delay ~ ., na.action = na.omit, data = muestra)
summary(modelCom1)
modelCom2 =lm(departure_delay ~ ., na.action = na.omit, data = muestra)
summary(modelCom2)
#se puede observar que lo que más influye es el retraso de salida.



##para hacer el modelo con las variables deseadas
model1 <- lm(arrival_delay ~ departure_delay+ distance+act_blocktime+cabin_1_fitted_configuration+
               cabin_1_saleable+cabin_1_pax_boarded+cabin_1_rpk+cabin_1_ask+total_rpk+total_ask+load_factor+total_pax+
               total_no_shows+total_cabin_crew+total_technical_crew+total_baggage_weight+
               number_of_baggage_pieces+pesosFligthNumber+
               pesosBoardPoint+pesosBoardLat+pesosBoardLon+pesosBoardCountryCode+pesosOffPoint+
               pesoOffLat+pesoOffLon+pesoOffCountryCode+pesoAircraftType+pesoRouting+
               pesoMesSalida+
               TAVG_o+TAVG_d+PRCP_o+PRCP_d+SNWD_o+SNWD_d+pesoDiaSalida+pesoHoraSalida+pesoMesLlegada+pesoDiaLlegada+
               pesoHoraLlegada, 
             na.action = na.omit, data = vuelosNormalizado)

summary(model1)

model1b <- lm(arrival_delay ~ TMIN_o+TMIN_d+TMAX_o+TMAX_d+
            TAVG_o+TAVG_d+PRCP_o+PRCP_d+SNWD_o+SNWD_d, 
             na.action = na.omit, data = vuelosNormalizado)

summary(model1b)
#en este modelo se puede observar que lo que más influye en el retraso por medios atmosfericos es la temperatura media.
#si llueve también influye aunque menos
hist(model1b$residuals)
hist(model2$residuals)
plot(model2)



#regresion logistica
set.seed(1)
muestra         <- sample(nrow(vuelosNormalizado),nrow(vuelosNormalizado)*.3)
Train           <- vuelosNormalizado[-muestra,]
Test            <- vuelosNormalizado[muestra,]

model3     <- glm(arrival_delay ~., Train, family = binomial(link="logit"))
summary(model3)


Prediccion      <- round(predict(model3, newdata = Test, type = "response"))
(MC              <- table(Test[, "arrival_delay"],Prediccion))   # Matriz de Confusión





###random forest
install.packages("randomForest")
library(randomForest)


set.seed(1)
indices <- sample( 1:nrow( vuelosNormalizado ), 1000 )
muestra <- vuelosNormalizado[ indices, ]
rf <- randomForest(arrival_delay ~ .,na.action=na.omit,proximity=TRUE,
                   keep.forest=FALSE, data=muestra)
print(rf)
summary(rf)

importance(rf)#para ver que variables son mas importantes
 
MDSplot(rf, muestra$departure_delay)
 

###pca

##ELEGIR VARIABLES QUE NO SEAN NULAS  O CONSTANTES
vuelosPCA <- data.frame("TMIN_o" = vuelosNormalizado$TMIN_o, 
                  "TMIN_d" = vuelosNormalizado$TMIN_d, 
                  "TMAX_o" = vuelosNormalizado$TMAX_o,
                  "TMAX_d" = vuelosNormalizado$TMAX_d,
                  "TAVG_o" = vuelosNormalizado$TAVG_o,
                  "TAVG_d" = vuelosNormalizado$TAVG_d,                 
                  "distance" = vuelosNormalizado$distance, 
                  "departure_delay" = vuelosNormalizado$departure_delay,
                  "arrival_delay" = vuelosNormalizado$arrival_delay,
                  "act_blocktime" = vuelosNormalizado$act_blocktime,
                  "PRCP_o" = vuelosNormalizado$PRCP_o,
                  "PRCP_d" = vuelosNormalizado$PRCP_d,
                  "pesoHoraLlegada" = vuelosNormalizado$pesoHoraLlegada,
                  "pesoDiaLlegada" = vuelosNormalizado$pesoDiaLlegada,
                  "pesoMesLlegada" = vuelosNormalizado$pesoMesLlegada,
                  "pesoHoraSalida" = vuelosNormalizado$pesoHoraSalida,
                  "pesoDiaSalida" = vuelosNormalizado$pesoDiaSalida,
                  "pesoMesSalida" = vuelosNormalizado$pesoMesSalida,
                  "pesoRouting" = vuelosNormalizado$pesoRouting,
                  "pesoAircraftRegNumber" = vuelosNormalizado$pesoAircraftRegNumber,
                  "pesoAircraftType" = vuelosNormalizado$pesoAircraftType
                  
                  ) 



PCA<-prcomp(vuelosPCA[,-c(1)],scale. = TRUE)

summary(PCA)
plot(PCA)
biplot(PCA)
PCA$rotation


modelo_PCA=lm(departure_delay~PCA$x,data=vuelosPCA)
summary(modelo_PCA)










