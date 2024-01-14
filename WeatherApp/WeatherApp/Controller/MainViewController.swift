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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tempLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var humidityLabelOutlet: UILabel!
    @IBOutlet weak var windSpeedLabelOutlet: UILabel!
    @IBOutlet weak var pressureLabelOutlet: UILabel!
    @IBOutlet weak var weatherDataViewOutlet: UIView!
    @IBOutlet weak var weatherConditionCollectionViewOutlet: UICollectionView!
    @IBOutlet weak var pressureLocalizationLabelOutlet: UILabel!
    @IBOutlet weak var humidityLocalizationLabelOutle: UILabel!
    @IBOutlet weak var windSpeedLocalizationLabelOutlet: UILabel!
    @IBOutlet weak var todayLocalizationButtonOutlet: UIButton!
    @IBOutlet weak var forecastLocalizationButtonOutlet: UIButton!
    @IBOutlet weak var anotherCityLocalizationButtonOutlet: UIButton!
    
    //MARK: - Properties
    var shouldDisplayWeek: Bool = true
    var defaultCity: String = "Moscow"
    var times: [Int] = []
    
    //MARK: - Life Scene Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "WeatherConditionCollectionViewCell", bundle: nil)
        
        weatherConditionCollectionViewOutlet.register(nib.self, forCellWithReuseIdentifier: "WeatherConditionCell")
        weatherConditionCollectionViewOutlet.delegate = self
        weatherConditionCollectionViewOutlet.dataSource = self
        
        configureNavigationController()
        loadData(city: defaultCity)
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
        pressureLocalizationLabelOutlet.text = NSLocalizedString("MainViewController.pressure.label.text", comment: "")
        humidityLocalizationLabelOutle.text = NSLocalizedString("MainViewController.humidity.label.text", comment: "")
        windSpeedLocalizationLabelOutlet.text = NSLocalizedString("MainViewController.speedWind.label.text", comment: "")
        todayLocalizationButtonOutlet.setTitle(NSLocalizedString("MainViewController.today.button.text", comment: ""), for: .normal)
        forecastLocalizationButtonOutlet.setTitle(NSLocalizedString("MainViewController.daysForecasts.button.text", comment: ""), for: .normal)
        anotherCityLocalizationButtonOutlet.setTitle(NSLocalizedString("MainViewController.anotherCity.button.text", comment: ""), for: .normal)
    }

    private func changeDateTextOutlet(date: String) -> String {
        let inputString = date
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = inputFormatter.date(from: inputString)
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm dd-MM-yyyy"
        let outputString = outputFormatter.string(from: date!)
        
        return outputString
    }
    
    private func loadData(city: String) {
        self.activityIndicator.startAnimating()
        
        func displayData(weather: Weather, index: Int) {
            self.conditionLabelOutlet.text = weather.list[index].weather.first?.main
            switch weather.list[index].weather.first?.main {
            case "Clouds": self.imageViewOutlet.image = UIImage(named: "Clouds")
            case "Clear": self.imageViewOutlet.image = UIImage(named: "Clear")
            case "Snow": self.imageViewOutlet.image = UIImage(named: "Snow")
            case "Rain": self.imageViewOutlet.image = UIImage(named: "Rain")
            case "Drizzle": self.imageViewOutlet.image = UIImage(named: "Drizzle")
            case "Thunderstorm": self.imageViewOutlet.image = UIImage(named: "Thunderstorm")
            default: break
            }
            
            self.tempLabelOutlet.text = "\(Int(weather.list[index].main.temp))°"
            self.dateLabelOutlet.text = changeDateTextOutlet(date: weather.list[index].dt_txt)
            self.pressureLabelOutlet.text = "\(Double(weather.list[index].main.pressure) * 0.75)"
            self.humidityLabelOutlet.text = "\(weather.list[index].main.humidity)%"
            self.windSpeedLabelOutlet.text = "\(weather.list[index].wind.speed)km/h"
        }
        
        APIManager.getData(city: city) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    if let weather {
                        for (index, i) in weather.list.enumerated() {
                            if index == 8 {
                                break
                            }
                            let index13 = i.dt_txt.index(i.dt_txt.startIndex, offsetBy: 11)
                            let index14 = i.dt_txt.index(i.dt_txt.startIndex, offsetBy: 12)
                            let letter13 = String(i.dt_txt[index13])
                            let letter14 = String(i.dt_txt[index14])
                            let time = letter13 + letter14
                            if let time = Int(time) {
                                self!.times.append(time)
                            }
                        }
                        
                        let time: Int = Weather.getCurrentTime(times: self!.times)
                        
                        switch time {
                        case 0:
                            displayData(weather: weather, index: 0)
                        case 1:
                            displayData(weather: weather, index: 1)
                        case 2:
                            displayData(weather: weather, index: 2)
                        case 3:
                            displayData(weather: weather, index: 3)
                        case 4:
                            displayData(weather: weather, index: 4)
                        case 5:
                            displayData(weather: weather, index: 5)
                        case 6:
                            displayData(weather: weather, index: 6)
                        case 7:
                            displayData(weather: weather, index: 7)
                        default: break
                        }
                        self?.title = self?.defaultCity
                        self?.weatherConditionCollectionViewOutlet.reloadData()
                    } else {
                        self?.showError(nil)
                    }
                case .failure(let error):
                    self?.showError(error)
                    return
                }
                self!.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func showError(_ error: Error?) {
        let textMessage = error == nil ? NSLocalizedString("MainViewController.textMessageErrorAlertController", comment: "") : error?.localizedDescription
        let controller = UIAlertController(title: NSLocalizedString("MainViewController.titleMessageErrorAllertController", comment: ""), message: textMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        controller.addAction(ok)
        self.present(controller, animated: true)
    }
    
    //MARK: - @IBActions
    @IBAction func refreshBarButtonAction(_ sender: UIBarButtonItem) {
        imageViewOutlet.image = UIImage()
        activityIndicator.isHidden = false
        loadData(city: defaultCity)
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
        let allertController = UIAlertController(title: NSLocalizedString("MainViewController.titleAllertController", comment: ""), message: nil, preferredStyle: .alert)
        allertController.addTextField { (textField) in
            textField.delegate = self
            textField.placeholder = NSLocalizedString("MainViewController.placeholderAllertController", comment: "")
        }
        
        let findAlertButton = UIAlertAction(title: NSLocalizedString("MainViewController.findButtonAllertController", comment: ""), style: .default) { _ in
            
            if let textField = allertController.textFields?.first?.text,
               !textField.isEmpty {
                self.defaultCity = textField
                self.loadData(city: self.defaultCity)
            } else {
                return
            }
        }
        
        let cancelAlertButton = UIAlertAction(title: NSLocalizedString("MainViewController.cancelButtonAllertController", comment: ""), style: .cancel)
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
        cell.weatherConditionImageOutlet.image = UIImage()
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
            if shouldDisplayWeek {
                APIManager.getData(city: defaultCity) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let weather):
                            if let weather {
                                var index: [Int] = []
                                for i in weather.list.indices {
                                    if i % 8 == 0 {
                                        index.append(i + Weather.getCurrentTime(times: self!.times))
                                    }
                                }
                                cell.configureWeatherConditionCell(weather, index[indexPath.row], isWeek: self?.shouldDisplayWeek ?? true)
                            }
                        case .failure(let error):
                            self?.showError(error)
                        }
                        cell.activityIndicator.stopAnimating()
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
                        cell.activityIndicator.stopAnimating()
                    }
                }
            }
            return cell
    }
}
    
extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " " {
            return false
        }
        return true
    }
}
