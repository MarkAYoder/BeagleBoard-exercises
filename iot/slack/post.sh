# From: https://www.cloudsavvyit.com/289/how-to-send-a-message-to-slack-from-a-bash-script/

curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World 5!"}' \
https://hooks.slack.com/services/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
echo