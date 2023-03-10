import os
import mysql.connector
import requests
import hashlib

# environment variables
HOST = os.getenv('MARIADBHOST')
PASSWORD = os.getenv('MARIADBPASS')
PORT = '3306'
USER = 'root'
DATABASE = 'weather'
#-------------------------------------------Functions------------------------------------
# executes a stored procedure
# @restrictions: none
# @param: the name of the stored prcedure and the parameters of the stored procedure (array of strings)
# @output: none
def executeProcedure(procedure, parameters):
    resultArray = []
    try:
        conn = mysql.connector.connect(host=HOST, user=USER, password= PASSWORD, port= PORT, database=DATABASE)
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
        return ['error']
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
    varResult = ''
    url = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt'
    try:
        file = requests.get(url)
    except:
        return "The page is not responding"
    
    string = file.content.decode('utf-8')
    lines = string.rsplit('\n')
    print(lines)

    md5 = getMd5(string)
    stored_results = executeProcedure('loadFile', ["ghcnd-stations.txt", url, str(md5).encode(), "Descargado"])
    print(stored_results)

    if stored_results[0] == 'error':
        return 'Conexion fallida'
    
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
                print(stationId, latitude, longitude, elevation, state, name, gsnFlag, hcnFlag, wmoId, countryCode)
                executeProcedure('createstation', [stationId, latitude, longitude, elevation, state, name, gsnFlag, hcnFlag, wmoId, countryCode])
            varResult = 'El archivo se modifico'
        else:
            print("El archivo no se modifico")
            varResult = 'El archivo no se modifico'

    file.close()
    return varResult


#_______________________________________________________MAIN_____________________________________________________________
readStations()
