class WeatherForecastController < ApplicationController
  def index
    render :index
  end

  def show
    # Rails.logger.level = 0
    # logger.debug "DEBUG params: #{params}"
    # logger.debug "DEBUG: #{query_params}"
    @forecasts = 'test'
    render :index
  end

  private

  def query_params
    params.permit(:address)
  end
end
