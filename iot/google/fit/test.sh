#!/bin/bash
ACCESS_TOKEN="ya29.Ci8bA8vqzLK4_6eWb4CzFIMS3KdlSJzFNuqCHOJwfvV5F6-Jr2Y8aYbGdftWKJ_MOw"

# curl \
#   -H "Content-Type: application/json" \
#   -H "Authorization: Bearer $ACCESS_TOKEN" \
#   https://www.googleapis.com/fitness/v1/users/me/dataSources

# curl --header "Authorization: Bearer $ACCESS_TOKEN" -X POST \
#   --header "Content-Type: application/json;encoding=utf-8" -d @aggregate.json \
#   "https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate"
  
# curl --header "Authorization: Bearer $ACCESS_TOKEN" -X GET \
#   --header "Content-Type: application/json;encoding=utf-8" \
#   "https://www.googleapis.com/fitness/v1/users/me/dataSources/derived:com.google.step_count.delta:1234567890:Example%20Manufacturer:ExampleTablet:1000001:MyDataSource"

# curl --header "Authorization: Bearer $ACCESS_TOKEN" -X GET \
#   --header "Content-Type: application/json;encoding=utf-8" \
#   "https://www.googleapis.com/fitness/v1/users/me/sessions"
#    ?startTime=2014-04-01T00:01:00.00Z
#    &endTime=2014-04-30T23:59:00.00Z

# curl \
#   -H "Content-Type: application/json" \
#   -H "Authorization: Bearer $ACCESS_TOKEN" \
#   -X POST \
#   https://www.googleapis.com/fitness/v1/users/me/dataset:aggregate

curl  https://www.googleapis.com/fitness/v1/users/me/dataSources?key=W3xqToRNTe72_xVO40EkGC-J