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
    expect(rendered).to have_selector('div.display-4', text: '72')
  end

  it 'displays the forecast temperatures in a table' do
    expect(rendered).to have_selector('table.table tbody tr td', text: '60')
    expect(rendered).to have_selector('table.table tbody tr td', text: '75')
  end

  it 'shows the cache status in an alert' do
    expect(rendered).to have_selector('div.alert.alert-info', text: /Cached Values:/)
  end
end
