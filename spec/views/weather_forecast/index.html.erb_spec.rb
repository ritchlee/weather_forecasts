# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'weather_forecast/index', type: :view do
  context 'when index page loads search form' do
    before do
      render
    end

    it 'displays the main heading' do
      expect(rendered).to have_selector('h1', text: 'Weather Forecasts')
    end

    it 'renders the search form' do
      expect(rendered).to have_selector('form[action="/weather_forecast"][method="get"]')
      expect(rendered).to have_field('Enter an Address', type: 'search')
      expect(rendered).to have_button('Search')
    end
  end

  context 'when forecasts are present' do
    before do
      assign(:forecasts, forecasts)
      render
    end

    let(:forecasts) do
      {
        current_temperature: 72,
        cached: false,
        forecast_temperatures: { '2025-03-14' => { minimum_temperature: 60, maximum_temperature: 75 } }
      }
    end

    it 'renders the show partial' do
      expect(rendered).to have_selector('h2.h5', text: 'Current Temperature')
      expect(rendered).to have_selector('div.display-4', text: '72')
      expect(rendered).to have_selector('table.table')
      expect(rendered).to have_selector('div.alert.alert-info', text: /Cached Values:/)
    end
  end

  context 'when forecasts are not present' do
    before do
      render
    end

    it 'does not render the show partial' do
      expect(rendered).not_to have_selector('h2', text: 'Current Temperature:')
      expect(rendered).not_to have_selector('table')
    end
  end

  context 'when forecasts are present but empty' do
    before do
      assign(:forecasts, nil)
      render
    end

    it 'does not render the show partial' do
      expect(rendered).not_to have_selector('h2', text: 'Current Temperature:')
      expect(rendered).not_to have_selector('table')
    end
  end
end
