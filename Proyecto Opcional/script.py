# ---> pip3 install mariadb
#import mariadb
#import pickle

def readCountries():
    file = open("ghcnd-countries.txt","r")
    lines = file.readlines()

    for line in lines:
        code = line[:2]
        name = line[3:].replace(' ', '')
        print(code + "\n" + name)


    file.close()
        

def readStates():
    file = open("ghcnd-states.txt","r")
    lines = file.readlines()

    for line in lines:
        code = line[:2]
        name = line[3:].replace(' ', '')
        print(code + "\n" + name)


    file.close()
    

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
