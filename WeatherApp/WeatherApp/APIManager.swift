//
//  APIManager.swift
//  WeatherApp
//
//  Created by Nikita Skripka on 24.12.2023.
//

import Foundation

final class APIManager {
    
    static func getData(completion: @escaping (Weather) -> Void) {
        let apiKey = "d46554a6cfc3c84d6e155b926f153ca8"
        
        let urlString =  "https://api.openweathermap.org/data/2.5/weather?q=Ussuriysk,ru&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data else {
                print(error?.localizedDescription)
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                completion(weather)
            } catch {
                
            }
        }.resume()
    }
}
