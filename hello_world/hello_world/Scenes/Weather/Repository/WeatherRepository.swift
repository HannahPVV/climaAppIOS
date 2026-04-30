//
//  WeatherRepository.swift
//  hello_world
//
//  Created by Hannah Valencia on 27/04/26.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func getWeather() async throws -> GetWeatherCodable
    func getForecast() async throws -> GetForecastCodable
    func getWeather(_ request: [String: Any]) async throws -> GetWeatherCodable // EXAMPLE WITH REQUEST
}

actor WeatherRepository: WeatherRepositoryProtocol {
    
    // MARK: - GET WEATHER (default)
    func getWeather() async throws -> GetWeatherCodable {
        let request = ApiRequestModel(
            endpoint: .GET_WEATHER,
            method: .get,
            header: .noHeader,
            encoding: .url,
            parameters: [
                "lat": 20.5888,
                "lon": -100.3899,
                "appid": "f94944b51f39084eb06c09878700090f",
                "units": "metric",
                "lang": "es"
            ]
        )
        
        let response = try await ApiService.shared.request(
            request,
            GetWeatherCodable.self
        )
        
        return response
    }
    
    // MARK: - EXAMPLE WITH PARAMS (igual que List)
    func getWeather(_ request: [String: Any]) async throws -> GetWeatherCodable {
        let request = ApiRequestModel(
            endpoint: .GET_WEATHER,
            method: .get,
            header: .noHeader,
            encoding: .url,
            parameters: request
        )
        
        let response = try await ApiService.shared.request(
            request,
            GetWeatherCodable.self
        )
        
        return response
    }
    
    func getForecast() async throws -> GetForecastCodable {
        let request = ApiRequestModel(
            endpoint: .GET_FORECAST,
            method: .get,
            header: .noHeader,
            encoding: .url,
            parameters: [
                "lat": 20.5888,
                "lon": -100.3899,
                "appid": "f94944b51f39084eb06c09878700090f",
                "units": "metric",
                "lang": "es"
            ]
        )
        
        let response = try await ApiService.shared.request(
            request,
            GetForecastCodable.self
        )
        
        return response
    }
}
