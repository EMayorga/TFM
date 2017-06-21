
# Obtención de datos del tiempo de la web de Noaa

El objetivo de este notebook es obtener y procesar los datos del tiempo atmosférico de cada aeropuerto para cada vuelo.
A continuación se irán describiendo los pasos a ejecutar.

El primer paso es importar las librerias necesarias:


```python
import time
import pandas as pd
import numpy as np
import math
from math import cos, asin, sqrt
import gc
import os.path
pd.set_option('display.max_columns', None)
```

Se lee el fichero generado anteriormente para crear nuevas columnas.


```python
if vuelos.empty:
    
    vuelos = pd.read_csv('vuelosDeparted.csv', sep=',',low_memory=False, )
    vuelos.rename(columns={'Unnamed: 0': 'index'}, inplace=True)

    vuelos["TMIN_o"]= ''
    vuelos["TMIN_d"]= ''
    vuelos["TMAX_o"]= ''
    vuelos["TMAX_d"]= ''
    vuelos["TAVG_o"]= ''
    vuelos["TAVG_d"]= ''
    vuelos["SNOW_o"]= ''
    vuelos["SNOW_d"]= ''
    vuelos["PRCP_o"]= ''
    vuelos["PRCP_d"]= ''
    vuelos["SNWD_o"]= ''
    vuelos["SNWD_d"]= ''
    vuelos["ACMC_o"]= ''
    vuelos["ACMC_d"]= ''
    vuelos["ACSC_o"]= ''
    vuelos["ACSC_d"]= ''
    vuelos["AWDR_o"]= ''
    vuelos["AWDR_d"]= ''
    vuelos["AWND_o"]= ''
    vuelos["AWND_d"]= ''
    vuelos["EVAP_o"]= ''
    vuelos["EVAP_d"]= ''
    vuelos["FRTH_o"]= ''
    vuelos["FRTH_d"]= ''
    vuelos["TSUN_o"]= ''
    vuelos["TSUN_d"]= ''
    vuelos["WDMV_o"]= ''
    vuelos["WDMV_d"]= ''


    vuelos.to_csv('vuelos.csv', sep=',', index=False)
```

Se obtienen las estaciones metereólogicas de dónde se obtendrá el tiempo.
Hay que bajarse el siguiente fichero:
https://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt

Se puede usar el siguiente comando:
!wget http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt -O stations.txt


```python
stationstxt = ""
with open("stations.txt") as input:
    stationstxt = input.read()
    
#Extract the data from file
stations2 = stationstxt.split("\n")
#Remove last line
stations2 = stations2[:-1]
stations2 = map(lambda line: [line[0:11],float(line[13:20]),float(line[22:30]),line[41:71]], stations2)
```

A continuación se obtendrá los ficheros y cargará en un dataframe con la información de las estaciones y su localización.
Además se declaran varias funciones para calcular que estación es la más cercana a cada vuelo.

Hay que tener en cuenta que los ficheros de datos de Noaa tienen la información anual.
Por lo que hay que ir ejecutando cambiando la variable "year".


```python
start = time.time()

year = '2017'

weatherdf = pd.read_csv(year+".csv",header=None)
weatherdf.columns = ["id","date","type","Value1","Value2","Value3","Value4","Value5"]

##nos quedamos con las latitudes de las estaciones.
stationsdf = pd.DataFrame(stations2)
stationsdf.columns = ["id","lat","lng","name"]
lats = stationsdf[['lat','lng']]

#funciones para calcular la distancia entre los aeropuertos y estacion metereologica mas cercana
def distance(lat1, lon1, lat2, lon2):
    p = 0.017453292519943295
    a = 0.5 - cos((lat2-lat1)*p)/2 + cos(lat1*p)*cos(lat2*p) * (1-cos((lon2-lon1)*p)) / 2
    return 12742 * asin(sqrt(a))

def closest(data, v):
    return min(data, key=lambda p: distance(v[0],v[1],p[0],p[1]))


#para que la fecha no de problemas al comparar (quizas no este bien del todo)
def tratarFecha(fecha):
    fecha = str(fecha).split(' ')[0]
    fecha = fecha.replace('-','')
    fecha = int(fecha)
    return fecha



del weatherdf['Value3']
del weatherdf['Value4']
del weatherdf['Value5']
del weatherdf['Value2']
weather = weatherdf ##creamos bck



def obtenerEstacion2(row):
    lat = row['board_lat']
    lon = row['board_lon']
    coor = [lat,lon]
    EMC= closest(np.asarray(lats), coor)
    ##obtenemos el id de la estacion de board
    aux = stationsdf[stationsdf['lat']==EMC[0]]
    aux = stationsdf[stationsdf['lng']==EMC[1]]
    EMC = aux['id']
    s =EMC.to_string()
    stationid = str(s)
    row['stationid'] = stationid.split()[1]
    return row

def obtenerEstacion3(row):
    lat = row['off_lat']
    lon = row['off_lon']
    coor = [lat,lon]
    EMC= closest(np.asarray(lats), coor)
    ##obtenemos el id de la estacion de board
    aux = stationsdf[stationsdf['lat']==EMC[0]]
    aux = stationsdf[stationsdf['lng']==EMC[1]]
    EMC = aux['id']
    s =EMC.to_string()
    stationid = str(s)
    row['stationid'] = stationid.split()[1]
    return row

def aplicarEstacionesOrigen(row):
    row['board_stationid']= coordenadasOrigen[(coordenadasOrigen.board_lat == row['board_lat'])&(coordenadasOrigen.board_lon == row['board_lon'])]['stationid'].values[0]
    return row

def aplicarEstacionesDestino(row):
    row['off_stationid']= coordenadasDestino[(coordenadasDestino.off_lat == row['off_lat'])&(coordenadasDestino.off_lon == row['off_lon'])]['stationid'].values[0]
    return row


end = time.time()
print(end - start)
```


```python
#aplicamos y obtenemos las estaciones
if 'board_stationid' in vuelos:
    pass
else:
    coordenadasOrigen = vuelos[['board_lat','board_lon']]
    coordenadasDestino = vuelos[['off_lat','off_lon']]
    coordenadasOrigen = coordenadasOrigen.drop_duplicates(subset=['board_lat', 'board_lon'])
    coordenadasDestino = coordenadasDestino.drop_duplicates(subset=['off_lat', 'off_lon'])
    coordenadasOrigen = coordenadasOrigen.apply(lambda x:obtenerEstacion2(x),axis = 1)
    coordenadasDestino = coordenadasDestino.apply(lambda x:obtenerEstacion3(x),axis = 1)
    vuelos = vuelos.apply(lambda x: aplicarEstacionesOrigen(x),axis = 1)
    vuelos = vuelos.apply(lambda x: aplicarEstacionesDestino(x),axis = 1)
```

La siguiente función trata y junta los datos.


```python
def tratar2(row):
    
    board_station = row['board_stationid']
    off_station = row['off_stationid']
    fecha = row['actual_time_of_departure']
    fecha_d = row['actual_time_of_arrival'] 
    ##################################
    #primero tratamos las fechas
    fecha = tratarFecha(fecha)
    fecha_d = tratarFecha(fecha_d)
    #########################################################################################################
    data_board = weatherdf[(weatherdf["id"]==board_station)&(weatherdf['date']==fecha)].sort_values("date")
    data_off   = weatherdf[(weatherdf["id"]==off_station)&(weatherdf['date']==fecha_d)].sort_values("date")
    #####################################################
    data_board["Value1"]=data_board["Value1"]/10
    data_board = data_board.reset_index()
    data_off["Value1"]=data_off["Value1"]/10
    data_off = data_off.reset_index()
        #######################################################
    T1 = data_board[data_board['type']=='TMIN']['Value1']
    T2 = data_off[data_off['type']=='TMIN']['Value1']
    T3 = data_board[data_board['type']=='TMAX']['Value1']
    T4 = data_off[data_off['type']=='TMAX']['Value1']
    T5 = data_board[data_board['type']=='TAVG']['Value1']
    T6 = data_off[data_off['type']=='TAVG']['Value1']
    T7 = data_board[data_board['type']=='SNOW']['Value1']
    T8 = data_off[data_off['type']=='SNOW']['Value1']
    T9 = data_board[data_board['type']=='PRCP']['Value1']
    T10 = data_off[data_off['type']=='PRCP']['Value1']
    T11 = data_board[data_board['type']=='SNWD']['Value1']
    T12 = data_off[data_off['type']=='SNWD']['Value1']
    T13 = data_board[data_board['type']=='ACMC']['Value1']
    T14 = data_off[data_off['type']=='ACMC']['Value1']
    T17 = data_board[data_board['type']=='ACSC']['Value1']
    T18 = data_off[data_off['type']=='ACSC']['Value1']
    T21 = data_board[data_board['type']=='AWDR']['Value1']
    T22 = data_off[data_off['type']=='AWDR']['Value1']
    T23 = data_board[data_board['type']=='AWND']['Value1']
    T24 = data_off[data_off['type']=='AWND']['Value1']
    T39 = data_board[data_board['type']=='EVAP']['Value1']
    T40 = data_off[data_off['type']=='EVAP']['Value1']
    T47 = data_board[data_board['type']=='FRTH']['Value1']
    T48 = data_off[data_off['type']=='FRTH']['Value1']
    T75 = data_board[data_board['type']=='TSUN']['Value1']
    T76 = data_off[data_off['type']=='TSUN']['Value1']
    T89 = data_board[data_board['type']=='WDMV']['Value1']
    T90 = data_off[data_off['type']=='WDMV']['Value1']
    
    
    ##############################
    ##tratamos los valores nulos aplicando un valor nulo
    if T1.empty:
        T1 = 9999
    if T2.empty:
        T2 = 9999
    if T3.empty:
        T3 = 9999
    if T4.empty:
        T4 = 9999
    if T5.empty:
        T5 = 9999
    if T6.empty:
        T6 = 9999
    if T7.empty:
        T7 = 9999
    if T8.empty:
        T8 = 9999
    if T9.empty:
        T9 = 9999
    if T10.empty:
        T10 = 9999
    if T11.empty:
        T11 = 9999
    if T12.empty:
        T12 = 9999
    if T13.empty:
        T13 = 9999
    if T14.empty:
        T14 = 9999
    if T17.empty:
        T17 = 9999
    if T18.empty:
        T18 = 9999
    if T21.empty:
        T21 = 9999
    if T22.empty:
        T22 = 9999
    if T23.empty:
        T23 = 9999
    if T24.empty:
        T24 = 9999
    if T39.empty:
        T39 = 9999
    if T40.empty:
        T40 = 9999
    if T47.empty:
        T47 = 9999
    if T48.empty:
        T48 = 9999
    if T75.empty:
        T75 = 9999
    if T76.empty:
        T76 = 9999
    if T89.empty:
        T89 = 9999
    if T90.empty:
        T90 = 9999
      
        
    #actualizamos la fila
    row['TMIN_o']= float(T1)
    row['TMIN_d']= float(T2)
    row['TMAX_o']= float(T3)
    row['TMAX_d']= float(T4)
    row['TAVG_o']= float(T5)
    row['TAVG_d']= float(T6)
    row['SNOW_o']= float(T7)
    row['SNOW_d']= float(T8)
    row['PRCP_o']= float(T9)
    row['PRCP_d']= float(T10)
    row['SNWD_o']= float(T11)
    row['SNWD_d']= float(T12)
    row['ACMC_o']= float(T13)
    row['ACMC_d']= float(T14)
    row['ACSC_o']= float(T17)
    row['ACSC_d']= float(T18)
    row['AWDR_o']= float(T21)
    row['AWDR_d']= float(T22)
    row['AWND_o']= float(T23)
    row['AWND_d']= float(T24)
    row['EVAP_o']= float(T39)
    row['EVAP_d']= float(T40)
    row['FRTH_o']= float(T47)
    row['FRTH_d']= float(T48)
    row['TSUN_o']= float(T75)
    row['TSUN_d']= float(T76)
    row['WDMV_o']= float(T89)
    row['WDMV_d']= float(T90)


    return row

def functionWeatherDay(year, month, day):
    u = int(month+day)
    d = int(year*10000)
    weatherdf = weather##restauramos el bck
    weatherdf = weatherdf[weatherdf['date']-d==u]
    return weatherdf

def functionPlus(year, month, day):    
    start = time.time()
    vuelosSinTratar = vuelos[vuelos['TAVG_o'].isnull()]
    x = vuelosSinTratar[vuelosSinTratar['anyoSalida']==int(year)]
    x = x[x['mesSalida']==month]
    x = x[x['diaSalida']==day]
    x = x.apply(lambda x:tratar2(x),axis = 1)
    #para escribir ya
    #variable auxiliar

    pd.options.mode.chained_assignment = None  # default='warn'
    vuelosSinTratar['TMIN_o'] = x.set_index(['index'])['TMIN_o'].combine_first(vuelosSinTratar.set_index(['index'])['TMIN_o']).values
    vuelosSinTratar['TMIN_d'] = x.set_index(['index'])['TMIN_d'].combine_first(vuelosSinTratar.set_index(['index'])['TMIN_d']).values
    vuelosSinTratar['TMAX_o'] = x.set_index(['index'])['TMAX_o'].combine_first(vuelosSinTratar.set_index(['index'])['TMAX_o']).values
    vuelosSinTratar['TMAX_d'] = x.set_index(['index'])['TMAX_d'].combine_first(vuelosSinTratar.set_index(['index'])['TMAX_d']).values
    vuelosSinTratar['TAVG_o'] = x.set_index(['index'])['TAVG_o'].combine_first(vuelosSinTratar.set_index(['index'])['TAVG_o']).values
    vuelosSinTratar['TAVG_d'] = x.set_index(['index'])['TAVG_d'].combine_first(vuelosSinTratar.set_index(['index'])['TAVG_d']).values
    vuelosSinTratar['SNOW_o'] = x.set_index(['index'])['SNOW_o'].combine_first(vuelosSinTratar.set_index(['index'])['SNOW_o']).values
    vuelosSinTratar['SNOW_d'] = x.set_index(['index'])['SNOW_d'].combine_first(vuelosSinTratar.set_index(['index'])['SNOW_d']).values
    vuelosSinTratar['PRCP_o'] = x.set_index(['index'])['PRCP_o'].combine_first(vuelosSinTratar.set_index(['index'])['PRCP_o']).values
    vuelosSinTratar['PRCP_d'] = x.set_index(['index'])['PRCP_d'].combine_first(vuelosSinTratar.set_index(['index'])['PRCP_d']).values
    vuelosSinTratar['SNWD_o'] = x.set_index(['index'])['SNWD_o'].combine_first(vuelosSinTratar.set_index(['index'])['SNWD_o']).values
    vuelosSinTratar['SNWD_d'] = x.set_index(['index'])['SNWD_d'].combine_first(vuelosSinTratar.set_index(['index'])['SNWD_d']).values
    vuelosSinTratar['ACMC_o'] = x.set_index(['index'])['ACMC_o'].combine_first(vuelosSinTratar.set_index(['index'])['ACMC_o']).values
    vuelosSinTratar['ACMC_d'] = x.set_index(['index'])['ACMC_d'].combine_first(vuelosSinTratar.set_index(['index'])['ACMC_d']).values
    vuelosSinTratar['ACSC_o'] = x.set_index(['index'])['ACSC_o'].combine_first(vuelosSinTratar.set_index(['index'])['ACSC_o']).values
    vuelosSinTratar['ACSC_d'] = x.set_index(['index'])['ACSC_d'].combine_first(vuelosSinTratar.set_index(['index'])['ACSC_d']).values
    vuelosSinTratar['AWDR_o'] = x.set_index(['index'])['AWDR_o'].combine_first(vuelosSinTratar.set_index(['index'])['AWDR_o']).values
    vuelosSinTratar['AWDR_d'] = x.set_index(['index'])['AWDR_d'].combine_first(vuelosSinTratar.set_index(['index'])['AWDR_d']).values
    vuelosSinTratar['AWND_o'] = x.set_index(['index'])['AWND_o'].combine_first(vuelosSinTratar.set_index(['index'])['AWND_o']).values
    vuelosSinTratar['AWND_d'] = x.set_index(['index'])['AWND_d'].combine_first(vuelosSinTratar.set_index(['index'])['AWND_d']).values
    vuelosSinTratar['EVAP_o'] = x.set_index(['index'])['EVAP_o'].combine_first(vuelosSinTratar.set_index(['index'])['EVAP_o']).values
    vuelosSinTratar['EVAP_d'] = x.set_index(['index'])['EVAP_d'].combine_first(vuelosSinTratar.set_index(['index'])['EVAP_d']).values
    vuelosSinTratar['FRTH_o'] = x.set_index(['index'])['FRTH_o'].combine_first(vuelosSinTratar.set_index(['index'])['FRTH_o']).values
    vuelosSinTratar['FRTH_d'] = x.set_index(['index'])['FRTH_d'].combine_first(vuelosSinTratar.set_index(['index'])['FRTH_d']).values
    vuelosSinTratar['TSUN_o'] = x.set_index(['index'])['TSUN_o'].combine_first(vuelosSinTratar.set_index(['index'])['TSUN_o']).values
    vuelosSinTratar['TSUN_d'] = x.set_index(['index'])['TSUN_d'].combine_first(vuelosSinTratar.set_index(['index'])['TSUN_d']).values
    vuelosSinTratar['WDMV_o'] = x.set_index(['index'])['WDMV_o'].combine_first(vuelosSinTratar.set_index(['index'])['WDMV_o']).values
    vuelosSinTratar['WDMV_d'] = x.set_index(['index'])['WDMV_d'].combine_first(vuelosSinTratar.set_index(['index'])['WDMV_d']).values


    vuelos['TMIN_o'] = vuelosSinTratar.set_index(['index'])['TMIN_o'].combine_first(vuelos.set_index(['index'])['TMIN_o']).values
    vuelos['TMIN_d'] = vuelosSinTratar.set_index(['index'])['TMIN_d'].combine_first(vuelos.set_index(['index'])['TMIN_d']).values
    vuelos['TMAX_o'] = vuelosSinTratar.set_index(['index'])['TMAX_o'].combine_first(vuelos.set_index(['index'])['TMAX_o']).values
    vuelos['TMAX_d'] = vuelosSinTratar.set_index(['index'])['TMAX_d'].combine_first(vuelos.set_index(['index'])['TMAX_d']).values
    vuelos['TAVG_o'] = vuelosSinTratar.set_index(['index'])['TAVG_o'].combine_first(vuelos.set_index(['index'])['TAVG_o']).values
    vuelos['TAVG_d'] = vuelosSinTratar.set_index(['index'])['TAVG_d'].combine_first(vuelos.set_index(['index'])['TAVG_d']).values
    vuelos['SNOW_o'] = vuelosSinTratar.set_index(['index'])['SNOW_o'].combine_first(vuelos.set_index(['index'])['SNOW_o']).values
    vuelos['SNOW_d'] = vuelosSinTratar.set_index(['index'])['SNOW_d'].combine_first(vuelos.set_index(['index'])['SNOW_d']).values
    vuelos['PRCP_o'] = vuelosSinTratar.set_index(['index'])['PRCP_o'].combine_first(vuelos.set_index(['index'])['PRCP_o']).values
    vuelos['PRCP_d'] = vuelosSinTratar.set_index(['index'])['PRCP_d'].combine_first(vuelos.set_index(['index'])['PRCP_d']).values
    vuelos['SNWD_o'] = vuelosSinTratar.set_index(['index'])['SNWD_o'].combine_first(vuelos.set_index(['index'])['SNWD_o']).values
    vuelos['SNWD_d'] = vuelosSinTratar.set_index(['index'])['SNWD_d'].combine_first(vuelos.set_index(['index'])['SNWD_d']).values
    vuelos['ACMC_o'] = vuelosSinTratar.set_index(['index'])['ACMC_o'].combine_first(vuelos.set_index(['index'])['ACMC_o']).values
    vuelos['ACMC_d'] = vuelosSinTratar.set_index(['index'])['ACMC_d'].combine_first(vuelos.set_index(['index'])['ACMC_d']).values
    vuelos['ACSC_o'] = vuelosSinTratar.set_index(['index'])['ACSC_o'].combine_first(vuelos.set_index(['index'])['ACSC_o']).values
    vuelos['ACSC_d'] = vuelosSinTratar.set_index(['index'])['ACSC_d'].combine_first(vuelos.set_index(['index'])['ACSC_d']).values
    vuelos['AWDR_o'] = vuelosSinTratar.set_index(['index'])['AWDR_o'].combine_first(vuelos.set_index(['index'])['AWDR_o']).values
    vuelos['AWDR_d'] = vuelosSinTratar.set_index(['index'])['AWDR_d'].combine_first(vuelos.set_index(['index'])['AWDR_d']).values
    vuelos['AWND_o'] = vuelosSinTratar.set_index(['index'])['AWND_o'].combine_first(vuelos.set_index(['index'])['AWND_o']).values
    vuelos['AWND_d'] = vuelosSinTratar.set_index(['index'])['AWND_d'].combine_first(vuelos.set_index(['index'])['AWND_d']).values
    vuelos['EVAP_o'] = vuelosSinTratar.set_index(['index'])['EVAP_o'].combine_first(vuelos.set_index(['index'])['EVAP_o']).values
    vuelos['EVAP_d'] = vuelosSinTratar.set_index(['index'])['EVAP_d'].combine_first(vuelos.set_index(['index'])['EVAP_d']).values
    vuelos['FRTH_o'] = vuelosSinTratar.set_index(['index'])['FRTH_o'].combine_first(vuelos.set_index(['index'])['FRTH_o']).values
    vuelos['FRTH_d'] = vuelosSinTratar.set_index(['index'])['FRTH_d'].combine_first(vuelos.set_index(['index'])['FRTH_d']).values
    vuelos['TSUN_o'] = vuelosSinTratar.set_index(['index'])['TSUN_o'].combine_first(vuelos.set_index(['index'])['TSUN_o']).values
    vuelos['TSUN_d'] = vuelosSinTratar.set_index(['index'])['TSUN_d'].combine_first(vuelos.set_index(['index'])['TSUN_d']).values
    vuelos['WDMV_o'] = vuelosSinTratar.set_index(['index'])['WDMV_o'].combine_first(vuelos.set_index(['index'])['WDMV_o']).values
    vuelos['WDMV_d'] = vuelosSinTratar.set_index(['index'])['WDMV_d'].combine_first(vuelos.set_index(['index'])['WDMV_d']).values

    
    #vuelos.to_csv('vuelos.csv', sep=',', index=False)
    end = time.time()
    print(end - start)
```

La ejecución de la siguiente celda hace que se procesen todos los vuelos de los días y meses del año.
Recordar que hay que repetir lo mismo para cada año.


```python
#variables de inicio

dia = 1
mes = 1
anyo = 2017
for mes in range(1,13):
    print 'empiezo el mes', mes
    mesw = str(mes)
    for dia in range(1,32):
        print 'empiezo el dia - ' ,dia
        diaw = str(dia)
        if dia < 10:
            diaw = '0'+diaw

        weatherdf = functionWeatherDay(anyo,mesw,diaw)
        functionPlus(year,mes,dia)
```


```python
vuelos.to_csv('vuelos.csv', sep=',', index=False)
```

En este punto se han procesado todos los vuelos. Pero nos encontramos con el problema de tener demasiados nulos. Es decir, vuelos sin datos del tiempo. Entonces se ha decidido buscar la siguiente estación más cercana para disminuir este problema.

# Segunda parte 


```python
def getLatstation(row):
    row['lat'] = stationsdf[stationsdf['id']==row['id']]['lat'].values[0]
    row['lng'] = stationsdf[stationsdf['id']==row['id']]['lng'].values[0]
    return row

def obtenerEstacionBoard(row):
    lat = row['board_lat']
    lon = row['board_lon']
    coor = [lat,lon]
    EMC= closest(np.asarray(lista), coor)
    EMC[0] = round(EMC[0],3)
    EMC[1] = round(EMC[1],3)
    ##obtenemos el id de la estacion de board
    aux = stationsdf[(stationsdf.lat==EMC[0])|(stationsdf.lng==EMC[1])]
    EMC = aux['id']
    s = EMC.to_string()
    stationid = str(s)
    row['stationid'] = stationid.split()[1]
    return row


def aplicarEstacionesOrigen(row):
    n = 'board_stationid_o_'+var
    row[n] = coordenadasOrigen[(coordenadasOrigen.board_lat == row['board_lat'])&(coordenadasOrigen.board_lon == row['board_lon'])]['stationid'].values[0]
    return row

def obtenerEstacionOff(row):
    lat = row['off_lat']
    lon = row['off_lon']
    coor = [lat,lon]
    EMC= closest(np.asarray(lista), coor)
    EMC[0] = round(EMC[0],3)
    EMC[1] = round(EMC[1],3)
    ##obtenemos el id de la estacion de board
    aux = stationsdf[(stationsdf.lat==EMC[0])|(stationsdf.lng==EMC[1])]
    EMC = aux['id']
    s = EMC.to_string()
    stationid = str(s)
    row['stationid'] = stationid.split()[1]
    return row

def aplicarEstacionesDestino(row):
    n = 'off_stationid_d_'+var
    row[n] = coordenadasDestino[(coordenadasDestino.off_lat == row['off_lat'])&(coordenadasDestino.off_lon == row['off_lon'])]['stationid'].values[0]
    return row

def roundF(row):
    row['lat'] = round(row['lat'],3)
    return row

def roundFF(row):
    row['lng'] = round(row['lng'],3)
    return row


def obtenerDatoEstacion(row):
    if var_.split('_')[1]=='o':
        u = 'board_stationid_o_'+ var
    else:
        u = 'off_stationid_d_'+ var
    
    board_station = row[u]
    fechaAux = tratarFecha(row['actual_time_of_departure'])
    x = stationsX[stationsX.date == fechaAux]
    if x.empty:
        pass
    else:
        x= x[x.id == board_station]
        if x.empty:
            pass
        
        else:
            row[var_] = float(x.Value1.values[0])/10
            
    del x
    return row

def functionGest(year, month, day):
    
    vuelosSinTratar = vuelos[vuelos[var_]==9999.0]
    x = vuelosSinTratar[vuelosSinTratar['anyoSalida']==year]
    x = x[x['mesSalida']==month]
    x = x[x['diaSalida']==day]
    x = x.apply(lambda x:obtenerDatoEstacion(x),axis = 1)
    pd.options.mode.chained_assignment = None
    vuelosSinTratar[var_] = x.set_index(['index'])[var_].combine_first(vuelosSinTratar.set_index(['index'])[var_]).values
    vuelos[var_] = vuelosSinTratar.set_index(['index'])[var_].combine_first(vuelos.set_index(['index'])[var_]).values
```

Como en pasos anteriores la siguiente celda habrá que modificarla y ejecutar los siguientes pasos varias veces. Una para cada dato a procesar.


```python
stationstxt = ""
with open("stations.txt") as input:
    stationstxt = input.read()

stations2 = stationstxt.split("\n")
stations2 = stations2[:-1]
stations2 = map(lambda line: [line[0:11],float(line[13:20]),float(line[22:30]),line[41:71]], stations2)

year = '2017'
#########################
var_ = "PRCP_o"
#var_ = "PRCP_d"
#var_ = "TAVG_o"
#var_ = "TAVG_d"
#var_ = "TMAX_o"
#var_ = "TMAX_d"
#var_ = "TMIN_o"
#var_ = "TMIN_d"
########################
var = var_.split("_")[0]
stationsX = weatherdf[weatherdf["type"]==var]
stationsX = stationsX.sort_values(by=['id'])
```


```python
#suele tardar un poco.

f = 'lista'+var+year+'.csv'

if os.path.exists(f):
    lista = pd.read_csv(f,sep = ',')
    del lista['id']
else:
    lista = stationsX['id'].unique()
    lista = pd.DataFrame(lista)
    lista.columns = ['id']
    lista = lista.apply(lambda x:getLatstation(x),axis=1)
    lista.to_csv(f, sep=',', index=False)
    del lista['id']
```


```python
#suele tardar un poco
    
m = 'board_stationid_o_'+var
if m in vuelos:
    pass
else:
    stationsdf = stationsdf.apply(lambda x: roundF(x),axis = 1)
    stationsdf = stationsdf.apply(lambda x: roundFF(x),axis = 1)

    coordenadasOrigen = vuelos[['board_lat','board_lon']]
    coordenadasOrigen = coordenadasOrigen.drop_duplicates(subset=['board_lat', 'board_lon'])
    coordenadasOrigen = coordenadasOrigen.apply(lambda x:obtenerEstacionBoard(x),axis = 1)
    vuelos = vuelos.apply(lambda x: aplicarEstacionesOrigen(x),axis = 1)
    
vuelos.to_csv('vuelos.csv', sep=',', index=False)
```


```python
#suele tardar
m = 'off_stationid_d_'+var
if m in vuelos:
    pass
else:
    stationsdf = stationsdf.apply(lambda x: roundF(x),axis = 1)
    stationsdf = stationsdf.apply(lambda x: roundFF(x),axis = 1)

    coordenadasDestino = vuelos[['off_lat','off_lon']]
    coordenadasDestino = coordenadasDestino.drop_duplicates(subset=['off_lat', 'off_lon'])
    coordenadasDestino = coordenadasDestino.apply(lambda x:obtenerEstacionOff(x),axis = 1)
    vuelos = vuelos.apply(lambda x: aplicarEstacionesDestino(x),axis = 1)
```

Los siguientes bucles repasan día a día los vuelos del año y rellenan los datos.


```python
vuelos.to_csv('vuelos.csv', sep=',', index=False)
year2 = int(year)
for mes in range(1,13):
    print 'empiezo el mes', mes
    mesw = str(mes)
    for dia in range(1,32):
        print 'empiezo el dia - ' ,dia
        diaw = str(dia)
        if dia < 10:
            diaw = '0'+diaw

        functionGest(year2,mes,dia)
        
vuelos.to_csv('vuelos.csv', sep=',', index=False) 
```


```python
del vuelos['ACMC_o']
del vuelos['ACMC_d']
del vuelos['ACSC_o']
del vuelos['ACSC_d']
del vuelos['AWDR_o']
del vuelos['AWDR_d']
del vuelos['AWND_o']
del vuelos['AWND_d']
del vuelos['EVAP_o']
del vuelos['EVAP_d']
del vuelos['FRTH_o']
del vuelos['FRTH_d']
del vuelos['TSUN_o']
del vuelos['TSUN_d']
del vuelos['WDMV_o']
del vuelos['WDMV_d']
del vuelos['board_stationid']
del vuelos['off_stationid']
del vuelos['board_stationid_o_TMIN']
del vuelos['board_stationid_o_TMAX']
del vuelos['board_stationid_o_TAVG']
del vuelos['board_stationid_o_PRCP']
del vuelos['off_stationid_d_PRCP']
del vuelos['off_stationid_d_TAVG']
del vuelos['off_stationid_d_TMAX']
del vuelos['off_stationid_d_TMIN']
del vuelos['SNWD_d']
del vuelos['SNWD_o']
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>index</th>
      <th>airline_code</th>
      <th>flight_number</th>
      <th>board_point</th>
      <th>board_lat</th>
      <th>board_lon</th>
      <th>board_country_code</th>
      <th>off_point</th>
      <th>off_lat</th>
      <th>off_lon</th>
      <th>off_country_code</th>
      <th>distance</th>
      <th>scheduled_time_of_departure</th>
      <th>actual_time_of_departure</th>
      <th>scheduled_time_of_arrival</th>
      <th>actual_time_of_arrival</th>
      <th>departure_delay</th>
      <th>arrival_delay</th>
      <th>sched_blocktime</th>
      <th>est_blocktime</th>
      <th>act_blocktime</th>
      <th>aircraft_type</th>
      <th>aircraft_registration_number</th>
      <th>general_status_code</th>
      <th>routing</th>
      <th>cabin_1_code</th>
      <th>cabin_1_fitted_configuration</th>
      <th>cabin_1_saleable</th>
      <th>cabin_1_pax_boarded</th>
      <th>cabin_1_rpk</th>
      <th>cabin_1_ask</th>
      <th>cabin_2_code</th>
      <th>cabin_2_fitted_configuration</th>
      <th>cabin_2_saleable</th>
      <th>cabin_2_pax_boarded</th>
      <th>cabin_2_rpk</th>
      <th>cabin_2_ask</th>
      <th>total_rpk</th>
      <th>total_ask</th>
      <th>load_factor</th>
      <th>total_pax</th>
      <th>total_no_shows</th>
      <th>total_cabin_crew</th>
      <th>total_technical_crew</th>
      <th>total_baggage_weight</th>
      <th>number_of_baggage_pieces</th>
      <th>mesSalida</th>
      <th>anyoSalida</th>
      <th>diaSalida</th>
      <th>horaSalida</th>
      <th>mesLlegada</th>
      <th>anyoLlegada</th>
      <th>diaLlegada</th>
      <th>horaLlegada</th>
      <th>diaSemanaSalida</th>
      <th>diaSemanaLlegada</th>
      <th>flightNumberCode</th>
      <th>TMIN_o</th>
      <th>TMIN_d</th>
      <th>TMAX_o</th>
      <th>TMAX_d</th>
      <th>TAVG_o</th>
      <th>TAVG_d</th>
      <th>SNOW_o</th>
      <th>SNOW_d</th>
      <th>PRCP_o</th>
      <th>PRCP_d</th>
      <th>SNWD_o</th>
      <th>SNWD_d</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>2</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-05-27 16:45:00</td>
      <td>2016-05-27 16:54:00</td>
      <td>2016-05-27 20:30:00</td>
      <td>2016-05-27 20:46:00</td>
      <td>9</td>
      <td>16</td>
      <td>225</td>
      <td>NaN</td>
      <td>232</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>222</td>
      <td>425593</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>425593</td>
      <td>435179</td>
      <td>0.977974</td>
      <td>222</td>
      <td>2</td>
      <td>5</td>
      <td>2</td>
      <td>2615</td>
      <td>192</td>
      <td>5</td>
      <td>2016</td>
      <td>27</td>
      <td>16:54:00</td>
      <td>5</td>
      <td>2016</td>
      <td>27</td>
      <td>20:46:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>15.2</td>
      <td>6.9</td>
      <td>24.3</td>
      <td>13.5</td>
      <td>18.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>3</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-06-03 16:45:00</td>
      <td>2016-06-03 16:55:00</td>
      <td>2016-06-03 20:30:00</td>
      <td>2016-06-03 20:43:00</td>
      <td>10</td>
      <td>13</td>
      <td>225</td>
      <td>NaN</td>
      <td>228</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>209</td>
      <td>400671</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>400671</td>
      <td>435179</td>
      <td>0.920705</td>
      <td>209</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2613</td>
      <td>182</td>
      <td>6</td>
      <td>2016</td>
      <td>3</td>
      <td>16:55:00</td>
      <td>6</td>
      <td>2016</td>
      <td>3</td>
      <td>20:43:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>9.4</td>
      <td>13.6</td>
      <td>25.1</td>
      <td>22.6</td>
      <td>17.4</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.3</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>4</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-06-10 17:00:00</td>
      <td>2016-06-10 17:15:00</td>
      <td>2016-06-10 20:45:00</td>
      <td>2016-06-10 21:12:00</td>
      <td>15</td>
      <td>27</td>
      <td>225</td>
      <td>NaN</td>
      <td>237</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>202</td>
      <td>387252</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>387252</td>
      <td>435179</td>
      <td>0.889868</td>
      <td>202</td>
      <td>6</td>
      <td>5</td>
      <td>2</td>
      <td>2302</td>
      <td>168</td>
      <td>6</td>
      <td>2016</td>
      <td>10</td>
      <td>17:15:00</td>
      <td>6</td>
      <td>2016</td>
      <td>10</td>
      <td>21:12:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>13.8</td>
      <td>8.1</td>
      <td>24.1</td>
      <td>13.3</td>
      <td>16.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>5</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-06-17 17:00:00</td>
      <td>2016-06-17 17:23:00</td>
      <td>2016-06-17 20:45:00</td>
      <td>2016-06-17 21:03:00</td>
      <td>23</td>
      <td>18</td>
      <td>225</td>
      <td>205.0</td>
      <td>220</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>226</td>
      <td>433262</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>433262</td>
      <td>435179</td>
      <td>0.995595</td>
      <td>226</td>
      <td>10</td>
      <td>5</td>
      <td>2</td>
      <td>2680</td>
      <td>195</td>
      <td>6</td>
      <td>2016</td>
      <td>17</td>
      <td>17:23:00</td>
      <td>6</td>
      <td>2016</td>
      <td>17</td>
      <td>21:03:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>9999.0</td>
      <td>10.5</td>
      <td>21.4</td>
      <td>17.2</td>
      <td>12.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>6</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-06-24 17:00:00</td>
      <td>2016-06-24 17:05:00</td>
      <td>2016-06-24 20:45:00</td>
      <td>2016-06-24 21:04:00</td>
      <td>5</td>
      <td>19</td>
      <td>225</td>
      <td>NaN</td>
      <td>239</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>189</td>
      <td>362329</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>362329</td>
      <td>435179</td>
      <td>0.832599</td>
      <td>189</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2282</td>
      <td>166</td>
      <td>6</td>
      <td>2016</td>
      <td>24</td>
      <td>17:05:00</td>
      <td>6</td>
      <td>2016</td>
      <td>24</td>
      <td>21:04:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>9999.0</td>
      <td>14.0</td>
      <td>28.3</td>
      <td>16.5</td>
      <td>19.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.5</td>
      <td>30.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>7</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-07-01 17:00:00</td>
      <td>2016-07-01 17:04:00</td>
      <td>2016-07-01 20:45:00</td>
      <td>2016-07-01 20:59:00</td>
      <td>4</td>
      <td>14</td>
      <td>225</td>
      <td>NaN</td>
      <td>235</td>
      <td>75W</td>
      <td>XNAAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>226</td>
      <td>433262</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>433262</td>
      <td>435179</td>
      <td>0.995595</td>
      <td>226</td>
      <td>4</td>
      <td>5</td>
      <td>2</td>
      <td>2527</td>
      <td>194</td>
      <td>7</td>
      <td>2016</td>
      <td>1</td>
      <td>17:04:00</td>
      <td>7</td>
      <td>2016</td>
      <td>1</td>
      <td>20:59:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>13.0</td>
      <td>11.8</td>
      <td>25.0</td>
      <td>15.1</td>
      <td>18.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.5</td>
      <td>8.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>8</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-07-08 17:00:00</td>
      <td>2016-07-08 17:17:00</td>
      <td>2016-07-08 20:45:00</td>
      <td>2016-07-08 21:11:00</td>
      <td>17</td>
      <td>26</td>
      <td>225</td>
      <td>225.0</td>
      <td>234</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>226</td>
      <td>433262</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>433262</td>
      <td>435179</td>
      <td>0.995595</td>
      <td>226</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2598</td>
      <td>201</td>
      <td>7</td>
      <td>2016</td>
      <td>8</td>
      <td>17:17:00</td>
      <td>7</td>
      <td>2016</td>
      <td>8</td>
      <td>21:11:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>18.5</td>
      <td>10.0</td>
      <td>28.0</td>
      <td>17.9</td>
      <td>22.2</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>3.8</td>
      <td>0.2</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>9</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-07-15 17:00:00</td>
      <td>2016-07-15 23:53:00</td>
      <td>2016-07-15 20:45:00</td>
      <td>2016-07-16 03:27:00</td>
      <td>53</td>
      <td>42</td>
      <td>225</td>
      <td>235.0</td>
      <td>214</td>
      <td>75W</td>
      <td>XNAAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>224</td>
      <td>429428</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>429428</td>
      <td>435179</td>
      <td>0.986784</td>
      <td>224</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2593</td>
      <td>191</td>
      <td>7</td>
      <td>2016</td>
      <td>15</td>
      <td>23:53:00</td>
      <td>7</td>
      <td>2016</td>
      <td>16</td>
      <td>03:27:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>7.0</td>
      <td>11.9</td>
      <td>23.0</td>
      <td>16.2</td>
      <td>15.4</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>2.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>10</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-07-22 17:00:00</td>
      <td>2016-07-22 17:02:00</td>
      <td>2016-07-22 20:45:00</td>
      <td>2016-07-22 20:40:00</td>
      <td>2</td>
      <td>-5</td>
      <td>225</td>
      <td>NaN</td>
      <td>218</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>214</td>
      <td>410257</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>410257</td>
      <td>435179</td>
      <td>0.942731</td>
      <td>214</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2367</td>
      <td>179</td>
      <td>7</td>
      <td>2016</td>
      <td>22</td>
      <td>17:02:00</td>
      <td>7</td>
      <td>2016</td>
      <td>22</td>
      <td>20:40:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>9999.0</td>
      <td>14.9</td>
      <td>22.3</td>
      <td>18.1</td>
      <td>18.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>12.4</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>11</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-07-29 17:00:00</td>
      <td>2016-07-29 17:43:00</td>
      <td>2016-07-29 20:45:00</td>
      <td>2016-07-29 21:17:00</td>
      <td>43</td>
      <td>32</td>
      <td>225</td>
      <td>235.0</td>
      <td>214</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>222</td>
      <td>425593</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>425593</td>
      <td>435179</td>
      <td>0.977974</td>
      <td>222</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2482</td>
      <td>184</td>
      <td>7</td>
      <td>2016</td>
      <td>29</td>
      <td>17:43:00</td>
      <td>7</td>
      <td>2016</td>
      <td>29</td>
      <td>21:17:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>12.5</td>
      <td>11.2</td>
      <td>29.7</td>
      <td>16.3</td>
      <td>21.3</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>3.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>12</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-08-05 17:00:00</td>
      <td>2016-08-05 17:01:00</td>
      <td>2016-08-05 20:45:00</td>
      <td>2016-08-05 20:50:00</td>
      <td>1</td>
      <td>5</td>
      <td>225</td>
      <td>NaN</td>
      <td>229</td>
      <td>75W</td>
      <td>XNFAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>226</td>
      <td>433262</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>433262</td>
      <td>435179</td>
      <td>0.995595</td>
      <td>226</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2426</td>
      <td>203</td>
      <td>8</td>
      <td>2016</td>
      <td>5</td>
      <td>17:01:00</td>
      <td>8</td>
      <td>2016</td>
      <td>5</td>
      <td>20:50:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>14.4</td>
      <td>14.1</td>
      <td>24.1</td>
      <td>17.5</td>
      <td>18.7</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>16.0</td>
      <td>1.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>13</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-08-12 17:00:00</td>
      <td>2016-08-12 17:26:00</td>
      <td>2016-08-12 20:45:00</td>
      <td>2016-08-12 21:07:00</td>
      <td>26</td>
      <td>22</td>
      <td>225</td>
      <td>225.0</td>
      <td>221</td>
      <td>75W</td>
      <td>XNAAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>227</td>
      <td>435179</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>435179</td>
      <td>435179</td>
      <td>1.000000</td>
      <td>227</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2756</td>
      <td>214</td>
      <td>8</td>
      <td>2016</td>
      <td>12</td>
      <td>17:26:00</td>
      <td>8</td>
      <td>2016</td>
      <td>12</td>
      <td>21:07:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>8.9</td>
      <td>8.6</td>
      <td>28.2</td>
      <td>14.7</td>
      <td>18.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>22.2</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>12</th>
      <td>14</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-08-19 17:00:00</td>
      <td>2016-08-19 17:02:00</td>
      <td>2016-08-19 20:45:00</td>
      <td>2016-08-19 20:47:00</td>
      <td>2</td>
      <td>2</td>
      <td>225</td>
      <td>NaN</td>
      <td>225</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>224</td>
      <td>429428</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>429428</td>
      <td>435179</td>
      <td>0.986784</td>
      <td>224</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2868</td>
      <td>212</td>
      <td>8</td>
      <td>2016</td>
      <td>19</td>
      <td>17:02:00</td>
      <td>8</td>
      <td>2016</td>
      <td>19</td>
      <td>20:47:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>12.0</td>
      <td>12.8</td>
      <td>32.2</td>
      <td>16.9</td>
      <td>22.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>13</th>
      <td>15</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-08-26 17:00:00</td>
      <td>2016-08-26 16:59:00</td>
      <td>2016-08-26 20:45:00</td>
      <td>2016-08-26 20:53:00</td>
      <td>-1</td>
      <td>8</td>
      <td>225</td>
      <td>NaN</td>
      <td>234</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>179</td>
      <td>343159</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>343159</td>
      <td>435179</td>
      <td>0.788546</td>
      <td>179</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2050</td>
      <td>167</td>
      <td>8</td>
      <td>2016</td>
      <td>26</td>
      <td>16:59:00</td>
      <td>8</td>
      <td>2016</td>
      <td>26</td>
      <td>20:53:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>15.8</td>
      <td>13.6</td>
      <td>31.1</td>
      <td>15.8</td>
      <td>22.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>35.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>14</th>
      <td>16</td>
      <td>XX</td>
      <td>5354</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>1917</td>
      <td>2016-09-02 16:45:00</td>
      <td>2016-09-02 16:42:00</td>
      <td>2016-09-02 20:30:00</td>
      <td>2016-09-02 20:25:00</td>
      <td>-3</td>
      <td>-5</td>
      <td>225</td>
      <td>NaN</td>
      <td>223</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>LEU-HAU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>0</td>
      <td>0</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0</td>
      <td>435179</td>
      <td>0.000000</td>
      <td>0</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>9</td>
      <td>2016</td>
      <td>2</td>
      <td>16:42:00</td>
      <td>9</td>
      <td>2016</td>
      <td>2</td>
      <td>20:25:00</td>
      <td>viernes</td>
      <td>viernes</td>
      <td>3</td>
      <td>12.9</td>
      <td>13.0</td>
      <td>32.2</td>
      <td>15.8</td>
      <td>22.1</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>6.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>15</th>
      <td>17</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-05-20 20:30:00</td>
      <td>2016-05-20 20:55:00</td>
      <td>2016-05-21 00:15:00</td>
      <td>2016-05-21 00:40:00</td>
      <td>25</td>
      <td>25</td>
      <td>225</td>
      <td>219.0</td>
      <td>225</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>0</td>
      <td>0</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0</td>
      <td>435179</td>
      <td>0.000000</td>
      <td>0</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>5</td>
      <td>2016</td>
      <td>20</td>
      <td>20:55:00</td>
      <td>5</td>
      <td>2016</td>
      <td>21</td>
      <td>00:40:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>9.7</td>
      <td>7.8</td>
      <td>10.9</td>
      <td>22.1</td>
      <td>9999.0</td>
      <td>15.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>7.6</td>
      <td>0.3</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>16</th>
      <td>18</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-05-27 20:30:00</td>
      <td>2016-05-27 20:40:00</td>
      <td>2016-05-28 00:15:00</td>
      <td>2016-05-28 00:15:00</td>
      <td>10</td>
      <td>0</td>
      <td>225</td>
      <td>NaN</td>
      <td>215</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>14</td>
      <td>26839</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>26839</td>
      <td>435179</td>
      <td>0.061674</td>
      <td>14</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2353</td>
      <td>181</td>
      <td>5</td>
      <td>2016</td>
      <td>27</td>
      <td>20:40:00</td>
      <td>5</td>
      <td>2016</td>
      <td>28</td>
      <td>00:15:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>6.9</td>
      <td>15.2</td>
      <td>13.5</td>
      <td>24.3</td>
      <td>9999.0</td>
      <td>18.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>17</th>
      <td>19</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-06-03 20:30:00</td>
      <td>2016-06-03 20:36:00</td>
      <td>2016-06-04 00:15:00</td>
      <td>2016-06-04 00:23:00</td>
      <td>6</td>
      <td>8</td>
      <td>225</td>
      <td>NaN</td>
      <td>227</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>27</td>
      <td>51761</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>51761</td>
      <td>435179</td>
      <td>0.118943</td>
      <td>27</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3020</td>
      <td>193</td>
      <td>6</td>
      <td>2016</td>
      <td>3</td>
      <td>20:36:00</td>
      <td>6</td>
      <td>2016</td>
      <td>4</td>
      <td>00:23:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>13.6</td>
      <td>9.4</td>
      <td>22.6</td>
      <td>25.1</td>
      <td>9999.0</td>
      <td>17.4</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.3</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>18</th>
      <td>20</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-06-10 20:45:00</td>
      <td>2016-06-10 21:10:00</td>
      <td>2016-06-11 00:30:00</td>
      <td>2016-06-11 01:01:00</td>
      <td>25</td>
      <td>31</td>
      <td>225</td>
      <td>240.0</td>
      <td>231</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>41</td>
      <td>78601</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>78601</td>
      <td>435179</td>
      <td>0.180617</td>
      <td>41</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3053</td>
      <td>189</td>
      <td>6</td>
      <td>2016</td>
      <td>10</td>
      <td>21:10:00</td>
      <td>6</td>
      <td>2016</td>
      <td>11</td>
      <td>01:01:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>8.1</td>
      <td>13.8</td>
      <td>13.3</td>
      <td>24.1</td>
      <td>9999.0</td>
      <td>16.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>19</th>
      <td>21</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-06-17 20:45:00</td>
      <td>2016-06-17 21:00:00</td>
      <td>2016-06-18 00:30:00</td>
      <td>2016-06-18 00:46:00</td>
      <td>15</td>
      <td>16</td>
      <td>225</td>
      <td>NaN</td>
      <td>226</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>29</td>
      <td>55596</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>55596</td>
      <td>435179</td>
      <td>0.127753</td>
      <td>29</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2685</td>
      <td>174</td>
      <td>6</td>
      <td>2016</td>
      <td>17</td>
      <td>21:00:00</td>
      <td>6</td>
      <td>2016</td>
      <td>18</td>
      <td>00:46:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>10.5</td>
      <td>9999.0</td>
      <td>17.2</td>
      <td>21.4</td>
      <td>9999.0</td>
      <td>12.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>20</th>
      <td>22</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-06-24 20:45:00</td>
      <td>2016-06-24 21:33:00</td>
      <td>2016-06-25 00:30:00</td>
      <td>2016-06-25 01:05:00</td>
      <td>48</td>
      <td>35</td>
      <td>225</td>
      <td>NaN</td>
      <td>212</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>39</td>
      <td>74766</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>74766</td>
      <td>435179</td>
      <td>0.171806</td>
      <td>39</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3227</td>
      <td>210</td>
      <td>6</td>
      <td>2016</td>
      <td>24</td>
      <td>21:33:00</td>
      <td>6</td>
      <td>2016</td>
      <td>25</td>
      <td>01:05:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>14.0</td>
      <td>9999.0</td>
      <td>16.5</td>
      <td>28.3</td>
      <td>9999.0</td>
      <td>19.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>30.8</td>
      <td>0.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>21</th>
      <td>23</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-07-01 20:45:00</td>
      <td>2016-07-01 20:54:00</td>
      <td>2016-07-02 00:30:00</td>
      <td>2016-07-02 00:43:00</td>
      <td>9</td>
      <td>13</td>
      <td>225</td>
      <td>NaN</td>
      <td>229</td>
      <td>75W</td>
      <td>XNAAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>26</td>
      <td>49844</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>49844</td>
      <td>435179</td>
      <td>0.114537</td>
      <td>26</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>2317</td>
      <td>148</td>
      <td>7</td>
      <td>2016</td>
      <td>1</td>
      <td>20:54:00</td>
      <td>7</td>
      <td>2016</td>
      <td>2</td>
      <td>00:43:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>11.8</td>
      <td>13.0</td>
      <td>15.1</td>
      <td>25.0</td>
      <td>9999.0</td>
      <td>18.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>8.8</td>
      <td>0.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>22</th>
      <td>24</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-07-08 20:45:00</td>
      <td>2016-07-08 21:23:00</td>
      <td>2016-07-09 00:30:00</td>
      <td>2016-07-09 01:03:00</td>
      <td>38</td>
      <td>33</td>
      <td>225</td>
      <td>NaN</td>
      <td>220</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>26</td>
      <td>49844</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>49844</td>
      <td>435179</td>
      <td>0.114537</td>
      <td>26</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3166</td>
      <td>203</td>
      <td>7</td>
      <td>2016</td>
      <td>8</td>
      <td>21:23:00</td>
      <td>7</td>
      <td>2016</td>
      <td>9</td>
      <td>01:03:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>10.0</td>
      <td>18.5</td>
      <td>17.9</td>
      <td>28.0</td>
      <td>9999.0</td>
      <td>22.2</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.2</td>
      <td>3.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>23</th>
      <td>25</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-07-15 20:45:00</td>
      <td>2016-07-16 03:35:00</td>
      <td>2016-07-16 00:30:00</td>
      <td>2016-07-16 07:14:00</td>
      <td>50</td>
      <td>44</td>
      <td>225</td>
      <td>235.0</td>
      <td>219</td>
      <td>75W</td>
      <td>XNAAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>35</td>
      <td>67098</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>67098</td>
      <td>435179</td>
      <td>0.154185</td>
      <td>35</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3147</td>
      <td>207</td>
      <td>7</td>
      <td>2016</td>
      <td>16</td>
      <td>03:35:00</td>
      <td>7</td>
      <td>2016</td>
      <td>16</td>
      <td>07:14:00</td>
      <td>s�bado</td>
      <td>s�bado</td>
      <td>3</td>
      <td>12.0</td>
      <td>7.4</td>
      <td>16.4</td>
      <td>25.9</td>
      <td>9999.0</td>
      <td>17.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>13.6</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>24</th>
      <td>26</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-07-22 20:45:00</td>
      <td>2016-07-22 20:45:00</td>
      <td>2016-07-23 00:30:00</td>
      <td>2016-07-23 00:39:00</td>
      <td>0</td>
      <td>9</td>
      <td>225</td>
      <td>NaN</td>
      <td>234</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>32</td>
      <td>61347</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>61347</td>
      <td>435179</td>
      <td>0.140969</td>
      <td>32</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3196</td>
      <td>203</td>
      <td>7</td>
      <td>2016</td>
      <td>22</td>
      <td>20:45:00</td>
      <td>7</td>
      <td>2016</td>
      <td>23</td>
      <td>00:39:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>14.9</td>
      <td>9999.0</td>
      <td>18.1</td>
      <td>22.3</td>
      <td>9999.0</td>
      <td>18.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>12.4</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>25</th>
      <td>27</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-07-29 20:45:00</td>
      <td>2016-07-29 21:12:00</td>
      <td>2016-07-30 00:30:00</td>
      <td>2016-07-30 01:16:00</td>
      <td>27</td>
      <td>46</td>
      <td>225</td>
      <td>240.0</td>
      <td>244</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>24</td>
      <td>46010</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>46010</td>
      <td>435179</td>
      <td>0.105727</td>
      <td>24</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3217</td>
      <td>200</td>
      <td>7</td>
      <td>2016</td>
      <td>29</td>
      <td>21:12:00</td>
      <td>7</td>
      <td>2016</td>
      <td>30</td>
      <td>01:16:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>11.2</td>
      <td>12.5</td>
      <td>16.3</td>
      <td>29.7</td>
      <td>9999.0</td>
      <td>21.3</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>3.9</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>26</th>
      <td>28</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-08-05 20:45:00</td>
      <td>2016-08-05 20:50:00</td>
      <td>2016-08-06 00:30:00</td>
      <td>2016-08-06 00:40:00</td>
      <td>5</td>
      <td>10</td>
      <td>225</td>
      <td>NaN</td>
      <td>230</td>
      <td>75W</td>
      <td>XNFAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>35</td>
      <td>67098</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>67098</td>
      <td>435179</td>
      <td>0.154185</td>
      <td>35</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3117</td>
      <td>194</td>
      <td>8</td>
      <td>2016</td>
      <td>5</td>
      <td>20:50:00</td>
      <td>8</td>
      <td>2016</td>
      <td>6</td>
      <td>00:40:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>14.1</td>
      <td>14.4</td>
      <td>17.5</td>
      <td>24.1</td>
      <td>9999.0</td>
      <td>18.7</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>1.0</td>
      <td>16.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>27</th>
      <td>29</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-08-12 20:45:00</td>
      <td>2016-08-12 21:19:00</td>
      <td>2016-08-13 00:30:00</td>
      <td>2016-08-13 01:06:00</td>
      <td>34</td>
      <td>36</td>
      <td>225</td>
      <td>225.0</td>
      <td>227</td>
      <td>75W</td>
      <td>XNAAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>16</td>
      <td>30673</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>30673</td>
      <td>435179</td>
      <td>0.070485</td>
      <td>16</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3071</td>
      <td>204</td>
      <td>8</td>
      <td>2016</td>
      <td>12</td>
      <td>21:19:00</td>
      <td>8</td>
      <td>2016</td>
      <td>13</td>
      <td>01:06:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>8.6</td>
      <td>8.9</td>
      <td>14.7</td>
      <td>28.2</td>
      <td>9999.0</td>
      <td>18.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>22.2</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>28</th>
      <td>30</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-08-19 20:45:00</td>
      <td>2016-08-19 20:58:00</td>
      <td>2016-08-20 00:30:00</td>
      <td>2016-08-20 00:34:00</td>
      <td>13</td>
      <td>4</td>
      <td>225</td>
      <td>NaN</td>
      <td>216</td>
      <td>75W</td>
      <td>XNEAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>11</td>
      <td>21088</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>21088</td>
      <td>435179</td>
      <td>0.048458</td>
      <td>11</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3490</td>
      <td>222</td>
      <td>8</td>
      <td>2016</td>
      <td>19</td>
      <td>20:58:00</td>
      <td>8</td>
      <td>2016</td>
      <td>20</td>
      <td>00:34:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>12.8</td>
      <td>12.0</td>
      <td>16.9</td>
      <td>32.2</td>
      <td>9999.0</td>
      <td>22.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>29</th>
      <td>31</td>
      <td>XX</td>
      <td>6454</td>
      <td>HAU</td>
      <td>59.413780</td>
      <td>5.268000</td>
      <td>NO</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>1917</td>
      <td>2016-08-26 20:45:00</td>
      <td>2016-08-26 21:07:00</td>
      <td>2016-08-27 00:30:00</td>
      <td>2016-08-27 00:59:00</td>
      <td>22</td>
      <td>29</td>
      <td>225</td>
      <td>NaN</td>
      <td>232</td>
      <td>75W</td>
      <td>XNDAT</td>
      <td>Departed</td>
      <td>HAU-LEU</td>
      <td>Y</td>
      <td>227</td>
      <td>227</td>
      <td>13</td>
      <td>24922</td>
      <td>435179</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>24922</td>
      <td>435179</td>
      <td>0.057269</td>
      <td>13</td>
      <td>0</td>
      <td>5</td>
      <td>2</td>
      <td>3444</td>
      <td>220</td>
      <td>8</td>
      <td>2016</td>
      <td>26</td>
      <td>21:07:00</td>
      <td>8</td>
      <td>2016</td>
      <td>27</td>
      <td>00:59:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>3</td>
      <td>13.6</td>
      <td>15.8</td>
      <td>15.8</td>
      <td>31.1</td>
      <td>9999.0</td>
      <td>22.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>35.9</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>212668</th>
      <td>221947</td>
      <td>QN</td>
      <td>3590</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-08-04 08:00:00</td>
      <td>2016-08-04 08:09:00</td>
      <td>2016-08-04 10:25:00</td>
      <td>2016-08-04 10:33:00</td>
      <td>9</td>
      <td>8</td>
      <td>145</td>
      <td>NaN</td>
      <td>144</td>
      <td>AT7</td>
      <td>MFTAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>53</td>
      <td>25421</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>25421</td>
      <td>32615</td>
      <td>0.779412</td>
      <td>53</td>
      <td>6</td>
      <td>2</td>
      <td>2</td>
      <td>382</td>
      <td>32</td>
      <td>8</td>
      <td>2016</td>
      <td>4</td>
      <td>08:09:00</td>
      <td>8</td>
      <td>2016</td>
      <td>4</td>
      <td>10:33:00</td>
      <td>jueves</td>
      <td>jueves</td>
      <td>4</td>
      <td>16.1</td>
      <td>9999.0</td>
      <td>27.2</td>
      <td>23.8</td>
      <td>18.9</td>
      <td>17.1</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>3.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212669</th>
      <td>221948</td>
      <td>QN</td>
      <td>3590</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-08-09 08:00:00</td>
      <td>2016-08-09 07:52:00</td>
      <td>2016-08-09 10:25:00</td>
      <td>2016-08-09 10:16:00</td>
      <td>-8</td>
      <td>-9</td>
      <td>145</td>
      <td>NaN</td>
      <td>144</td>
      <td>AT7</td>
      <td>MFTAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>18</td>
      <td>8633</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>8633</td>
      <td>32615</td>
      <td>0.264706</td>
      <td>18</td>
      <td>4</td>
      <td>2</td>
      <td>2</td>
      <td>90</td>
      <td>9</td>
      <td>8</td>
      <td>2016</td>
      <td>9</td>
      <td>07:52:00</td>
      <td>8</td>
      <td>2016</td>
      <td>9</td>
      <td>10:16:00</td>
      <td>martes</td>
      <td>martes</td>
      <td>4</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>25.2</td>
      <td>23.0</td>
      <td>18.0</td>
      <td>18.3</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212670</th>
      <td>221949</td>
      <td>QN</td>
      <td>3590</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-08-18 08:00:00</td>
      <td>2016-08-18 07:58:00</td>
      <td>2016-08-18 10:25:00</td>
      <td>2016-08-18 10:18:00</td>
      <td>-2</td>
      <td>-7</td>
      <td>145</td>
      <td>NaN</td>
      <td>140</td>
      <td>AT7</td>
      <td>MFSAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>56</td>
      <td>26860</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>26860</td>
      <td>32615</td>
      <td>0.823529</td>
      <td>56</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>290</td>
      <td>29</td>
      <td>8</td>
      <td>2016</td>
      <td>18</td>
      <td>07:58:00</td>
      <td>8</td>
      <td>2016</td>
      <td>18</td>
      <td>10:18:00</td>
      <td>jueves</td>
      <td>jueves</td>
      <td>4</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>23.5</td>
      <td>24.6</td>
      <td>18.6</td>
      <td>19.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.8</td>
      <td>0.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212671</th>
      <td>221950</td>
      <td>QN</td>
      <td>3590</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-08-25 08:00:00</td>
      <td>2016-08-25 08:00:00</td>
      <td>2016-08-25 10:25:00</td>
      <td>2016-08-25 10:20:00</td>
      <td>0</td>
      <td>-5</td>
      <td>145</td>
      <td>NaN</td>
      <td>140</td>
      <td>AT7</td>
      <td>MFRAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>15</td>
      <td>7195</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>7195</td>
      <td>32615</td>
      <td>0.220588</td>
      <td>15</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>82</td>
      <td>7</td>
      <td>8</td>
      <td>2016</td>
      <td>25</td>
      <td>08:00:00</td>
      <td>8</td>
      <td>2016</td>
      <td>25</td>
      <td>10:20:00</td>
      <td>jueves</td>
      <td>jueves</td>
      <td>4</td>
      <td>15.4</td>
      <td>16.8</td>
      <td>35.3</td>
      <td>29.5</td>
      <td>24.8</td>
      <td>26.7</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212672</th>
      <td>221967</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2015-06-21 13:45:00</td>
      <td>2015-06-21 13:45:00</td>
      <td>2015-06-21 16:10:00</td>
      <td>2015-06-21 16:10:00</td>
      <td>0</td>
      <td>0</td>
      <td>145</td>
      <td>NaN</td>
      <td>145</td>
      <td>ATR</td>
      <td>MFZAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>72</td>
      <td>72</td>
      <td>68</td>
      <td>32615</td>
      <td>34534</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>32615</td>
      <td>34534</td>
      <td>0.944444</td>
      <td>68</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>531</td>
      <td>43</td>
      <td>6</td>
      <td>2015</td>
      <td>21</td>
      <td>13:45:00</td>
      <td>6</td>
      <td>2015</td>
      <td>21</td>
      <td>16:10:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>10.8</td>
      <td>12.7</td>
      <td>27.2</td>
      <td>26.0</td>
      <td>19.7</td>
      <td>19.7</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212673</th>
      <td>221968</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2015-06-28 13:45:00</td>
      <td>2015-06-28 13:40:00</td>
      <td>2015-06-28 16:10:00</td>
      <td>2015-06-28 15:56:00</td>
      <td>-5</td>
      <td>-14</td>
      <td>145</td>
      <td>NaN</td>
      <td>136</td>
      <td>AT7</td>
      <td>MFXAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>52</td>
      <td>24941</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>24941</td>
      <td>32615</td>
      <td>0.764706</td>
      <td>52</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>343</td>
      <td>27</td>
      <td>6</td>
      <td>2015</td>
      <td>28</td>
      <td>13:40:00</td>
      <td>6</td>
      <td>2015</td>
      <td>28</td>
      <td>15:56:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>12.7</td>
      <td>12.3</td>
      <td>29.1</td>
      <td>16.5</td>
      <td>22.1</td>
      <td>21.3</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212674</th>
      <td>221969</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2015-07-05 13:45:00</td>
      <td>2015-07-05 13:38:00</td>
      <td>2015-07-05 16:10:00</td>
      <td>2015-07-05 15:58:00</td>
      <td>-7</td>
      <td>-12</td>
      <td>145</td>
      <td>NaN</td>
      <td>140</td>
      <td>AT7</td>
      <td>MFUAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>57</td>
      <td>27339</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>27339</td>
      <td>32615</td>
      <td>0.838235</td>
      <td>57</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>478</td>
      <td>38</td>
      <td>7</td>
      <td>2015</td>
      <td>5</td>
      <td>13:38:00</td>
      <td>7</td>
      <td>2015</td>
      <td>5</td>
      <td>15:58:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>17.9</td>
      <td>17.0</td>
      <td>28.4</td>
      <td>29.0</td>
      <td>21.8</td>
      <td>21.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212675</th>
      <td>221970</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2015-07-26 13:45:00</td>
      <td>2015-07-26 13:39:00</td>
      <td>2015-07-26 16:10:00</td>
      <td>2015-07-26 15:59:00</td>
      <td>-6</td>
      <td>-11</td>
      <td>145</td>
      <td>NaN</td>
      <td>140</td>
      <td>AT7</td>
      <td>MFQAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>58</td>
      <td>27819</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>27819</td>
      <td>32615</td>
      <td>0.852941</td>
      <td>58</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>448</td>
      <td>37</td>
      <td>7</td>
      <td>2015</td>
      <td>26</td>
      <td>13:39:00</td>
      <td>7</td>
      <td>2015</td>
      <td>26</td>
      <td>15:59:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>11.5</td>
      <td>9999.0</td>
      <td>29.0</td>
      <td>22.3</td>
      <td>20.7</td>
      <td>15.2</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212676</th>
      <td>221971</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2015-08-02 13:45:00</td>
      <td>2015-08-02 13:46:00</td>
      <td>2015-08-02 16:10:00</td>
      <td>2015-08-02 16:12:00</td>
      <td>1</td>
      <td>2</td>
      <td>145</td>
      <td>NaN</td>
      <td>146</td>
      <td>ATR</td>
      <td>MFZAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>72</td>
      <td>72</td>
      <td>62</td>
      <td>29738</td>
      <td>34534</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>29738</td>
      <td>34534</td>
      <td>0.861111</td>
      <td>62</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>493</td>
      <td>42</td>
      <td>8</td>
      <td>2015</td>
      <td>2</td>
      <td>13:46:00</td>
      <td>8</td>
      <td>2015</td>
      <td>2</td>
      <td>16:12:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>12.8</td>
      <td>9.9</td>
      <td>30.6</td>
      <td>31.5</td>
      <td>21.7</td>
      <td>21.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212677</th>
      <td>221972</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2015-08-09 13:45:00</td>
      <td>2015-08-09 13:36:00</td>
      <td>2015-08-09 16:10:00</td>
      <td>2015-08-09 15:56:00</td>
      <td>-9</td>
      <td>-14</td>
      <td>145</td>
      <td>NaN</td>
      <td>140</td>
      <td>AT7</td>
      <td>MFSAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>37</td>
      <td>17747</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>17747</td>
      <td>32615</td>
      <td>0.544118</td>
      <td>37</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>170</td>
      <td>15</td>
      <td>8</td>
      <td>2015</td>
      <td>9</td>
      <td>13:36:00</td>
      <td>8</td>
      <td>2015</td>
      <td>9</td>
      <td>15:56:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>14.1</td>
      <td>9999.0</td>
      <td>21.5</td>
      <td>26.0</td>
      <td>16.9</td>
      <td>15.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>14.2</td>
      <td>13.2</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212678</th>
      <td>221973</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2015-08-16 13:45:00</td>
      <td>2015-08-16 13:40:00</td>
      <td>2015-08-16 16:10:00</td>
      <td>2015-08-16 16:07:00</td>
      <td>-5</td>
      <td>-3</td>
      <td>145</td>
      <td>NaN</td>
      <td>147</td>
      <td>ATR</td>
      <td>MFAAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>72</td>
      <td>72</td>
      <td>39</td>
      <td>18706</td>
      <td>34534</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>18706</td>
      <td>34534</td>
      <td>0.541667</td>
      <td>39</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>474</td>
      <td>34</td>
      <td>8</td>
      <td>2015</td>
      <td>16</td>
      <td>13:40:00</td>
      <td>8</td>
      <td>2015</td>
      <td>16</td>
      <td>16:07:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>13.6</td>
      <td>11.0</td>
      <td>23.5</td>
      <td>31.5</td>
      <td>19.1</td>
      <td>17.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212679</th>
      <td>221974</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-06-12 13:05:00</td>
      <td>2016-06-12 13:06:00</td>
      <td>2016-06-12 15:30:00</td>
      <td>2016-06-12 15:30:00</td>
      <td>1</td>
      <td>0</td>
      <td>145</td>
      <td>NaN</td>
      <td>144</td>
      <td>ATR</td>
      <td>MFAAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>72</td>
      <td>72</td>
      <td>44</td>
      <td>21104</td>
      <td>34534</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>21104</td>
      <td>34534</td>
      <td>0.611111</td>
      <td>44</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>285</td>
      <td>20</td>
      <td>6</td>
      <td>2016</td>
      <td>12</td>
      <td>13:06:00</td>
      <td>6</td>
      <td>2016</td>
      <td>12</td>
      <td>15:30:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>10.7</td>
      <td>10.0</td>
      <td>21.6</td>
      <td>20.6</td>
      <td>16.7</td>
      <td>15.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.3</td>
      <td>0.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212680</th>
      <td>221975</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-07-03 13:05:00</td>
      <td>2016-07-03 13:19:00</td>
      <td>2016-07-03 15:30:00</td>
      <td>2016-07-03 15:41:00</td>
      <td>14</td>
      <td>11</td>
      <td>145</td>
      <td>145.0</td>
      <td>142</td>
      <td>ATR</td>
      <td>MFZAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>72</td>
      <td>72</td>
      <td>63</td>
      <td>30217</td>
      <td>34534</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>30217</td>
      <td>34534</td>
      <td>0.875000</td>
      <td>63</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>572</td>
      <td>43</td>
      <td>7</td>
      <td>2016</td>
      <td>3</td>
      <td>13:19:00</td>
      <td>7</td>
      <td>2016</td>
      <td>3</td>
      <td>15:41:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>13.5</td>
      <td>8.6</td>
      <td>24.5</td>
      <td>21.3</td>
      <td>18.2</td>
      <td>15.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.8</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212681</th>
      <td>221976</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-07-24 13:05:00</td>
      <td>2016-07-24 13:20:00</td>
      <td>2016-07-24 15:30:00</td>
      <td>2016-07-24 15:41:00</td>
      <td>15</td>
      <td>11</td>
      <td>145</td>
      <td>150.0</td>
      <td>141</td>
      <td>ATR</td>
      <td>MFYAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>72</td>
      <td>72</td>
      <td>53</td>
      <td>25421</td>
      <td>34534</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>25421</td>
      <td>34534</td>
      <td>0.736111</td>
      <td>53</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>427</td>
      <td>32</td>
      <td>7</td>
      <td>2016</td>
      <td>24</td>
      <td>13:20:00</td>
      <td>7</td>
      <td>2016</td>
      <td>24</td>
      <td>15:41:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>15.1</td>
      <td>14.4</td>
      <td>26.6</td>
      <td>29.1</td>
      <td>20.3</td>
      <td>22.2</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.5</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212682</th>
      <td>221977</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-07-31 13:05:00</td>
      <td>2016-07-31 14:15:00</td>
      <td>2016-07-31 15:30:00</td>
      <td>2016-07-31 16:39:00</td>
      <td>10</td>
      <td>9</td>
      <td>145</td>
      <td>145.0</td>
      <td>144</td>
      <td>AT7</td>
      <td>MFRAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>41</td>
      <td>19665</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>19665</td>
      <td>32615</td>
      <td>0.602941</td>
      <td>41</td>
      <td>3</td>
      <td>2</td>
      <td>2</td>
      <td>224</td>
      <td>19</td>
      <td>7</td>
      <td>2016</td>
      <td>31</td>
      <td>14:15:00</td>
      <td>7</td>
      <td>2016</td>
      <td>31</td>
      <td>16:39:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>16.3</td>
      <td>14.0</td>
      <td>24.6</td>
      <td>25.5</td>
      <td>18.3</td>
      <td>19.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.5</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212683</th>
      <td>221978</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-08-07 13:05:00</td>
      <td>2016-08-07 13:07:00</td>
      <td>2016-08-07 15:30:00</td>
      <td>2016-08-07 15:25:00</td>
      <td>2</td>
      <td>-5</td>
      <td>145</td>
      <td>NaN</td>
      <td>138</td>
      <td>AT7</td>
      <td>MFVAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>20</td>
      <td>9593</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>9593</td>
      <td>32615</td>
      <td>0.294118</td>
      <td>20</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>162</td>
      <td>15</td>
      <td>8</td>
      <td>2016</td>
      <td>7</td>
      <td>13:07:00</td>
      <td>8</td>
      <td>2016</td>
      <td>7</td>
      <td>15:25:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>10.7</td>
      <td>13.6</td>
      <td>27.9</td>
      <td>29.7</td>
      <td>18.9</td>
      <td>21.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212684</th>
      <td>221979</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-08-14 13:05:00</td>
      <td>2016-08-14 12:56:00</td>
      <td>2016-08-14 15:30:00</td>
      <td>2016-08-14 15:16:00</td>
      <td>-9</td>
      <td>-14</td>
      <td>145</td>
      <td>NaN</td>
      <td>140</td>
      <td>AT7</td>
      <td>MFVAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>23</td>
      <td>11032</td>
      <td>32615</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>11032</td>
      <td>32615</td>
      <td>0.338235</td>
      <td>23</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>176</td>
      <td>14</td>
      <td>8</td>
      <td>2016</td>
      <td>14</td>
      <td>12:56:00</td>
      <td>8</td>
      <td>2016</td>
      <td>14</td>
      <td>15:16:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>13.1</td>
      <td>14.4</td>
      <td>33.5</td>
      <td>21.0</td>
      <td>23.7</td>
      <td>23.7</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212685</th>
      <td>221980</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-08-21 13:05:00</td>
      <td>2016-08-21 12:55:00</td>
      <td>2016-08-21 15:30:00</td>
      <td>2016-08-21 15:14:00</td>
      <td>-10</td>
      <td>-16</td>
      <td>145</td>
      <td>NaN</td>
      <td>139</td>
      <td>ATR</td>
      <td>MFZAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>72</td>
      <td>72</td>
      <td>9</td>
      <td>4317</td>
      <td>34534</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>4317</td>
      <td>34534</td>
      <td>0.125000</td>
      <td>9</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>58</td>
      <td>5</td>
      <td>8</td>
      <td>2016</td>
      <td>21</td>
      <td>12:55:00</td>
      <td>8</td>
      <td>2016</td>
      <td>21</td>
      <td>15:14:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>9999.0</td>
      <td>10.8</td>
      <td>23.2</td>
      <td>25.5</td>
      <td>17.2</td>
      <td>17.8</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>6.6</td>
      <td>1.5</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212686</th>
      <td>221981</td>
      <td>QN</td>
      <td>3790</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>PIS</td>
      <td>46.583330</td>
      <td>0.333330</td>
      <td>FR</td>
      <td>480</td>
      <td>2016-08-28 13:05:00</td>
      <td>2016-08-28 13:15:00</td>
      <td>2016-08-28 15:30:00</td>
      <td>2016-08-28 17:36:00</td>
      <td>10</td>
      <td>6</td>
      <td>145</td>
      <td>145.0</td>
      <td>261</td>
      <td>ATR</td>
      <td>MFZAT</td>
      <td>Departed</td>
      <td>LEU-PIS</td>
      <td>Y</td>
      <td>72</td>
      <td>72</td>
      <td>6</td>
      <td>2878</td>
      <td>34534</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>2878</td>
      <td>34534</td>
      <td>0.083333</td>
      <td>6</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>48</td>
      <td>5</td>
      <td>8</td>
      <td>2016</td>
      <td>28</td>
      <td>13:15:00</td>
      <td>8</td>
      <td>2016</td>
      <td>28</td>
      <td>17:36:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>4</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>24.2</td>
      <td>32.0</td>
      <td>21.0</td>
      <td>20.7</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212687</th>
      <td>221995</td>
      <td>QN</td>
      <td>1522</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>GNB</td>
      <td>45.362944</td>
      <td>5.329375</td>
      <td>FR</td>
      <td>460</td>
      <td>2015-06-09 07:25:00</td>
      <td>2015-06-09 07:33:00</td>
      <td>2015-06-09 09:45:00</td>
      <td>2015-06-09 09:51:00</td>
      <td>8</td>
      <td>6</td>
      <td>140</td>
      <td>NaN</td>
      <td>138</td>
      <td>AT7</td>
      <td>MFTAT</td>
      <td>Departed</td>
      <td>LEU-GNB</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>54</td>
      <td>24852</td>
      <td>31295</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>24852</td>
      <td>31295</td>
      <td>0.794118</td>
      <td>54</td>
      <td>5</td>
      <td>2</td>
      <td>2</td>
      <td>842</td>
      <td>64</td>
      <td>6</td>
      <td>2015</td>
      <td>9</td>
      <td>07:33:00</td>
      <td>6</td>
      <td>2015</td>
      <td>9</td>
      <td>09:51:00</td>
      <td>martes</td>
      <td>martes</td>
      <td>2</td>
      <td>12.5</td>
      <td>15.0</td>
      <td>22.1</td>
      <td>24.7</td>
      <td>17.6</td>
      <td>18.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>15.5</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212688</th>
      <td>221996</td>
      <td>QN</td>
      <td>1522</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>LPY</td>
      <td>45.080689</td>
      <td>3.762889</td>
      <td>FR</td>
      <td>359</td>
      <td>2015-07-12 12:30:00</td>
      <td>2015-07-12 12:36:00</td>
      <td>2015-07-12 14:30:00</td>
      <td>2015-07-12 14:31:00</td>
      <td>6</td>
      <td>1</td>
      <td>120</td>
      <td>NaN</td>
      <td>115</td>
      <td>AT7</td>
      <td>MFQAT</td>
      <td>Departed</td>
      <td>LEU-LPY</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>54</td>
      <td>19375</td>
      <td>24398</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>19375</td>
      <td>24398</td>
      <td>0.794118</td>
      <td>54</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>1010</td>
      <td>65</td>
      <td>7</td>
      <td>2015</td>
      <td>12</td>
      <td>12:36:00</td>
      <td>7</td>
      <td>2015</td>
      <td>12</td>
      <td>14:31:00</td>
      <td>domingo</td>
      <td>domingo</td>
      <td>2</td>
      <td>15.6</td>
      <td>12.4</td>
      <td>25.7</td>
      <td>28.7</td>
      <td>20.1</td>
      <td>20.7</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212689</th>
      <td>221997</td>
      <td>QN</td>
      <td>1522</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>GNB</td>
      <td>45.362944</td>
      <td>5.329375</td>
      <td>FR</td>
      <td>460</td>
      <td>2016-08-23 07:25:00</td>
      <td>2016-08-23 07:29:00</td>
      <td>2016-08-23 09:45:00</td>
      <td>2016-08-23 09:52:00</td>
      <td>4</td>
      <td>7</td>
      <td>140</td>
      <td>NaN</td>
      <td>143</td>
      <td>AT7</td>
      <td>MFQAT</td>
      <td>Departed</td>
      <td>LEU-GNB</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>48</td>
      <td>22091</td>
      <td>31295</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>22091</td>
      <td>31295</td>
      <td>0.705882</td>
      <td>48</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>904</td>
      <td>66</td>
      <td>8</td>
      <td>2016</td>
      <td>23</td>
      <td>07:29:00</td>
      <td>8</td>
      <td>2016</td>
      <td>23</td>
      <td>09:52:00</td>
      <td>martes</td>
      <td>martes</td>
      <td>2</td>
      <td>12.0</td>
      <td>14.7</td>
      <td>34.0</td>
      <td>30.1</td>
      <td>23.5</td>
      <td>22.3</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212690</th>
      <td>221998</td>
      <td>QN</td>
      <td>1622</td>
      <td>LPY</td>
      <td>45.080689</td>
      <td>3.762889</td>
      <td>FR</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>359</td>
      <td>2015-07-13 09:00:00</td>
      <td>2015-07-13 09:07:00</td>
      <td>2015-07-13 11:00:00</td>
      <td>2015-07-13 11:10:00</td>
      <td>7</td>
      <td>10</td>
      <td>120</td>
      <td>NaN</td>
      <td>123</td>
      <td>AT7</td>
      <td>MFXAT</td>
      <td>Departed</td>
      <td>LPY-LEU</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>52</td>
      <td>18657</td>
      <td>24398</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>18657</td>
      <td>24398</td>
      <td>0.764706</td>
      <td>52</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>1004</td>
      <td>65</td>
      <td>7</td>
      <td>2015</td>
      <td>13</td>
      <td>09:07:00</td>
      <td>7</td>
      <td>2015</td>
      <td>13</td>
      <td>11:10:00</td>
      <td>lunes</td>
      <td>lunes</td>
      <td>3</td>
      <td>10.9</td>
      <td>9999.0</td>
      <td>27.1</td>
      <td>27.3</td>
      <td>19.8</td>
      <td>21.1</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212691</th>
      <td>221999</td>
      <td>QN</td>
      <td>1622</td>
      <td>GNB</td>
      <td>45.362944</td>
      <td>5.329375</td>
      <td>FR</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>460</td>
      <td>2015-06-10 17:55:00</td>
      <td>2015-06-10 18:09:00</td>
      <td>2015-06-10 20:10:00</td>
      <td>2015-06-10 20:17:00</td>
      <td>14</td>
      <td>7</td>
      <td>135</td>
      <td>NaN</td>
      <td>128</td>
      <td>AT7</td>
      <td>MFUAT</td>
      <td>Departed</td>
      <td>GNB-LEU</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>52</td>
      <td>23932</td>
      <td>31295</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>23932</td>
      <td>31295</td>
      <td>0.764706</td>
      <td>52</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>736</td>
      <td>58</td>
      <td>6</td>
      <td>2015</td>
      <td>10</td>
      <td>18:09:00</td>
      <td>6</td>
      <td>2015</td>
      <td>10</td>
      <td>20:17:00</td>
      <td>mi�rcoles</td>
      <td>mi�rcoles</td>
      <td>3</td>
      <td>13.8</td>
      <td>13.8</td>
      <td>9999.0</td>
      <td>21.5</td>
      <td>20.1</td>
      <td>16.1</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>5.1</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212692</th>
      <td>222000</td>
      <td>QN</td>
      <td>1622</td>
      <td>GNB</td>
      <td>45.362944</td>
      <td>5.329375</td>
      <td>FR</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>460</td>
      <td>2016-08-24 17:55:00</td>
      <td>2016-08-24 18:34:00</td>
      <td>2016-08-24 20:10:00</td>
      <td>2016-08-24 20:42:00</td>
      <td>39</td>
      <td>32</td>
      <td>135</td>
      <td>140.0</td>
      <td>128</td>
      <td>AT7</td>
      <td>MFRAT</td>
      <td>Departed</td>
      <td>GNB-LEU</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>44</td>
      <td>20250</td>
      <td>31295</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>20250</td>
      <td>31295</td>
      <td>0.647059</td>
      <td>44</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>819</td>
      <td>65</td>
      <td>8</td>
      <td>2016</td>
      <td>24</td>
      <td>18:34:00</td>
      <td>8</td>
      <td>2016</td>
      <td>24</td>
      <td>20:42:00</td>
      <td>mi�rcoles</td>
      <td>mi�rcoles</td>
      <td>3</td>
      <td>16.6</td>
      <td>13.8</td>
      <td>33.6</td>
      <td>33.9</td>
      <td>26.1</td>
      <td>23.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212693</th>
      <td>222002</td>
      <td>QN</td>
      <td>4423</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>CIA</td>
      <td>41.799360</td>
      <td>12.594940</td>
      <td>IT</td>
      <td>925</td>
      <td>2015-03-18 08:15:00</td>
      <td>2015-03-18 08:26:00</td>
      <td>2015-03-18 11:25:00</td>
      <td>2015-03-18 11:33:00</td>
      <td>11</td>
      <td>8</td>
      <td>190</td>
      <td>NaN</td>
      <td>187</td>
      <td>AT5</td>
      <td>MFPAT</td>
      <td>Departed</td>
      <td>LEU-CIA</td>
      <td>Y</td>
      <td>48</td>
      <td>48</td>
      <td>38</td>
      <td>35135</td>
      <td>44381</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>35135</td>
      <td>44381</td>
      <td>0.791667</td>
      <td>38</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>477</td>
      <td>45</td>
      <td>3</td>
      <td>2015</td>
      <td>18</td>
      <td>08:26:00</td>
      <td>3</td>
      <td>2015</td>
      <td>18</td>
      <td>11:33:00</td>
      <td>mi�rcoles</td>
      <td>mi�rcoles</td>
      <td>2</td>
      <td>2.0</td>
      <td>8.4</td>
      <td>15.2</td>
      <td>9999.0</td>
      <td>9.3</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212694</th>
      <td>222005</td>
      <td>QN</td>
      <td>3523</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>MCM</td>
      <td>43.726350</td>
      <td>7.420550</td>
      <td>MC</td>
      <td>512</td>
      <td>2016-03-19 21:00:00</td>
      <td>2016-03-19 21:10:00</td>
      <td>2016-03-19 23:20:00</td>
      <td>2016-03-19 23:26:00</td>
      <td>10</td>
      <td>6</td>
      <td>140</td>
      <td>NaN</td>
      <td>136</td>
      <td>AT7</td>
      <td>MFUAT</td>
      <td>Departed</td>
      <td>LEU-MCM</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>58</td>
      <td>29711</td>
      <td>34833</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>29711</td>
      <td>34833</td>
      <td>0.852941</td>
      <td>58</td>
      <td>1</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>2016</td>
      <td>19</td>
      <td>21:10:00</td>
      <td>3</td>
      <td>2016</td>
      <td>19</td>
      <td>23:26:00</td>
      <td>s�bado</td>
      <td>s�bado</td>
      <td>1</td>
      <td>1.9</td>
      <td>8.0</td>
      <td>16.1</td>
      <td>12.8</td>
      <td>8.9</td>
      <td>11.6</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212695</th>
      <td>222009</td>
      <td>QN</td>
      <td>3623</td>
      <td>MCM</td>
      <td>43.726350</td>
      <td>7.420550</td>
      <td>MC</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>512</td>
      <td>2016-03-18 21:30:00</td>
      <td>2016-03-18 21:47:00</td>
      <td>2016-03-18 23:55:00</td>
      <td>2016-03-19 00:01:00</td>
      <td>17</td>
      <td>6</td>
      <td>145</td>
      <td>NaN</td>
      <td>134</td>
      <td>AT7</td>
      <td>MFVAT</td>
      <td>Departed</td>
      <td>MCM-LEU</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>60</td>
      <td>30735</td>
      <td>34833</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>30735</td>
      <td>34833</td>
      <td>0.882353</td>
      <td>60</td>
      <td>2</td>
      <td>2</td>
      <td>2</td>
      <td>0</td>
      <td>0</td>
      <td>3</td>
      <td>2016</td>
      <td>18</td>
      <td>21:47:00</td>
      <td>3</td>
      <td>2016</td>
      <td>19</td>
      <td>00:01:00</td>
      <td>viernes</td>
      <td>s�bado</td>
      <td>2</td>
      <td>7.5</td>
      <td>-0.7</td>
      <td>15.3</td>
      <td>12.5</td>
      <td>11.6</td>
      <td>5.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212696</th>
      <td>222011</td>
      <td>QN</td>
      <td>3723</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>DNR</td>
      <td>48.587683</td>
      <td>-2.079958</td>
      <td>FR</td>
      <td>746</td>
      <td>2016-04-16 08:00:00</td>
      <td>2016-04-16 07:50:00</td>
      <td>2016-04-16 10:50:00</td>
      <td>2016-04-16 10:39:00</td>
      <td>-10</td>
      <td>-11</td>
      <td>170</td>
      <td>NaN</td>
      <td>169</td>
      <td>AT7</td>
      <td>MFVAT</td>
      <td>Departed</td>
      <td>LEU-DNR</td>
      <td>Y</td>
      <td>68</td>
      <td>68</td>
      <td>28</td>
      <td>20889</td>
      <td>50730</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>20889</td>
      <td>50730</td>
      <td>0.411765</td>
      <td>28</td>
      <td>0</td>
      <td>2</td>
      <td>2</td>
      <td>459</td>
      <td>29</td>
      <td>4</td>
      <td>2016</td>
      <td>16</td>
      <td>07:50:00</td>
      <td>4</td>
      <td>2016</td>
      <td>16</td>
      <td>10:39:00</td>
      <td>s�bado</td>
      <td>s�bado</td>
      <td>5</td>
      <td>7.7</td>
      <td>9999.0</td>
      <td>24.3</td>
      <td>9999.0</td>
      <td>15.5</td>
      <td>9.4</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
    <tr>
      <th>212697</th>
      <td>222012</td>
      <td>OR</td>
      <td>776</td>
      <td>LEU</td>
      <td>42.338611</td>
      <td>1.409167</td>
      <td>ES</td>
      <td>QXB</td>
      <td>43.505554</td>
      <td>5.367778</td>
      <td>FR</td>
      <td>347</td>
      <td>2011-01-08 12:00:00</td>
      <td>2011-01-08 11:56:00</td>
      <td>2011-01-08 14:00:00</td>
      <td>2011-01-08 13:58:00</td>
      <td>-4</td>
      <td>-2</td>
      <td>120</td>
      <td>NaN</td>
      <td>122</td>
      <td>AT5</td>
      <td>MFOAT</td>
      <td>Departed</td>
      <td>LEU-QXB</td>
      <td>Y</td>
      <td>48</td>
      <td>48</td>
      <td>22</td>
      <td>7643</td>
      <td>16676</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>7643</td>
      <td>16676</td>
      <td>0.458333</td>
      <td>22</td>
      <td>0</td>
      <td>1</td>
      <td>2</td>
      <td>209</td>
      <td>19</td>
      <td>1</td>
      <td>2011</td>
      <td>8</td>
      <td>11:56:00</td>
      <td>1</td>
      <td>2011</td>
      <td>8</td>
      <td>13:58:00</td>
      <td>s�bado</td>
      <td>s�bado</td>
      <td>4</td>
      <td>4.1</td>
      <td>13.4</td>
      <td>16.2</td>
      <td>17.9</td>
      <td>9.2</td>
      <td>14.9</td>
      <td>9999.0</td>
      <td>9999.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>9999.0</td>
      <td>9999.0</td>
    </tr>
  </tbody>
</table>
<p>212698 rows × 69 columns</p>
</div>




```python
vuelos.to_csv('vuelos.csv', sep=',', index=False) 
```
