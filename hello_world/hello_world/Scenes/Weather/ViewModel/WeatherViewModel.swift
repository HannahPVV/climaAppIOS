//
//  WeatherViewModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import Foundation


class WeatherViewModel {
    
    // MARK: - Model
    private let model: WeatherScreenModel
    
    init(model: WeatherScreenModel) {
        self.model = model
    }
    
    // MARK: - Current Weather
    var currentWeather: CurrentWeatherModel {
        model.currentWeather
    }
    
    // MARK: - Hourly Forecast
    var hourlyForecast: [HourlyForecastModel] {
        model.hourlyForecast
    }
    
    // MARK: - Details
    var details: WeatherDetailsModel {
        model.details
    }
}
