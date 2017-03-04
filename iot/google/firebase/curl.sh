# From: https://firebase.google.com/docs/database/rest/save-data

export DB='https://friendlychat-c7ea7.firebaseio.com/users.json'
export apikey="AAAAd3djyFo:APA91bHkpYmfiJZHy_vTaNbg6wWIJXe-TvnjUAK5FLfHILpd0rnIJJ8z15zljzoIjcQclLxm5WlGYjgAJops76H0wrAFy7amwyLUdntgTFesdeeahaqbBlOWpqUXh5r8mTkgD563ruTW"

curl -X POST -d '{
  "alanisawesome": {
    "name": "New Key",
    "birthday": "4-Feb-2017"
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
