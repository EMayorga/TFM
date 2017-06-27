## Script para normalizar y aplicar modelos

library(ggplot2)
library(effects)
library(plyr)
library(ROCR)



#setwd("C:/Users/Emoli/Desktop/Master/TFM/Dataset") ## ruta portatil
setwd("C:/Users/sergi/Downloads/TFM-master/TFM-master/") ## ruta portatil

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


indices <- sample( 1:nrow( vuelosNormalizado ), 150000 )
muestra <- vuelosNormalizado[ indices, ]

model1 <- lm(arrival_delay ~ distance+act_blocktime+cabin_1_fitted_configuration+
               cabin_1_saleable+cabin_1_pax_boarded+cabin_1_rpk+cabin_1_ask+total_rpk+total_ask+load_factor+total_pax+
               total_no_shows+total_cabin_crew+total_technical_crew+total_baggage_weight+
               number_of_baggage_pieces+diaSemanaSalida+diaSemanaLlegada+pesosFligthNumber+
               pesosBoardPoint+pesosBoardLat+pesosBoardLon+pesosBoardCountryCode+pesosOffPoint+
               pesoOffLat+pesoOffLon+pesoOffCountryCode+pesoAircraftType+pesoRouting+
               pesoMesSalida+pesoDiaSalida+pesoHoraSalida+pesoMesLlegada+pesoDiaLlegada+
               pesoHoraLlegada, 
             na.action = na.omit, data = vuelosNormalizado)

summary(model1)





colnames(vuelosNormalizado)

model2 <-lm(arrival_delay ~ departure_delay + TAVG_o + TAVG_d ,na.action = na.omit, data = vuelosNormalizado)
summary(model2)
#fit <- lm(y ~ x1 + x2 + x3, data=mydata)

layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(model2)


#modelos de regresión linea individual

model_ind_1=lm(arrival_delay ~ departure_delay, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_1)

model_ind_2=lm(arrival_delay ~ distance, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_2)

model_ind_3=lm(arrival_delay ~ est_blocktime, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_3)

model_ind_4=lm(arrival_delay ~ act_blocktime, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_4)

model_ind_5=lm(arrival_delay ~ TMIN_o, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_5)

model_ind_6=lm(arrival_delay ~ TMIN_d, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_6)

model_ind_7=lm(arrival_delay ~ TMAX_o, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_7)

model_ind_8=lm(arrival_delay ~ TMAX_d, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_8)

model_ind_9=lm(arrival_delay ~ TAVG_o, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_9)

model_ind_10=lm(arrival_delay ~ TAVG_d, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_10)

model_ind_11=lm(arrival_delay ~ SNOW_o, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_11)

model_ind_12=lm(arrival_delay ~ SNOW_d, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_12)

model_ind_13=lm(arrival_delay ~ PRCP_o, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_13)

model_ind_14=lm(arrival_delay ~ PRCP_d, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_14)

model_ind_15=lm(arrival_delay ~ SNWD_o, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_15)

model_ind_16=lm(arrival_delay ~ SNWD_d, na.action = na.omit, data = vuelosNormalizado)
summary(model_ind_16)




#####
modelCom =lm(arrival_delay ~ ., na.action = na.omit, data = vuelosNormalizado)
summary(modelCom)

modelo =lm(arrival_delay ~ TMIN_o+TMIN_d+TMAX_o+TAVG_o+distance+departure_delay+est_blocktime+act_blocktime, data = vuelosNormalizado)
summary(modelo)
plot(modelo$residuals)
hist(modelo$residuals)
qqnorm(modelo$residuals); qqline(modelo$residuals,col=2)
confint(modelo,level=0.95) 





#regresion logistica
set.seed(1)
muestra         <- sample(nrow(vuelosNormalizado),nrow(vuelosNormalizado)*.3)
Train           <- vuelosNormalizado[-muestra,]
Test            <- vuelosNormalizado[muestra,]

model3     <- glm(arrival_delay ~., Train, family = binomial(link="logit"))
summary(model3)


Prediccion      <- round(predict(model3, newdata = Test, type = "response"))
(MC              <- table(Test[, "departure_delay"],Prediccion))   # Matriz de Confusión

 #poisson

model_poisson=glm(arrival_delay~.-TMIN_o-TMIN_d-TMAX_o-TAVG_o-distance-departure_delay-est_blocktime-act_blocktime, family=poisson(link = "log"),data=vuelosNormalizado)
summary(model_poisson)
