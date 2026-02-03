#!/usr/bin/env python3
# Usage: weather.py [city] [country_code]
# This program displays current weather information from an online source.
# Uses OpenWeatherMap API (free tier)
import json
import os
import urllib.request
import sys
import time
import logging
from logging.handlers import RotatingFileHandler

# Configure logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

# Create handlers
file_handler = RotatingFileHandler('weather.log', maxBytes=1024*1024, backupCount=5)
console_handler = logging.StreamHandler()

# Set levels
file_handler.setLevel(logging.INFO)
console_handler.setLevel(logging.WARNING)

# Create formatters and add it to handlers
log_format = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
file_handler.setFormatter(log_format)
console_handler.setFormatter(log_format)

# Add handlers to the logger
logger.addHandler(file_handler)
logger.addHandler(console_handler)

# OpenWeatherMap API configuration
API_KEY = os.environ.get("OPENWEATHER_API_KEY", "YOUR_API_KEY_HERE")
BASE_URL = "http://api.openweathermap.org/data/2.5/weather"

def get_wind_direction(degrees):
    """
    Convert wind direction degrees to compass direction
    """
    directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", 
                  "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    index = round(degrees / 22.5) % 16
    return directions[index]

def control_led(cloud_cover):
    """
    Control LED brightness using backlight PWM control
    Write 100-cloud_cover to /sys/class/backlight/backlight_pwm/brightness
    """
    try:
        # Calculate brightness inversely proportional to cloud cover
        # 0% clouds = 100% brightness, 100% clouds = 0% brightness
        brightness = 100 - cloud_cover
        
        # Write brightness value to backlight control
        with open('/sys/class/backlight/backlight_pwm/brightness', 'w') as f:
            f.write(str(brightness))
        
        logger.info(f"LED brightness: {brightness:.2f} (Cloud cover: {cloud_cover}%)")
        
    except FileNotFoundError:
        logger.error("Backlight PWM control file not found: /sys/class/backlight/backlight_pwm/brightness")
        print("⚠️  Backlight PWM control file not found")
    except PermissionError:
        logger.error("Permission denied writing to backlight PWM control file")
        print("⚠️  Permission denied - run with sudo or check file permissions")
    except Exception as e:
        logger.error(f"Error controlling LED brightness: {e}")
        print(f"⚠️  LED brightness control error: {e}")

def get_weather(city, country_code=""):
    """
    Fetch current weather data for a given city
    """
    try:
        # Construct the API URL
        if country_code:
            location = f"{city},{country_code}"
        else:
            location = city
            
        url = f"{BASE_URL}?q={location}&appid={API_KEY}&units=imperial"
        
        logger.info(f"Fetching weather for: {location}")
        
        # Make the API request
        response = urllib.request.urlopen(url)
        data = json.loads(response.read())
        
        return data
        
    except urllib.error.HTTPError as e:
        if e.code == 401:
            logger.error("Invalid API key. Please check your OpenWeatherMap API key.")
            return None
        elif e.code == 404:
            logger.error(f"City not found: {city}")
            return None
        else:
            logger.error(f"HTTP Error: {e.code}")
            return None
    except Exception as e:
        logger.error(f"Error fetching weather data: {e}")
        return None

def display_weather(weather_data):
    """
    Display weather information in a formatted way
    """
    if not weather_data:
        print("❌ Unable to fetch weather data")
        return
    
    try:
        # Extract weather information
        city = weather_data['name']
        country = weather_data['sys']['country']
        temp = weather_data['main']['temp']
        feels_like = weather_data['main']['feels_like']
        humidity = weather_data['main']['humidity']
        pressure = weather_data["main"]["pressure"] / 33.863886666667  # Convert hPa to inHg
        description = weather_data['weather'][0]['description'].title()
        wind_speed = weather_data['wind']['speed']
        wind_direction = weather_data['wind'].get('deg', 0)  # Wind direction in degrees
        cloud_cover = weather_data["clouds"]["all"]
        
        # Get sunrise and sunset times
        sunrise = time.ctime(weather_data['sys']['sunrise'])
        sunset = time.ctime(weather_data['sys']['sunset'])
        
        print("=" * 50)
        print(f"🌤️  CURRENT WEATHER - {city}, {country}")
        print("=" * 50)
        print(f"🌡️  Temperature: {temp:.1f}°F (feels like {feels_like:.1f}°F)")
        print(f"☁️  Conditions: {description}")
        print(f"💧 Humidity: {humidity}%")
        print(f"🔽 Pressure: {pressure:.1f} inHg")
        print(f"💨 Wind Speed: {wind_speed} mph {get_wind_direction(wind_direction)}")
        print(f"☁️  Cloud Cover: {cloud_cover}%")
        print(f"🌅 Sunrise: {sunrise}")
        print(f"🌇 Sunset: {sunset}")
        print("=" * 50)
        
        # Control LED based on cloud cover
        control_led(cloud_cover)
        
        logger.info(f"Weather displayed for {city}, {country}")
        
    except KeyError as e:
        logger.error(f"Error parsing weather data: Missing key {e}")
        print("❌ Error parsing weather data")

def main():
    """
    Main function to handle command line arguments and display weather
    """
    # Default location
    city = "Brazil,Indiana"
    country_code = "USA"
    
    # Parse command line arguments
    if len(sys.argv) > 1:
        city = sys.argv[1]
    if len(sys.argv) > 2:
        country_code = sys.argv[2]
    
    print(f"🌍 Fetching weather for {city}, {country_code}...")
    
    # Check if API key is set
    if API_KEY == "YOUR_API_KEY_HERE":
        print("❌ Please set your OpenWeatherMap API key as an environment variable")
        print("   Get a free API key at: https://openweathermap.org/api")

        return
    
    # Fetch and display weather
    weather_data = get_weather(city, country_code)
    display_weather(weather_data)

if __name__ == "__main__":
    main()
