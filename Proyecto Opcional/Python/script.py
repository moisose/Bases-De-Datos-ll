# ---> pip3 install mariadb
#import mariadb
#import pickle
import os
import mysql.connector

pw = 'password'
puerto = '3307'

# inserts row in a table
# @restrictions: none
# @param: the INSERT query
# @output: none
def insertRow(query):
    try:
        conn = mysql.connector.connect(host = "localhost", user='root', password= pw, port= puerto, database='Prueba');
    except mysql.connector.Error as e:
        print('Error')

    cursor = conn.cursor()
    cursor.execute(query)

    conn.commit()



# reads a certain row in a table
# @restrictions: none
# @param: the SELECT query and the parameters (tuple of strings)
# @output: none
def readRow(query, parameters):
    try:
        conn = mysql.connector.connect(host = "localhost", user='root', password= pw, port= puerto, database='Prueba')
    except mysql.connector.Error as e:
        print('Error')

    cursor = conn.cursor()
    cursor.execute(query)

    #for parameters in cursor:
    #    print(parameters)



# executes a stored procedure
# @restrictions: none
# @param: the name of the stored prcedure and the parameters of the stored procedure (array of strings)
# @output: none
def executeProcedure(procedure, parameters):
   
    try:
        conn = mysql.connector.connect(host="localhost", user='root', password= pw, port= puerto, database='windyui')
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

 

# reads countries.txt and inserts in table weather.countries
# @restrictions: none
# @param: none
# @output: none
def readCountries():
    file = open("ghcnd-countries.txt","r")
    lines = file.readlines()

    for line in lines:
        code = line[:2]
        name = line[3:].replace(' ', '')
        print(code + "\n" + name)


    file.close()
        

# reads states.txt and inserts in table weather.states
# @restrictions: none
# @param: none
# @output: none
def readStates():
    file = open("ghcnd-states.txt","r")
    lines = file.readlines()

    for line in lines:
        code = line[:2]
        name = line[3:].replace(' ', '')
        print(code + "\n" + name)


    file.close()
    

# reads stations.txt and inserts in table weather.stations
# @restrictions: none
# @param: none
# @output: none
def readStations():
    file = open("ghcnd-stations.txt","r")
    lines = file.readlines()

    for line in lines:
        print('\n' + line)
        stationId = line[:11]
        latitude = line[12:20].replace(' ', '')
        longitude = line[21:30].replace(' ', '')
        elevation = line[31:37].replace(' ', '')
        state = line[38:40].replace(' ', '')
        name = line[41:71]
        gsnFlag = line[72:75].replace(' ', '')
        hcnFlag = line[76:79].replace(' ', '')
        wmoId = line[80:].replace(' ', '')
        
        print(stationId + "\n" + latitude + "\n" + longitude + "\n" + elevation + "\n" + state + "\n" + name + "\n" + gsnFlag + "\n" + hcnFlag + "\n" + wmoId)


    file.close()

        




    




