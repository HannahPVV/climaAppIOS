//
//  WeatherCondition.swift
//  hello_world
//
//  Created by Hannah Valencia on 22/04/26.
//

import Foundation

enum WeatherCondition {
    case sunny
    case cloudy
    case rainy
    case storm
    case wind
}

extension WeatherCondition {
    var iconName: String {
        switch self {
        case .sunny:
            return "sun.max"
        case .cloudy:
            return "cloud"
        case .rainy:
            return "cloud.rain"
        case .storm:
            return "cloud.bolt"
        case .wind:
            return "wind"
        }
    }
}
