# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherForecastController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    context 'with valid params' do
      let(:valid_forecast_data) do
        {
          current_temperature: 72,
          cached: false,
          forecast_temperatures: {
            '2025-03-14': { minimum_temperature: 60, maximum_temperature: 75 }
          }
        }
      end

      before do
        allow_any_instance_of(WeatherForecastService).to receive(:forecasts).and_return(valid_forecast_data)
      end

      it 'returns http success' do
        get :show, params: { address: 'New York' }
        expect(response).to have_http_status(:ok)
      end

      it 'returns JSON with forecast data when requested' do
        get :show, params: { address: 'New York' }, format: :json

        json_response = JSON.parse(response.body)

        expect(json_response).to have_key('current_temperature')
        expect(json_response).to have_key('cached')
        expect(json_response).to have_key('forecast_temperatures')
        expect(json_response['current_temperature']).to eq(72)
      end
    end

    context 'with invalid params' do
      it 'does not call the WeatherForecastService' do
        expect(WeatherForecastService).not_to receive(:new)
        get :show, params: { invalid_address: 'New York' }
      end

      it 'returns bad request status' do
        get :show, params: { invalid_address: 'New York' }
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error message in JSON' do
        get :show, params: { invalid_address: 'New York' }
        json_response = JSON.parse(response.body)

        expect(json_response).to have_key('error')
        expect(json_response['error']).to eq('Address parameter is required')
      end
    end
  end
end
