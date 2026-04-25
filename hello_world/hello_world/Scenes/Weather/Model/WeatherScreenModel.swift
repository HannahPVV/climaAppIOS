//
//  WeatherModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import Foundation

struct WeatherScreenModel {
    let currentWeather: CurrentWeatherModel
    let hourlyForecast: [HourlyForecastModel]
    let details: WeatherDetailsModel
}
