//
//  HourlyForecastModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 22/04/26.
//

import Foundation


struct HourlyForecastModel {
    let timestamp: Int
    let temperature: Double
    let condition: WeatherCondition
}

extension HourlyForecastModel {
    var temperatureText: String {
        return "\(Int(temperature))°"
    }
}
