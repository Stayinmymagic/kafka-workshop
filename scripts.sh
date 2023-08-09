# post a data by REST
curl -X POST \
     -H "Content-Type: application/vnd.kafka.json.v2+json" \
     -H "Accept: application/vnd.kafka.v2+json" \
     --data '{"records":[{"key":"movie_id","value":1},{"key":"title","value":"Elements"},{"key":"year","value":2023}]}' \
     "http://localhost:8082/topics/movies"

# return {"offsets":[{"partition":0,"offset":3,"error_code":null,"error":null},{"partition":0,"offset":4,"error_code":null,"error":null},{"partition":0,"offset":5,"error_code":null,"error":null}],"key_schema_id":null,"value_schema_id":null}

# create consumer 
curl -X POST \
     -H "Content-Type: application/vnd.kafka.v2+json" \
     --data '{"name": "consumer1", "format": "json", "auto.offset.reset": "earliest"}' \
     http://localhost:8082/consumers/cg1
# return {"instance_id":"consumer1","base_uri":"http://rest-proxy:8082/consumers/cg1/instances/consumer1"}

# Subscribe to the topic movies
curl -X POST \
     -H "Content-Type: application/vnd.kafka.v2+json" \
     --data '{"topics":["movies"]}' \
     http://localhost:8082/consumers/cg1/instances/consumer1/subscription 

# Consume some data using the base URL in the first response
curl -X GET \
     -H "Accept: application/vnd.kafka.json.v2+json" \
     http://localhost:8082/consumers/cg1/instances/consumer1/records 

# Close the consumer with a DELETE to make it leave the group and clean up its resource
curl -X DELETE \
     -H "Content-Type: application/vnd.kafka.v2+json" \
     http://localhost:8082/consumers/cg1/instances/consumer1


#
curl -X POST -H "Content-Type: application/vnd.kafka.avro.v2+json" \
      -H "Accept: application/vnd.kafka.v2+json" \
      --data '{"value_schema": "{\"type\": \"record\", \"name\": \"movie\", \"fields\": [{\"name\": \"movie_id\", \"type\": \"long\"},{\"name\": \"title\", \"type\": \"string\"},{\"name\": \"release_year\", \"type\": \"long\"}]}",
       "records": [{"value": {"movie_id": 1}, {"title": "Elements"},{"release_year": 2023} }]
       }' \
      "http://localhost:8082/topics/movies"

curl --request POST \
  --url http://localhost:8082/topics/movies \
  --header 'accept: application/vnd.kafka.v2+json, application/vnd.kafka+json, application/json' \
  --header 'content-type: application/vnd.kafka.avro.v2+json' \
  --data '{
  "value_schema": "{\"name\":\"movies-value\",\"type\":\"record\"],\"fields\":[{\"name\":\"movie_id\",\"type\":\"long\"},{\"name\":\"title\",\"type\":\"string\"},{\"name\":\"release_year\",\"type\":\"long\"}]}",
  "records": [
    {
      "value": {"movie_id": 1, "title": "Elements", "release_year": 2023}
    }
  ]
}'

curl --request POST \
  --url http://localhost:8082/topics/movies \
  --header 'accept: application/vnd.kafka.v2+json, application/vnd.kafka+json, application/json' \
  --header 'content-type: application/vnd.kafka.avro.v2+json' \
  --data '{
   "value_schema_id": 1 ,
  "records": [
    {
      "value": {"movie_id": 1, "title": "Elements", "release_year": 2023}
    }
  ]
}'