//
//  ExploreViewModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 22/04/26.
//

import Foundation
import Combine

class ExploreViewModel {

    // MARK: - Model
    private var model: ExploreModel = .init()

    // MARK: - Published
    @Published var locations: [LocationModel] = []

    init() {
        locations = model.locations
    }

    // MARK: - Public
    func addLocation(city: String) {
        let weather = WeatherType.allCases.randomElement() ?? .sunny

        let temperature: Int = {
            switch weather {
            case .snowy:  return Int.random(in: -5...5)
            case .rainy:  return Int.random(in: 8...18)
            case .cloudy: return Int.random(in: 10...22)
            case .sunny:  return Int.random(in: 20...35)
            }
        }()

        let newLocation = LocationModel(city: city, temperature: temperature, weather: weather)
        model.locations.append(newLocation)
        locations = model.locations
    }
}
