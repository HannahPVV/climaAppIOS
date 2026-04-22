//
//  WeatherMetricModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 22/04/26.
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
        "\(uvIndex)"
    }
    
    var windSpeedText: String {
        "\(windSpeed) m/s"
    }
    
    var precipitationText: String {
        "\(precipitation ?? 0) mm"
    }
    
    var humidityText: String {
        "\(humidity)%"
    }
}
