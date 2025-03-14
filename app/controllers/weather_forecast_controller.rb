# frozen_string_literal: true

class WeatherForecastController < ApplicationController
  def index
    render :index
  end

  def show
    address = query_params[:address]

    return render json: { error: 'Address parameter is required' }, status: :bad_request unless address.present?

    weather_forecast_service = WeatherForecastService.new(address: address)
    @forecasts = weather_forecast_service.forecasts

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @forecasts }
    end
  end

  private

  def query_params
    params.permit(:address, :commit) # TODO: figure out how to remove or ignore 'commit'
  end
end
