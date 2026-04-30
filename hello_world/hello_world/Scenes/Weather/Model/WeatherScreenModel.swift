//
//  WeatherModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import Foundation

struct WeatherScreenModel {
    var currentWeather: CurrentWeatherModel
    var hourlyForecast: [HourlyForecastModel]
    var details: WeatherDetailsModel
}
