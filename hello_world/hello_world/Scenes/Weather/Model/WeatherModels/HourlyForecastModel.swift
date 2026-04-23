//
//  HourlyForecastModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//


import Foundation

struct HourlyForecastModel {
    let hourText: String
    let temperature: Double
    let condition: WeatherCondition
}

extension HourlyForecastModel {
    var temperatureText: String {
        "\(Int(temperature))°"
    }
}
