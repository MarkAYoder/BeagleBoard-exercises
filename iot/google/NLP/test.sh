# From: https://cloud.google.com/natural-language/docs/getting-started

export GOOGLE_APPLICATION_CREDENTIALS=NLP-test-e281274f4df1.json
    
curl -s -k -H "Content-Type: application/json" \
    -H "Authorization: Bearer ya29.Ci8nA0_tswnQzDz2O4Mr6RpvR9eWb2_wC4PTA6QaAdFk5ifeyIRCR6Nrd1bN2mdWcw" \
    https://language.googleapis.com/v1beta1/documents:annotateText \
    -d @entity2.json