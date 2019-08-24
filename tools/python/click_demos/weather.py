""" Demonstrates using the "click" framework to simplify CLI programs.

    Intro to click, Part 1: https://dbader.org/blog/python-commandline-tools-with-click
    Intro to click, Part 2: https://dbader.org/blog/mastering-click-advanced-python-command-line-apps

    Website: https://click.palletsprojects.com/en/6.x/
"""

import click
import requests

SAMPLE_API_KEY = '8cddff978c0b838abb2caf33ac0c0fb3'


def current_weather(location, api_key=SAMPLE_API_KEY):
    # Example url:
    #	api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=8cddff978c0b838abb2caf33ac0c0fb3

    url = 'https://api.openweathermap.org/data/2.5/weather'

    query_params = {
        'q': location,
        'APPID': api_key,
    }

    # https://realpython.com/python-requests/#the-response
    response = requests.get(url, params=query_params)

    return response.json()['weather'][0]['description'] if response.status_code == 200 else "Error: " + str(response.status_code)


@click.command()
@click.argument('location')
@click.option(
    '--api-key', '-a',
    help='your API key for the OpenWeatherMap API',
)
def main(location, api_key):
    """
    A little weather tool that shows you the current weather in a LOCATION of
    your choice. Provide the city name and optionally a two-digit country code.

    Example:
    python weather.py London,uk

    NOTE:
    You need a valid API key from OpenWeatherMap for the tool to work. You can
    sign up for a free account at https://openweathermap.org/appid.
    """
    weather = current_weather(location, api_key)
    print(f"The weather in {location} right now: {weather}.")


if __name__ == "__main__":
    main()

