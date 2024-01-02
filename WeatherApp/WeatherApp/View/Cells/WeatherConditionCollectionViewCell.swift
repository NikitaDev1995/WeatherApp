//
//  WeatherConditionCollectionViewCell.swift
//  WeatherApp
//
//  Created by Nikita Skripka on 30.12.2023.
//

import UIKit

class WeatherConditionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var timeLabelOutlet: UILabel!
    @IBOutlet weak var weatherConditionImageOutlet: UIImageView!
    @IBOutlet weak var weatherDegreeOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10
    }
    
    func configureWeatherConditionCell(_ weather: Weather) {
        timeLabelOutlet.text = weather.list.first?.dt_txt
        switch weather.list.first?.weather.first?.main {
        case "Clouds": self.weatherConditionImageOutlet.image = UIImage(named: "Clouds")
        case "Clear": self.weatherConditionImageOutlet.image = UIImage(named: "Clear")
        case "Snow": self.weatherConditionImageOutlet.image = UIImage(named: "Snow")
        case "Rain": self.weatherConditionImageOutlet.image = UIImage(named: "Rain")
        case "Drizzle": self.weatherConditionImageOutlet.image = UIImage(named: "Drizzle")
        case "Thunderstorm": self.weatherConditionImageOutlet.image = UIImage(named: "Thunderstorm")
        default: break
        }
        weatherDegreeOutlet.text = "\(weather.list.first?.main.temp ?? 0)"
    }
    
}
