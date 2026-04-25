//
//  ExploreModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 22/04/26.
//

import UIKit

// MARK: - Tipo de clima que hay
enum WeatherType: String {
    case sunny  = "Soleado"
    case cloudy = "Nublado"
    case rainy  = "Lluvia"
    case snowy  = "Nevado"

    //icono del clima
    var icon: String {
        switch self {
        case .sunny:  return "sun.max.fill"
        case .cloudy: return "cloud.fill"
        case .rainy:  return "cloud.rain.fill"
        case .snowy:  return "cloud.snow.fill"
        }
    }

    var iconColor: UIColor {
        switch self {
        case .sunny:  return UIColor(red: 1.0,  green: 0.78, blue: 0.10, alpha: 1)
        case .cloudy: return UIColor(red: 0.75, green: 0.85, blue: 0.95, alpha: 1)
        case .rainy:  return UIColor(red: 0.65, green: 0.80, blue: 0.95, alpha: 1)
        case .snowy:  return UIColor(red: 0.75, green: 0.88, blue: 1.00, alpha: 1)
        }
    }

    static var allCases: [WeatherType] { [.sunny, .cloudy, .rainy, .snowy] }
}

// MARK: - variables de una ubicacion
struct LocationModel {
    var city: String
    var temperature: Int
    var weather: WeatherType
}

// MARK: - ubicaciones guardadas 
struct ExploreModel {
    var locations: [LocationModel] = [
        LocationModel(city: "Zibatá",      temperature: 23, weather: .cloudy),
        LocationModel(city: "Guadalajara", temperature: 20, weather: .rainy),
        LocationModel(city: "CDMX",        temperature: 23, weather: .sunny),
        LocationModel(city: "Londres",     temperature:  2, weather: .snowy)
    ]
}
