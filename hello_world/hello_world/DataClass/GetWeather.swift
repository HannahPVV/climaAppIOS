//
//  GetWeather.swift
//  hello_world
//
//  Created by Hannah Valencia on 27/04/26.
//
import Foundation


struct GetWeatherCodable: Codable {
    let name: String?
    let main: Main?
    let weather: [Weather]?
    let wind: Wind?

    struct Main: Codable {
        let temp: Double?
        let feels_like: Double?
        let humidity: Int?
    }

    struct Weather: Codable {
        let main: String?
        let description: String?
        let icon: String?
    }

    struct Wind: Codable {
        let speed: Double?
    }
}
