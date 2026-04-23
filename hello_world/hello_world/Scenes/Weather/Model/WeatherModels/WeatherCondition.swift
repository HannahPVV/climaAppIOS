//
//  WeatherCondition.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import Foundation

enum WeatherCondition {
    case sunny
    case cloudy
    case rainy
    case storm
    case wind
    case snowy
    case unknown
}

extension WeatherCondition {
    var imageName: String {
        switch self {
        case .sunny:
            return "sunny"
        case .cloudy:
            return "cloudy"
        case .rainy:
            return "rainy"
        case .storm:
            return "storm"
        case .wind:
            return "wind"
        case .snowy:
            return "snowy"
        case .unknown:
            return "unknown"
        }
    }
}
