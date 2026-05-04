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
    private let repository: any WeatherRepositoryProtocol = WeatherRepository()

    // MARK: - Published
    @Published var locations: [LocationModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    init() {
        locations = model.locations
    }

    // MARK: - Public
    func addLocation(city: String) {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            do {
                let response = try await repository.getWeather(byCity: city)

                let weatherType = mapWeatherType(response.weather?.first?.main)
                let temperature = Int(response.main?.temp ?? 0)
                let cityName    = response.name ?? city

                let newLocation = LocationModel(
                    city: cityName,
                    temperature: temperature,
                    weather: weatherType
                )

                model.locations.append(newLocation)
                locations = model.locations

            } catch {
                errorMessage = "No se encontró '\(city)'. Verifica el nombre e intenta de nuevo."
            }

            isLoading = false
        }
    }

    // MARK: - Private
    private func mapWeatherType(_ value: String?) -> WeatherType {
        switch value?.lowercased() {
        case "clear":                return .sunny
        case "clouds":               return .cloudy
        case "rain", "drizzle":      return .rainy
        case "snow":                 return .snowy
        default:                     return .sunny
        }
    }
}
