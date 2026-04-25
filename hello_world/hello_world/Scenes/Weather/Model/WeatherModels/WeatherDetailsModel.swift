//
//  WeatherDetailsModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import Foundation

struct WeatherDetailsModel {
    let feelsLike: Double
    let uvIndex: Double
    let windSpeed: Double
    let precipitation: Double?
    let humidity: Int
}

extension WeatherDetailsModel {
    var feelsLikeText: String {
        "\(Int(feelsLike))°"
    }
    
    var uvIndexText: String {
        "\(Int(uvIndex))"
    }
    
    var windSpeedText: String {
        "\(Int(windSpeed)) km/h"
    }
    
    var precipitationText: String {
        "\(Int(precipitation ?? 0)) mm"
    }
    
    var humidityText: String {
        "\(humidity)%"
    }
}
