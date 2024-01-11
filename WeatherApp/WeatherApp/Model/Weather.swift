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
    
    //MARK: - Weather Properties
    var list: [List]
    
    //MARK: - Weather Methods
    static func getCurrentTime(times: [Int]) -> Int {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let currentTimeString = Int(dateFormatter.string(from: currentDate)) ?? 0

        switch currentTimeString {
        case 0..<3: return times.firstIndex(of: 0) ?? 0
        case 3..<6: return times.firstIndex(of: 3) ?? 0
        case 6..<9: return times.firstIndex(of: 6) ?? 0
        case 9..<12: return times.firstIndex(of: 9) ?? 0
        case 12..<15: return times.firstIndex(of: 12) ?? 0
        case 15..<18: return times.firstIndex(of: 15) ?? 0
        case 18..<21: return times.firstIndex(of: 18) ?? 0
        default: return times.firstIndex(of: 21) ?? 0
        }
    }
}
