#! /usr/bin/env python3

# This script reads temperature data from two TMP101 sensors and logs the readings to a SQLite database.
# It is intended to be run periodically (e.g., via cron) to collect temperature data over time.

import os
import sqlite3
import json
import argparse
from datetime import datetime

import paho.mqtt.publish as mqtt_publish

def c_to_f(c):
    return c * 9.0 / 5.0 + 32.0

db_path = "tmp101_data.db"

# MQTT configuration (can be overridden with environment variables)
MQTT_HOST = os.environ.get("MQTT_HOST", "localhost")
MQTT_PORT = int(os.environ.get("MQTT_PORT", "1883"))
MQTT_TOPIC_BASE = os.environ.get("MQTT_TOPIC_BASE", "home/tmp101")
# Paths for the two TMP101 sensors
sensor_paths = [
    "/sys/class/hwmon/hwmon0/temp1_input",
    "/sys/class/hwmon/hwmon1/temp1_input"
]

def read_temp(sensor_path):
    try:
        with open(sensor_path) as f:
            # TMP101 reports temp in millidegrees Celsius
            temp_c = float(f.read().strip()) / 1000.0
        return temp_c
    except Exception as e:
        print(f"Error reading {sensor_path}: {e}")
        return None


def publish_temps_mqtt(timestamp, temp1_f, temp2_f):
    """Publish the latest temperature readings via MQTT as a single JSON message."""
    if not MQTT_HOST:
        # If MQTT is not configured, just skip publishing.
        return

    payload = {
        "timestamp": timestamp,
        "temp1_f": temp1_f,
        "temp2_f": temp2_f,
    }

    try:
        mqtt_publish.single(
            f"{MQTT_TOPIC_BASE}/readings",
            json.dumps(payload),
            hostname=MQTT_HOST,
            port=MQTT_PORT,
            retain=True,    # Keep the last message in the topic
        )
    except Exception as e:
        print(f"Error publishing MQTT message: {e}")

def log_data(publish_mqtt=False):
    try:
        conn = sqlite3.connect(db_path)
        c = conn.cursor()
        c.execute(
            '''CREATE TABLE IF NOT EXISTS readings
                     (timestamp TEXT, temp1 REAL, temp2 REAL)'''
        )
        temp1 = read_temp(sensor_paths[0])
        temp2 = read_temp(sensor_paths[1])
        ts = datetime.now().isoformat()
        if temp1 is not None and temp2 is not None:
            temp1_f = c_to_f(temp1)
            temp2_f = c_to_f(temp2)
            c.execute("INSERT INTO readings VALUES (?, ?, ?)", (ts, temp1_f, temp2_f))
            conn.commit()
            # Also publish the reading via MQTT if requested
            if publish_mqtt:
                publish_temps_mqtt(ts, temp1_f, temp2_f)
        else:
            print(f"[{ts}] Error: Could not read one or both temperature sensors. Data not logged.")
        conn.close()
    except Exception as e:
        print(f"Error: Could not open or write to database '{db_path}': {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Read TMP101 sensors and log to SQLite.")
    parser.add_argument(
        "--mqtt",
        action="store_true",
        help="Also publish the latest reading via MQTT.",
    )
    args = parser.parse_args()

    log_data(publish_mqtt=args.mqtt)