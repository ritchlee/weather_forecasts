# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherForecastService do
  let(:address) { 'New York' }
  subject(:service) { described_class.new(address: address) }

  describe '#forecasts' do
    context 'when service succeeds' do
      let(:geocode_response) do
        {
          results: [
            {
              navigation_points: [
                {
                  location: {
                    latitude: 40.7128,
                    longitude: -74.0060
                  }
                }
              ],
              address_components: [
                {}, {}, {}, {}, {}, {}, {},
                {
                  long_name: '10001'
                }
              ]
            }
          ]
        }.to_json
      end

      let(:weather_response) do
        {
          current_units: {
            temperature_2m: '°F'
          },
          current: {
            temperature_2m: 72.0
          },
          daily: {
            time: ['2025-03-14'],
            temperature_2m_min: [60.0],
            temperature_2m_max: [75.0]
          }
        }.to_json
      end

      before do
        stub_request(:get, /maps.googleapis.com/)
          .to_return(status: 200, body: geocode_response, headers: {})

        stub_request(:get, /api.open-meteo.com/)
          .to_return(status: 200, body: weather_response, headers: {})
      end

      it 'returns forecast data' do
        result = service.forecasts

        expect(result).to include(
          current_temperature: '72.0°F',
          cached: false,
          forecast_temperatures: {
            '2025-03-14' => {
              minimum_temperature: '60.0°F',
              maximum_temperature: '75.0°F'
            }
          }
        )
      end
    end

    context 'when service fails' do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(StandardError.new('Service unavailable'))
      end

      it 'raises a service unavailable error' do
        expect { service.forecasts }.to raise_error(StandardError, 'Service unavailable')
      end
    end
  end
end
