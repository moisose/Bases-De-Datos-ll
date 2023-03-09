import json
from elasticsearch import Elasticsearch
from elasticsearch.helpers import scan

es = Elasticsearch(['http://localhost:9200'], basic_auth=('elastic', 'AJCcCwWNgEhIHm1KQJPe'))

print(es.ping())

# to create and delete an index

#es.indices.create(index="files")

#es.indices.delete(index="files")

# for inserting json string
#es.index(index='files', document=json.loads('{"fileName":"jane", "contents":"data"}'))
#es.index(index='files', document=json.loads('{"fileName":"jane2", "contents":"data"}'))

# returns the JSON string of the given file retrived from elasticsearch
# @restrictions: none
# @param: the name of the file that will be retrieved from elasticsearch
# @output: JSON string of the given file
def getFileElasticSearch(fileName):

    hit = ""

    query = {
        "query":{
            "match": {
            "fileName.keyword": fileName
            }
        }
    }

    # Scan function to get all the data. 
    rel = scan(client=es,             
               query=query,                                     
               scroll='1m',
               index='files',
               raise_on_error=True,
               preserve_order=False,
               clear_scroll=True)

    # We need only '_source', which has all the fields required.
    # This elimantes the elasticsearch metdata like _id, _type, _index.
    result = list(rel)
    if (result != []):
        hit = result[0]['_source']

    return hit

fileName = 'AGE00147706.dly'

print(getFileElasticSearch(fileName))