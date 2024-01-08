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

    //MARK: - Properties
    var shouldDisplayWeek: Bool = true
    var defaultCity: String = "Moscow"
    
    //MARK: - Life Scene Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        loadData(city: defaultCity)
        
        let nib = UINib(nibName: "WeatherConditionCollectionViewCell", bundle: nil)
        weatherConditionCollectionViewOutlet.register(nib.self, forCellWithReuseIdentifier: "WeatherConditionCell")
        weatherConditionCollectionViewOutlet.delegate = self
        weatherConditionCollectionViewOutlet.dataSource = self
    }
    
    //MARK: - Methods
    private func configureNavigationController() {
        title = defaultCity
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.backgroundColor = UIColor(hexString: "#28247D")
        dateLabelOutlet.textColor = UIColor(hexString: "DEDDDD")
        tempLabelOutlet.textColor = .white
        conditionLabelOutlet.textColor = UIColor(hexString: "DEDDDD")
        weatherDataViewOutlet.backgroundColor = UIColor(hexString: "#957DCD")
        weatherDataViewOutlet.layer.cornerRadius = 10
        
    }
    
    private func getCurrentTime() -> Int {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let currentTimeString = Int(dateFormatter.string(from: currentDate)) ?? 0
        
        return currentTimeString
    }
    
    private func loadData(city: String) {
        APIManager.getData(city: city) { [weak self] result in
            
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
        
        let controller = UIAlertController(title: "Error", message: textMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        controller.addAction(ok)
        
        self.present(controller, animated: true)
    }
    
    //MARK: - @IBActions
    @IBAction func refreshBarButtonAction(_ sender: UIBarButtonItem) {
        loadData(city: defaultCity)
        weatherConditionCollectionViewOutlet.reloadData()
    }
    
    @IBAction func todayWeatherButtonAction(_ sender: UIButton) {
        shouldDisplayWeek = false
        weatherConditionCollectionViewOutlet.reloadData()
    }
    
    @IBAction func weekWeatherButtonAction(_ sender: UIButton) {
        shouldDisplayWeek = true
        weatherConditionCollectionViewOutlet.reloadData()
    }
    
    @IBAction func changeCityButtonAction(_ sender: UIButton) {
        let allertController = UIAlertController(title: "Write a city", message: nil, preferredStyle: .alert)
        allertController.addTextField { (textField) in
            textField.placeholder = "City"
        }
        let findAlertButton = UIAlertAction(title: "Find", style: .default) { _ in
            self.defaultCity = allertController.textFields?[0].text ?? ""
            self.title = allertController.textFields?[0].text ?? ""
            self.loadData(city: self.defaultCity)
            self.weatherConditionCollectionViewOutlet.reloadData()
        }
        let cancelAlertButton = UIAlertAction(title: "Cancel", style: .cancel)
        allertController.addAction(findAlertButton)
        allertController.addAction(cancelAlertButton)
        self.present(allertController, animated: true)
    }
    
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if shouldDisplayWeek {
            return 5
        } else {
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherConditionCell", for: indexPath) as! WeatherConditionCollectionViewCell
            
            if shouldDisplayWeek {
                APIManager.getData(city: defaultCity) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let weather):
                            if let weather {
                                var index: [Int] = []
                                for i in weather.list.indices {
                                    if i % 8 == 0 {
                                        index.append(i)
                                    }
                                }
                                cell.configureWeatherConditionCell(weather, index[indexPath.row], isWeek: self?.shouldDisplayWeek ?? true)
                            }
                        case .failure(let error):
                            self?.showError(error)
                        }
                    }
                }
            } else {
                APIManager.getData(city: defaultCity) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let weather):
                            if let weather {
                                var index: [Int] = []
                                for i in weather.list.indices {
                                    index.append(i)
                                }
                                cell.configureWeatherConditionCell(weather, index[indexPath.row], isWeek: self?.shouldDisplayWeek ?? false)
                            }
                        case .failure(let error):
                            self?.showError(error)
                        }
                    }
                }
            }
            return cell
    }
}
    
