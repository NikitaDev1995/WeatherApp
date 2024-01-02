//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Nikita Skripka on 23.12.2023.
//

import UIKit

final class MainViewController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var conditionLabelOutlet: UILabel!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var tempLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var humidityLabelOutlet: UILabel!
    @IBOutlet weak var windSpeedLabelOutlet: UILabel!
    @IBOutlet weak var pressureLabelOutlet: UILabel!
    
    @IBOutlet weak var weatherDataViewOutlet: UIView!
    
    
    @IBOutlet weak var weatherConditionCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var weatherCityCollectionViewOutlet: UICollectionView!
    
    //MARK: - Life Scene Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        loadData()
        
        let nib = UINib(nibName: "WeatherConditionCollectionViewCell", bundle: nil)
        weatherConditionCollectionViewOutlet.register(nib.self, forCellWithReuseIdentifier: "WeatherConditionCell")
        weatherConditionCollectionViewOutlet.delegate = self
        weatherConditionCollectionViewOutlet.dataSource = self
        //weatherCityCollectionViewOutlet.delegate = self
        //weatherCityCollectionViewOutlet.dataSource = self
        
    }
    
    //MARK: - Methods
    private func configureNavigationController() {
        title = "Ussuriysk"
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.backgroundColor = UIColor(hexString: "#28247D")
        dateLabelOutlet.textColor = UIColor(hexString: "DEDDDD")
        tempLabelOutlet.textColor = .white
        conditionLabelOutlet.textColor = UIColor(hexString: "DEDDDD")
        weatherDataViewOutlet.backgroundColor = UIColor(hexString: "#957DCD")
        weatherDataViewOutlet.layer.cornerRadius = 10
        
    }
    
    private func loadData() {
        APIManager.getData(city: "Ussuriysk") { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    if let weather {
                        self?.conditionLabelOutlet.text = weather.list.first?.weather.first?.main
                        switch weather.list.first?.weather.first?.main {
                        case "Clouds": self?.imageViewOutlet.image = UIImage(named: "Clouds")
                        case "Clear": self?.imageViewOutlet.image = UIImage(named: "Clear")
                        case "Snow": self?.imageViewOutlet.image = UIImage(named: "Snow")
                        case "Rain": self?.imageViewOutlet.image = UIImage(named: "Rain")
                        case "Drizzle": self?.imageViewOutlet.image = UIImage(named: "Drizzle")
                        case "Thunderstorm": self?.imageViewOutlet.image = UIImage(named: "Thunderstorm")
                        default: break
                        }
                        self?.tempLabelOutlet.text = "\(weather.list.first?.main.temp ?? 0)"
                        self?.dateLabelOutlet.text = weather.list[0].dt_txt
                        self?.pressureLabelOutlet.text = "\(Double(weather.list.first?.main.pressure ?? 0) * 0.75)"
                        self?.humidityLabelOutlet.text = "\(weather.list.first?.main.humidity ?? 0)%"
                        self?.windSpeedLabelOutlet.text = "\(weather.list.first?.wind.speed ?? 0)km/h"
                    } else {
                        self?.showError(nil)
                    }
                case .failure(let error):
                    self?.showError(error)
                }
            }
        }
    }
    
    private func showError(_ error: Error?) {
        let textMessage = error == nil ? "Data is empty" : error?.localizedDescription
        
        let controller = UIAlertController(title: "Произошла ошибка", message: textMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        controller.addAction(ok)
        
        self.present(controller, animated: true)
    }
    
    //MARK: - @IBActions
    @IBAction func refreshBarButtonAction(_ sender: UIBarButtonItem) {
        
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == weatherConditionCollectionViewOutlet {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherConditionCell", for: indexPath) as! WeatherConditionCollectionViewCell

            APIManager.getData(city: "Ussuriysk") { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        
                        if let weather {
                            cell.configureWeatherConditionCell(weather)
                        }
                    case .failure(let error):
                        self?.showError(error)
                    }
                }
            }
            return cell
        } else if collectionView == weatherCityCollectionViewOutlet {
            
        }
        return UICollectionViewCell()
    }
}
    
