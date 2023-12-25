//
//  APIManager.swift
//  WeatherApp
//
//  Created by Nikita Skripka on 24.12.2023.
//

import Foundation

final class APIManager {
    
    static func getData(city: String = "Ussuriysk", completion: @escaping (Result<Weather?, Error>) -> Void) {
        let apiKey = "d46554a6cfc3c84d6e155b926f153ca8"
        
        let urlString =  "https://api.openweathermap.org/data/2.5/weather?q=\(city),ru&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            if let error {
                print(completion(.failure(error)))
            } else if let data {
                let weather = try? JSONDecoder().decode(Weather.self, from: data)
                completion(.success(weather))
                
            }
        }.resume()
    }
}
