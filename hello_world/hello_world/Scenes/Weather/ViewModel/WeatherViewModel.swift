//
//  WeatherViewModel.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import Foundation


import Foundation

class WeatherViewModel {
    
    // MARK: - PRIVATE PROPERTIES
    private var model: WeatherScreenModel
    private let repository: any WeatherRepositoryProtocol
    
    // MARK: - INIT
    init() {
        self.model = WeatherScreenModel(
            currentWeather: CurrentWeatherModel(
                city: "",
                temperature: 0,
                condition: .unknown
            ),
            hourlyForecast: [],
            details: WeatherDetailsModel(
                feelsLike: 0,
                uvIndex: 0,
                windSpeed: 0,
                precipitation: 0,
                humidity: 0
            )
        )
        
        self.repository = WeatherRepository()
    }
    
    // MARK: - PUBLIC PROPERTIES
    var currentWeather: CurrentWeatherModel {
        get { model.currentWeather }
        set { model.currentWeather = newValue}
    }
    
    var hourlyForecast: [HourlyForecastModel] {
        get { model.hourlyForecast }
        set { model.hourlyForecast = newValue}
    }
    
    var details: WeatherDetailsModel {
        get { model.details }
        set { model.details = newValue}
    }
    
    var hasContent: Bool {
        !currentWeather.city.isEmpty
    }
    
    // MARK: - FUNCTIONS (igual que List)
    func getWeather() async throws {
        let response = try await repository.getWeather()
        
        // MAP API → UI MODEL
        currentWeather = CurrentWeatherModel(
            city: response.name ?? "Querétaro",
            temperature: response.main?.temp ?? 0,
            condition: mapCondition(response.weather?.first?.main)
        )
    }
    
    func getForecast() async throws {
        let response = try await repository.getForecast()
        
        //hourlyForecast = response.list?.prefix(8).map { item in
        hourlyForecast = response.list?.map { item in
            HourlyForecastModel(
                hourText: formatHour(from: item.dt),
                temperature: item.main?.temp ?? 0,
                condition: mapCondition(item.weather?.first?.main)
            )
        } ?? []
    }
    
    func getDetails() async throws {
        let current = try await repository.getWeather()
        let forecast = try await repository.getForecast()
          
        let maxPop = forecast.list?
            .prefix(8)
            .compactMap { $0.pop }
            .max() ?? 0
        
        details = WeatherDetailsModel(
            feelsLike: current.main?.feels_like ?? 0,
            uvIndex: 7,
            windSpeed: current.wind?.speed ?? 0,
            precipitation: maxPop * 100,
            humidity: current.main?.humidity ?? 0
        )
    }
    
    // MARK: - PRIVATE
    private func mapCondition(_ value: String?) -> WeatherCondition {
        switch value?.lowercased() {
        case "clear":
            return .sunny
        case "clouds":
            return .cloudy
        case "rain", "drizzle":
            return .rainy
        case "thunderstorm":
            return .storm
        case "snow":
            return .snowy
        case "wind":
            return .wind
        default:
            return .unknown
        }
    }
    
    
    private func formatHour(from timestamp: Int?) -> String {
        guard let timestamp = timestamp else { return "" }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        formatter.locale = Locale(identifier: "es_MX")
        formatter.timeZone = TimeZone(identifier: "America/Mexico_City")
        
        return formatter.string(from: date)
    }
    
    
    
}
