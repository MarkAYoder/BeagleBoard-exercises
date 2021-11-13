# Restarts tempio.py when it stops
echo Starting tempio.py
until ./tempio.py ; do
    date
    echo "Restarting tmpio exit code $?. " >&2
    sleep 1
done
