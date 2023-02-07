# Go TO: https://platform.openai.com/docs/quickstart/build-your-application
# follow instructions up to but not including "flask run:
# Install the following:
sudo apt install libatlas-base-dev
chmod +x app.py
# Add "#!/usr/bin/env python" to the top of app.py
# Add the following to the bottom of app.py
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8081, debug=True)

To run enter:
./app.py

 * Serving Flask app 'app' (lazy loading)
 * Environment: development
 * Debug mode: on
 * Running on all addresses.
   WARNING: This is a development server. Do not use it in a production deployment.
 * Running on http://137.112.38.102:8081/ (Press CTRL+C to quit)
 * Restarting with stat

Point your browser where it says to.
