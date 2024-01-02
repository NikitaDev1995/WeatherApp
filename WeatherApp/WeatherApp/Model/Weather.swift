//
//  Weather.swift
//  WeatherApp
//
//  Created by Nikita Skripka on 24.12.2023.
//

import Foundation

struct Weather: Codable {
    struct List: Codable {
        struct Temperature: Codable {
            var temp: Double
            var humidity: Int
            var pressure: Int
        }
        
        struct WeatherConditions: Codable {
            var main: String
        }
        
        struct Wind: Codable {
            var speed: Double
        }
        
        var main: Temperature
        var weather: [WeatherConditions]
        var wind: Wind
        var dt_txt: String
    }
    
    var list: [List]
}
