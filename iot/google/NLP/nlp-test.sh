# From: https://cloud.google.com/natural-language/docs/getting-started

export GOOGLE_APPLICATION_CREDENTIALS=NLP-test-e281274f4df1.json
    
curl -s -k -H "Content-Type: application/json" \
    -H "Authorization: Bearer ya29.Ci8nA3s3SNO5wmGxXh-_YWJcb7PNYz6O8zH9aLvWq4-Z39ZFeAP3PaanwPcWDqHoHQ" \
    https://language.googleapis.com/v1beta1/documents:annotateText \
    -d @request.json
