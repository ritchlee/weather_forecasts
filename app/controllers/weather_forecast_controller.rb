# frozen_string_literal: true

class WeatherForecastController < ApplicationController
  def index
    render :index
  end

  def show
    # Rails.logger.level = 0
    # logger.debug "DEBUG params: #{params}"
    # logger.debug "DEBUG: #{query_params}"
    address = query_params[:address] # TODO: change to address

    weather_forecast_service = WeatherForecastService.new(address: address)
    @forecasts = weather_forecast_service.forecasts

    render :index
  end

  private

  def query_params
    params.permit(:address, :commit) # TODO: figure out how to remove or ignore 'commit'
  end
end
