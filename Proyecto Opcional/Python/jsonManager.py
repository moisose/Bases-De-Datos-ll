import json

# Types dictionary
typeNames = {
    "PRCP" : "Precipitation (tenths of mm)",
   	"SNOW" : "Snowfall (mm)",
	"SNWD" : "Snow depth (mm)",
    "TMAX" : "Maximum temperature (tenths of degrees C)",
    "TMIN" : "Minimum temperature (tenths of degrees C)",
    "RHMX" : "Maximum relative humidity for the day (percent)"
}

"""
This method receives the name of a file and its contents and creates a file called processor.json
"""
def processorJson(name, contents):
    result = {"filename" : name, "contents": contents}

    result = str(result)
    
    return result


"""
This method receives a filename and a list of data and creates a file called parser.json
"""

def parserJson(filename, listOfData):
    
    dictionaryResults = []
    for i in listOfData:
        tempDict = {
            "station_id": i[0],
            "date": i[1],
            "type": i[2],
            "value": i[3],
            "mflag": i[4],
            "qflag": i[5],
            "sflag": i[6]
        }
        dictionaryResults.append(tempDict)
    
    result = {"filename" : filename,
              "data" : dictionaryResults}
    
    result = str(result)

    return result


"""
This method receives a json and transform its data and creates a file called transformation.json
"""
def transformationJson(jsonParsed):

    jsonParsed = eval(jsonParsed)

    for i in range(0, len(jsonParsed["data"])) :
        
        date = jsonParsed["data"][i]["date"]
        stationId = jsonParsed["data"][i]["station_id"]

        tempDict = {
            "station_id": jsonParsed["data"][i]["station_id"],
            "date": jsonParsed["data"][i]["date"],
            "month": date[0:4],
            "year": date[4:6], 
            "type": jsonParsed["data"][i]["type"],
            "value": jsonParsed["data"][i]["value"],
            "mflag": jsonParsed["data"][i]["mflag"],
            "qflag": jsonParsed["data"][i]["qflag"],
            "sflag": jsonParsed["data"][i]["sflag"],
            "FIPS_country_code" : stationId[0:2],
            "network_code" : stationId[2:3],
            "real_station_id" : stationId[3:12],
            "type_name" : typeNames[jsonParsed["data"][i]["type"]]
        }

        jsonParsed["data"][i] = tempDict

    jsonParsed = str(jsonParsed)
    print("*****")
    print(jsonParsed)
    print("*****")

    return jsonParsed

"""
This method performs an sql request and gets the information missing to add it to the json data
"""
def stationTransformation():
    print()

# tmp = {"filename" : "test",
#             "data":[{
#             "station_id": "AEM00041217",
#             "date": "198301",
#             "type": "TMAX",
#             "value": "298",
#             "mflag": "B",
#             "qflag": "M",
#             "sflag": "A"
#             }]}

# tmp = str(tmp)

# transformationJson(tmp)