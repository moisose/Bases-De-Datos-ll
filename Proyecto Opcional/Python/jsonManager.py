import json

def processorJson(name, contents):
    result = {"filename" : name, "contents": contents}

    with open("processor.json", "w") as write_file:
        json.dump(result, write_file)

    return result

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