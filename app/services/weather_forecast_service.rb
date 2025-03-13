# frozen_string_literal: true

class WeatherForecastService
  # TODO: add to env variables
  GOOGLE_GEOCODE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/'
  GOOGLE_API_KEY = 'AIzaSyDvDgH45kLhA_w0MPmwqcMKH3bG1rl46b0'

  OPENMETEO_API_URL = 'https://api.open-meteo.com/v1/'

  def initialize(address:)
    @address = address
  end

  def forecasts
    geocoding = fetch_geocoding

    latitude = geocoding[:latitude]
    longitude = geocoding[:longitude]
    postal_code = geocoding[:postal_code]

    fetch_forecasts(latitude: latitude, longitude: longitude, postal_code: postal_code)
  end

  attr_reader :address

  private

  # uses Google's Geocoding API to get latitude, longitude, and zip code data from a fuzzy address search
  # we want to standardize addresses for most weather APIs, handle zip code formats outside of the U.S.
  def fetch_geocoding
    rest_client = Faraday.new(url: GOOGLE_GEOCODE_API_URL)
    response = rest_client.get('json', { address: address, key: GOOGLE_API_KEY })

    response_body = JSON.parse(response.body)

    results = response_body['results'].first

    {
      latitude: results['navigation_points'].first['location']['latitude'],
      longitude: results['navigation_points'].first['location']['longitude'],
      postal_code: results['address_components'][7]['long_name'] # TODO: ensure this is always 8th element
    }
  end

  # uses Open-Meteo to fetch weather data by latitude and longitude
  def fetch_forecasts(latitude:, longitude:, postal_code:)
    rest_client = Faraday.new(url: OPENMETEO_API_URL)

    # TODO: these parameters can be selected by user and dynamically added as required
    # ex: https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=temperature_2m_max,temperature_2m_min&current=temperature_2m&temperature_unit=fahrenheit
    response = rest_client.get('forecast',
                               {
                                 latitude: latitude,
                                 longitude: longitude,
                                 temperature_unit: 'fahrenheit',
                                 current: 'temperature_2m',
                                 daily: %w[temperature_2m_max temperature_2m_min]
                               })

    response_body = JSON.parse(response.body)

    temperature_unit = response_body['current_units']['temperature_2m']

    current_temperature = response_body['current']['temperature_2m']
    forecast_temperatures = response_body['daily']

    forecast_data = {}

    forecast_temperatures['time'].each_with_index do |date, index|
      forecast_data[date] = {
        minimum_temperature: (forecast_temperatures['temperature_2m_min'][index].to_s + temperature_unit).to_s,
        maximum_temperature: (forecast_temperatures['temperature_2m_max'][index].to_s + temperature_unit).to_s
      }
    end

    {
      current_temperature: (current_temperature.to_s + temperature_unit).to_s,
      forecast_temperatures: forecast_data
    }
  end
end
