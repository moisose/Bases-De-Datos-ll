import json

"""
This method receives the name of a file and its contents and creates a file called processor.json
"""
def processorJson(name, contents):
    result = {"filename" : name, "contents": contents}

    with open("processor.json", "w") as write_file:
        json.dump(result, write_file)

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
    
    with open("parser.json", "w") as write_file:
        json.dump(result, write_file)

    return result


"""
This method receives a json and transform its data and creates a file called transformation.json
"""


def transformationJson(jsonParsed):
    for i in json["data"]:
        date = i["date"]
        stationId = i["station_id"]

        tempDict = {
            "station_id": i[0],
            "date": i[1],
            "month": date[0:4],
            "year": date[4:6], 
            "type": i[2],
            "value": i[3],
            "mflag": i[4],
            "qflag": i[5],
            "sflag": i[6],
            "FIPS_country_code" : stationId[0:2],
            "network_code" : stationId[2:3],
            "real_station_id" : stationId[3:12]
        }

        i = tempDict

    with open("transformation.json", "w") as write_file:
        json.dump(jsonParsed, write_file)

