# ---> pip3 install mariadb
import os
import mysql.connector
import requests
import hashlib



pw = 'MhlDahiana'
puerto = '3307'



# executes a stored procedure
# @restrictions: none
# @param: the name of the stored prcedure and the parameters of the stored procedure (array of strings)
# @output: none
def executeProcedure(procedure, parameters):
   
    try:
        conn = mysql.connector.connect(host="localhost", user='root', password= pw, port= puerto, database='weather')
        cursor = conn.cursor()
        args = ("FF", 2, 2, 20, 3)
        result_args = cursor.callproc(procedure, parameters)
        for result in cursor.stored_results():
             print(result.fetchall())
        conn.commit()
        

    except mysql.connector.Error as error:
        print("Failed to execute stored procedure: {}".format(error))

    finally:
        if (conn.is_connected()):
            cursor.close()
            conn.close()
            print("MySQL connection is closed")
    return cursor
 

# reads countries.txt and inserts in table weather.countries
# @restrictions: none
# @param: none
# @output: noneexecuteProcedure('createCountry', [code, name])
def readCountries():
    url = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-countries.txt'
    file = requests.get(url)
    
    string = file.content.decode('utf-8')
    lines = string.rsplit('\n')
    md5 = getMd5(string)
    cursor = executeProcedure('loadFile', ["ghcnd-countries.txt", url, str(md5), "Descargado"])
    for result in cursor.stored_results():
        print("Resultado", result.fetchall())
        if result[0][0] == "The file has been created" or result[0][0] == 'The textFile has been successfully modified.':
            for line in lines:
                code = line[:2]
                name = line[3:]
                executeProcedure('createCountry', [code, name])
            print("El archivo se modifico")
        else:
            print("El archivo no se modifico")

    
    

  

# reads states.txt and inserts in table weather.states
# @restrictions: none
# @param: none
# @output: none
def readStates():
    url = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-states.txt'
    file = requests.get(url)
    
    string = file.content.decode('utf-8')
    lines = string.rsplit('\n')

    for line in lines:
        code = line[:2]
        name = line[3:]
        executeProcedure('createState', [code, name])


    file.close()
    

# reads stations.txt and inserts in table weather.stations
# @restrictions: none
# @param: none
# @output: none
def readStations():
    url = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt'
    file = requests.get(url)
    
    string = file.content.decode('utf-8')
    lines = string.rsplit('\n')

    for line in lines:
        print('\n' + line)
        stationId = line[:11]
        countryCode = stationId[0:2]
        latitude = line[12:20].replace(' ', '')
        longitude = line[21:30].replace(' ', '')
        elevation = line[31:37].replace(' ', '')
        state = line[38:40].replace(' ', '')
        name = line[41:71]
        gsnFlag = line[72:75].replace(' ', '')
        hcnFlag = line[76:79].replace(' ', '')
        wmoId = line[80:85].replace(' ', '')
        
        executeProcedure('createStation', [stationId, latitude, longitude, elevation, state, name, gsnFlag, hcnFlag, wmoId, countryCode])


    file.close()

        

def getMd5(string):
    hashSha = hashlib.sha256()
    hashSha.update(string.encode())
    print (hashSha.hexdigest())
    return hashSha
    
   


    




