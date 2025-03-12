class WeatherForecastService
  def initialize(address:)
    this.address = address
  end

  attr_reader :address

  private

  def forecasts
  end
end
