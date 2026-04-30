//
//  Untitled.swift
//  hello_world
//
//  Created by Hannah Valencia on 29/04/26.
//

struct GetForecastCodable: Codable {
    let list: [ForecastItem]?

    struct ForecastItem: Codable {
        let dt: Int?
        let main: Main?
        let weather: [Weather]?
        let pop: Double? 

        struct Main: Codable {
            let temp: Double?
        }

        struct Weather: Codable {
            let main: String?
            let description: String?
            let icon: String?
        }
    }
}
