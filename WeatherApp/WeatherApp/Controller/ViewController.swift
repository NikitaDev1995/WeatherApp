//
//  ViewController.swift
//  WeatherApp
//
//  Created by Nikita Skripka on 23.12.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.getData()
        }
    }
    
//    Optional("{\"coord\":{\"lon\":10.99,\"lat\":44.34},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"base\":\"stations\",\"main\":{\"temp\":286.27,\"feels_like\":285.15,\"temp_min\":280.86,\"temp_max\":291.56,\"pressure\":1007,\"humidity\":58,\"sea_level\":1007,\"grnd_level\":923},\"visibility\":10000,\"wind\":{\"speed\":1.7,\"deg\":194,\"gust\":3.63},\"clouds\":{\"all\":56},\"dt\":1703335516,\"sys\":{\"type\":1,\"id\":6812,\"country\":\"IT\",\"sunrise\":1703314173,\"sunset\":1703346009},\"timezone\":3600,\"id\":3163858,\"name\":\"Zocca\",\"cod\":200}")


