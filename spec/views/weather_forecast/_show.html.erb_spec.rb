# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'weather_forecast/_show', type: :view do
  let(:forecasts) do
    {
      current_temperature: 72,
      cached: false,
      forecast_temperatures: {
        '2025-03-14' => { minimum_temperature: 60, maximum_temperature: 75 }
      }
    }
  end

  before do
    assign(:forecasts, forecasts)
    render
  end

  it 'displays the current temperature' do
    expect(rendered).to include('<strong>72</strong>')
  end

  it 'displays the forecast temperatures' do
    expect(rendered).to include('60')
    expect(rendered).to include('75')
  end
end
