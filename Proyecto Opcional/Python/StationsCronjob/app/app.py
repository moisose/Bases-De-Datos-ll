import os
import mysql.connector
import requests
import hashlib


#Values
pw = 'password'
puerto = '3307'


#-------------------------------------------Functions------------------------------------
# executes a stored procedure
# @restrictions: none
# @param: the name of the stored prcedure and the parameters of the stored procedure (array of strings)
# @output: none
def executeProcedure(procedure, parameters):
    resultArray = []
    try:
        conn = mysql.connector.connect(host="localhost", user='root', password= pw, port= puerto, database='weather')
        cursor = conn.cursor()
        args = ("FF", 2, 2, 20, 3)
        result_args = cursor.callproc(procedure, parameters)

        
        for result in cursor.stored_results():
             resultArray.append(result.fetchall())
             #print(resultArray)
        conn.commit()

        if (conn.is_connected()):
            cursor.close()
            conn.close()
            stored_results = cursor.stored_results()
            #print("MySQL connection is closed")
        

    except mysql.connector.Error as error:
        pass
        #print("Failed to execute stored procedure: {}".format(error))

    finally:
        pass
        
    return resultArray

#------------------------------------------------------------------------------------------------------------------------------
# Calculate the MD5 of a string
# @restrictions: none
# @param: a string 
# @output: the hash of the string
def getMd5(string):
    hashSha = hashlib.sha256()
    hashSha.update(string.encode())
    return hashSha.hexdigest()

#-------------------------------------------------------------------------------------------
# reads stations.txt and inserts in table weather.stations
# @restrictions: none
# @param: none
# @output: none
def readStations():
    url = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt'
    file = requests.get(url)
    
    string = file.content.decode('utf-8')
    lines = string.rsplit('\n')

    md5 = getMd5(string)
    stored_results = executeProcedure('loadFile', ["ghcnd-stations.txt", url, str(md5).encode(), "Descargado"])
    print(stored_results)
    
    for result in stored_results:
        if result[0][0] == "The file has been created" or result[0][0] == 'The textFile has been successfully modified.':
            for line in lines:
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
        else:
            print("El archivo no se modifico")

    file.close()


#_______________________________________________________MAIN_____________________________________________________________
readStations()