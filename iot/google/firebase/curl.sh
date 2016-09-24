# From: https://firebase.google.com/docs/database/rest/save-data

export DB='https://friendlychat-c7ea7.firebaseio.com/users.json'
export apikey="AIzaSyDaMwP3HNH52o2JWC4Nb8ZNHpdb0k0pn6s"

curl -X POST -d '{
  "alanisawesome": {
    "name": "Alan Turing",
    "birthday": "June 23, 1912"
  }
}' $DB 
curl -X POST -d '{
  "test": {
    "name": "Test Ting",
    "birthday": "June 23, 1912"
  }
}' $DB 
# \
#     -H "Content-Type: application/json" \
#     -H "Authorization: Bearer $apikey"

curl "$DB?print=pretty"

# This never worked.  I don't know how to get the access token
# curl "$DB?print=pretty&access_token=5FPzljup8kL-MZVnBWF6njkr"
