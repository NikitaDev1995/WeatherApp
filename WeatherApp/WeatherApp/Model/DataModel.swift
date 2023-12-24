//
//  DataModel.swift
//  WeatherApp
//
//  Created by Nikita Skripka on 24.12.2023.
//

import Foundation

struct DataModel: Codable {
    struct Weather: Codable {
        var main: String
        var description: String
        var icon: String
    }
    struct Wind: Codable {
        var speed: Double
    }
    struct Temperature: Codable {
        var temp: Double
        var feels_like: Double
    }
    
    var weather: [Weather]
    var wind: Wind
    var main: Temperature
}
