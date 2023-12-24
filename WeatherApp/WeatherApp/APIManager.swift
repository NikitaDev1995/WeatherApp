//
//  APIManager.swift
//  WeatherApp
//
//  Created by Nikita Skripka on 24.12.2023.
//

import Foundation

final class APIManager {
    
    static func getData() {
        let apiKey = "d46554a6cfc3c84d6e155b926f153ca8"
        
        let urlString =  "https://api.openweathermap.org/data/2.5/weather?q=Saint Petersburg&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data else {
                print(error?.localizedDescription)
                return
            }
            
            do {
                let jsonDecode = try JSONDecoder().decode(DataModel.self, from: data)
                print(jsonDecode.weather.first?.icon)
            } catch {
                
            }
        }.resume()
    }
}
