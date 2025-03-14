# Weather Forecast Application

## Overview

This web application provides the current temperature and forecasted temperatures for a user-provided address. It utilizes caching to store weather data for up to 30 minutes, ensuring efficiency and reducing API calls. If a previously requested zip code exists in the cache, the stored data is returned; otherwise, new data is fetched from third-party APIs and cached for future use.

Built with **Ruby on Rails**, this application leverages Rails' built-in caching mechanism and renders views using ERB templates.

### Third-Party APIs Used

- **[Google Maps Geocoding API](https://developers.google.com/maps/documentation/geocoding)**

  - Converts user-provided addresses into zip codes (for caching) and latitude/longitude coordinates (for weather lookup).

- **[Open-Meteo Free Weather API](https://open-meteo.com/)**
  - Retrieves weather data based on latitude and longitude.

### Current Status

This repository is intended for local development and testing. Plans for production readiness are outlined in the **Future Improvements** section below.

---

## Demo

https://github.com/user-attachments/assets/3c0fe333-5c1f-4845-a4a3-9e19729a085d

---

## Local Development Setup

### Prerequisites

- **Operating System**: macOS (ARM)
- **Ruby Version**: 3.3.4

### Setup Instructions

1. Clone the repository and navigate into the project directory:

   ```sh
   git clone git@github.com:ritchlee/weather_forecasts.git
   cd weather_forecasts
   ```

2. Install dependencies:

   ```sh
   bundle install
   ```

3. Enable Rails caching:

   ```sh
   rails dev:cache
   ```

4. Start the Rails server:

   ```sh
   rails server
   ```

5. Open the application in your browser:  
   [http://localhost:3000](http://localhost:3000)

### Running Tests

Execute the following command from the project root:

```sh
rspec
```

---

## Application Design

This application follows a structured architecture, with key components including **Controllers**, **Services**, and **Views**.

### **Controller**

- Validates incoming request parameters.
- Minimizes data transformations to ensure consistency across actions.
- Delegates business logic to services.
- Manages responses for different formats (e.g., JSON, XML, ERB templates).

#### Supported Actions

| Action   | Description                                                                                                           |
| -------- | --------------------------------------------------------------------------------------------------------------------- |
| `#index` | Displays a form where users can enter an address to retrieve weather data.                                            |
| `#show`  | Calls the service layer to fetch weather data, then displays results within the `#index` template via a partial view. |

### **Service**

- Handles business logic for weather forecasting.
- Manages API calls:
  - **Geolocation API**: Retrieves standardized zip codes, latitude, and longitude.
  - **Weather API**: Uses latitude and longitude to fetch weather data.
- Implements caching:
  - Uses the zip code as the cache key.
  - Stores weather data for 30 minutes to optimize performance.
- Always calls the geolocation API first:
  - If the zip code is in cache, returns cached data.
  - Otherwise, fetches new data from the weather API.

### **View (ERB Templates)**

- **Index View**: Contains a search form for users to enter an address.
- **Show View (Partial Template)**: Displays search results, including current temperature and a forecast table.

---

## Future Improvements & Considerations

### **Urgent**

- **Secure API Keys**:
  - Currently, an API key is hardcoded in the codebase.
  - Implement `.env` for storing API keys securely.
  - Use `.gitignore` to prevent secrets from being committed.
  - Follow best practices for secrets management in CI/CD pipelines.

### **Enhancements**

- **Improve Input Validation & Security**:
  - Strengthen input sanitization to prevent code injection and other security risks.
  - Implement early validation to fail fast before making API calls.
- **Refactor Service Layer**:
  - Use a **Command Pattern** to modularize API calls.
- **Design API Adapters**:
  - Create an abstraction layer to support alternative geolocation/weather APIs.
  - Allow API configuration to be set dynamically.
- **Improve Separation of Concerns**:
  - Standardize data interfaces between Controller, Service, and View.
  - Implement **DTOs (Data Transfer Objects)** for structured data handling.
  - Consider switching from ERB templates to a modern frontend framework (e.g., **React.js**).
- **Support Dynamic Queries**:
  - Implement parameters on view and service for temperature units, other weather data besides temperature, forecast intervals, etc.
  - Currently supports only Fahrenheit, and temperatures for weather data, fixed at 7-days of forecasts
    **Improve Error Handling**:
  - Return proper response for bad requests (input validation)
  - Raise API request/response failures and propogate to controller for error messaging
