//
//  HomeModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/03/26.
//

import Foundation

struct HomeWeather {
    let current: CurrentWeatherModel
    let hourlyForecast: [HourlyForecastModel]
    let metrics: [WeatherMetr]
    
}
