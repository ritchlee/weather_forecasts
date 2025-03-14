# README

## About

This project is a demo application to fetch weather forecasts given an address, and caching the results by zip code value for 30 minutes. It is built with Ruby-on-Rails, its built-in cache store, and view rendered via ERB templates.

There are two 3rd-party APIs used:

- [Google Maps Platform - Geocoding API](https://developers.google.com/maps/documentation/geocoding)

  - to determine zip codes for caching and latitude/longitude given an address

- [Free Weather API](https://open-meteo.com/)

  - to fetch weather data by latitude/longitude

This repo is currently intended for local development/testing, and future enhancements for a production-ready deployment are noted below.

## Local Environment Setup

This configuration is based on development and testing on MacOS/ARM, using Ruby 3.3.4

### Debug / Run

1. Clone this repository and `cd` into the directory for the following steps

2. `bundle install`

3. `rails dev:cache`

4. `rails server`

5. [Development Site](http://localhost:3000)

### Test

`rspec` (from repository root)

## Current Design

The main components of this application include a Controller, Service, and a View Template with an optional Partial View Template to show search results. Each of these are intended to do the following:

### Controller

    - validate the incoming query and/or request body parameters
    - avoid data transformations if possible, or have consistent transformations across all actions when necessary
    - avoid business logic and delgate to services
    - delegate the response to a view template or specific data format(s) (i.e. JSON, XML, PDF, etc.)
    - supported actions
      - `#index`: display the form for a user to enter an address for weather forecast results
      - `#show`: call services to get forecast data, and then display the `#index` template above along with a partial template to show the current temperature and a table of forecasts (daily min/max temperatures)

### Service

    - coordinate busines logic to serve weather forecast data using input address from the controller
        - APIs
            - geolocation: use input address to get a standardized zip code, latitude and longitude
            - weather data: use latitude and longitude from geolocation response (from above) as input to get data for this location
        - Caching
            - cache weather data, using zip code from geolocation as the key, with an expiration of 30 minutes
    - the geolocation API will always be called to parse the input address for its zip code
        - if the zip code exists in the cache, return this data
        - otherwise, fetch from the weather data API

### View (ERB)

    - the index view shows the search form for a user to enter an address to search for weather data
    - the show view is included as a partial view to the index view to display the search results

## Considerations & Future Improvements

    - *urgent*: api key to an API is hardcoded within code in this repo - update documentation to guide developers to get individual key(s), use `.env`, `.gitignore`, and secrets management capibilities for source-control management, CI/CD, deployment processes
    - improve validation/security for inputs within controller (i.e. code injections, fail faster than first API call)
    - refactor service class to use command pattern for each of the 2 API calls
    - design adapter for each of the 2 API calls to use alternative APIs, ideally configurable
        - each API would still require customization/transformation for request parameters / request bodies
    - separate concerns and data dependencies within Controller / Service / View
        - standardize / create a data interface (DTO/VO) from controller <-> service
        - standardize / create a data interface (REST) from controller <-> view
        - use ReactJS or any other framework than ERB templates for view
