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
    
    
    
    
    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    //MARK: - Life Scene Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        loadData()
        
        collectionViewOutlet.delegate = self
        collectionViewOutlet.dataSource = self
    }
    
    //MARK: - Methods
    private func configureNavigationController() {
        title = "Ussuriysk"
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.backgroundColor = .darkVioletColor
        dateLabelOutlet.textColor = .grayColor
        tempLabelOutlet.textColor = .white
        conditionLabelOutlet.textColor = .grayColor
    }
    
    private func loadData() {
            APIManager.getData(city: "Ussuriysk") { [weak self] result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weather):
                        if let weather {
                           
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
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    
}

//    Optional("{\"coord\":{\"lon\":10.99,\"lat\":44.34},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"base\":\"stations\",\"main\":{\"temp\":286.27,\"feels_like\":285.15,\"temp_min\":280.86,\"temp_max\":291.56,\"pressure\":1007,\"humidity\":58,\"sea_level\":1007,\"grnd_level\":923},\"visibility\":10000,\"wind\":{\"speed\":1.7,\"deg\":194,\"gust\":3.63},\"clouds\":{\"all\":56},\"dt\":1703335516,\"sys\":{\"type\":1,\"id\":6812,\"country\":\"IT\",\"sunrise\":1703314173,\"sunset\":1703346009},\"timezone\":3600,\"id\":3163858,\"name\":\"Zocca\",\"cod\":200}")


