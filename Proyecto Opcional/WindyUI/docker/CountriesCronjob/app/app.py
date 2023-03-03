import os
import mysql.connector
import requests
import hashlib
#import Python.DatabaseConn 


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
 
#--------------------------------------------------------------------------------------------------
# reads countries.txt and inserts in table weather.countries
# @restrictions: none
# @param: none
# @output: noneexecuteProcedure('createCountry', [code, name])
def readCountries():
    url = 'https://www.ncei.noaa.gov/pub/data/ghcn/daily/ghcnd-countries.txt'
    try:
        file = requests.get(url)
    except:
        return "The page is not responding"
    
    string = file.content.decode('utf-8')
    lines = string.rsplit('\n')
    
    md5 = getMd5(string)
    stored_results = executeProcedure('loadFile', ["ghcnd-countries.txt", url, str(md5).encode(), "Descargado"])
    print(stored_results)
    
    for result in stored_results:
        if result[0][0] == "The file has been created" or result[0][0] == 'The textFile has been successfully modified.':
            for line in lines:
                code = line[:2]
                name = line[3:]
                executeProcedure('createCountry', [code, name])
            print("El archivo se modifico")
        else:
            print("El archivo no se modifico")


#_______________________________________________________MAIN_____________________________________________________________
#readCountries()
