# Restarts temp.py when it stops
echo Starting temp.py
until ./temp.py ; do
    echo "Restarting exit code $?. " >&2
    sleep 1
done
