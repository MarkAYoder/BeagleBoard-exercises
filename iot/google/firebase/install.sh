# From: https://codelabs.developers.google.com/codelabs/firebase-web/#1
git clone https://github.com/firebase/friendlychat
npm -g install firebase-tools   # Took 15 minutes and failed first time running out of memory

firebase login
# When it tries to go to a web address, substitute "bone" for "localhost".

firebase serve -p 5000 -o 192.168.7.2
# Then browse to 192.168.7.2:5000

# Had to go to https://console.firebase.google.com/project/friendlychat-c7ea7/authentication/providers
# and authorize the 192.168.7.2 domain

# For the JavaScript version
npm install firebase --save
