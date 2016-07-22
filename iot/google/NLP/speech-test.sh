# From: https://cloud.google.com/speech/docs/getting-started

curl -s -k -H "Content-Type: application/json" \
    -H "Authorization: Bearer ya29.CjAoAzFIzudKKKNJcr3bWlEMx_Mh-giu9yV0cwz0Xx6c_KQJBZ7Jwgd3_SIBIHZCg2c" \
    https://speech.googleapis.com/v1beta1/speech:syncrecognize \
    -d @sync-request.json