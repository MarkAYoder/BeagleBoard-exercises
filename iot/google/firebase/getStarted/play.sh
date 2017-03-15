# From: https://firebase.google.com/docs/functions/http-events

curl -X PUSH -H "Content-Type:application/json" https://us-central1-curious-kingdom-800.cloudfunctions.net/addMessage?text=upperMe -d '{"text":"something"}'

# curl -X GET https://us-central1-curious-kingdom-800.cloudfunctions.net/addMessage?text=up