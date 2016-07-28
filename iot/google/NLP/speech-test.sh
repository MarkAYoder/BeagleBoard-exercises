# From: https://cloud.google.com/speech/docs/getting-started

apikey=ya29.CjAoA8di0H8kooSv14Z1ypKetJDKMGOcI6OVunZk3f6Ts_ueVKyYpsowVa3l9_oxkSo

# curl -s -k -H "Content-Type: application/json" \
#     -H "Authorization: Bearer $apikey" \
#     https://speech.googleapis.com/v1beta1/speech:syncrecognize \
#     -d @sync-request.json
    
curl -s -k -H "Content-Type: application/json" \
    -H "Authorization: Bearer $apikey" \
    https://speech.googleapis.com/v1beta1/speech:syncrecognize \
    --data '{
      "config": {
          "encoding":"FLAC",
          "sample_rate": 16000
      },
      "audio": {
          "uri":"gs://cloud-samples-tests/speech/brooklyn.flac"
      }
    }'
    
# From: https://cloud.google.com/speech/docs/best-practices
# curl "https://speech.googleapis.com/v1beta1/speech:syncrecognize" \
#     --header "Content-Type: application/json" \
#     --header "Authorization: Bearer $apikey" \
#     --data '{"config":{"encoding":"FLAC","sample_rate":16000,"language_code":"en-US"},"audio":{"uri":"gs://speech-demo/shwazil_hoful.flac"}}'

# curl "https://speech.googleapis.com/v1beta1/speech:syncrecognize" \
#     --header "Content-Type: application/json" \
#     --header "Authorization: Bearer $apikey" \
#     --data '{"config":{"encoding":"FLAC","sample_rate":16000,"language_code":"en-US","speech_context":{"phrases":["hoful","shwazil"]}},"audio":{"uri":"gs://speech-demo/shwazil_hoful.flac"}}'

# curl "https://speech.googleapis.com/v1beta1/speech:syncrecognize" \
#     --header "Content-Type: application/json" \
#     --header "Authorization: Bearer $apikey" \
#     --data '{"config":{"encoding":"FLAC","sample_rate":16000,"language_code":"en-US","speech_context":{"phrases":"shwazil hoful day"}},"audio":{"uri":"gs://speech-demo/shwazil_hoful.flac"}}'