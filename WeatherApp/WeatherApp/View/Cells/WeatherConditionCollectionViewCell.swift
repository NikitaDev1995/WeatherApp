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
    
    func configureWeatherConditionCell(_ weather: Weather, _ indexForWeatherList: Int) {
        
        let str = weather.list[indexForWeatherList].dt_txt
        // Разбиваем строку на две части: дату и время
        let components = str.components(separatedBy: " ")
        // Получаем дату из первой части
        let date = components[0]
        // Разбиваем дату на год, месяц и день
        let dateComponents = date.components(separatedBy: "-")
        // Получаем месяц и день
        let month = dateComponents[1]
        let day = dateComponents[2]
        // Меняем местами месяц и день
        let newDate = "\(day)-\(month)"
        
        timeLabelOutlet.text = newDate
        switch weather.list[indexForWeatherList].weather.first?.main {
        case "Clouds": self.weatherConditionImageOutlet.image = UIImage(named: "Clouds")
        case "Clear": self.weatherConditionImageOutlet.image = UIImage(named: "Clear")
        case "Snow": self.weatherConditionImageOutlet.image = UIImage(named: "Snow")
        case "Rain": self.weatherConditionImageOutlet.image = UIImage(named: "Rain")
        case "Drizzle": self.weatherConditionImageOutlet.image = UIImage(named: "Drizzle")
        case "Thunderstorm": self.weatherConditionImageOutlet.image = UIImage(named: "Thunderstorm")
        default: break
        }
        weatherDegreeOutlet.text = "\(weather.list[indexForWeatherList].main.temp)"
    }
    
}
