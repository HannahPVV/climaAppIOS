//
//  WeatherViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - ViewModel
    let viewModel = WeatherViewModel()
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var currentWeatherCardView: UIView!

    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    @IBOutlet weak var metricsWeatherCardView: UIView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCard()
        configureDelegates()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getWeather()
    }
    
    private func configureCard() {
        currentWeatherCardView.layer.cornerRadius = 20
        currentWeatherCardView.clipsToBounds = true
        
        metricsWeatherCardView.layer.cornerRadius = 20
        metricsWeatherCardView.clipsToBounds = true
        
    
    }
    
    private func configureDelegates() {
        hourlyCollectionView.dataSource = self
        hourlyCollectionView.delegate = self
    }
    
    private func configureUI() {
        cityLabel.text = viewModel.currentWeather.city
        temperatureLabel.text = viewModel.currentWeather.temperatureText
        conditionImageView.image = UIImage(named: viewModel.currentWeather.condition.imageName)
        
        hourlyCollectionView.backgroundColor = .clear
        hourlyCollectionView.showsHorizontalScrollIndicator = false
        
        
        let d = viewModel.details
        feelsLikeLabel.text = d.feelsLikeText
        uvIndexLabel.text = d.uvIndexText
        windLabel.text = d.windSpeedText
        precipitationLabel.text = d.precipitationText
        humidityLabel.text = d.humidityText
    }
    
    
    
    private func getWeather() {
        Task {
            do {
                try await viewModel.getWeather()
                try await viewModel.getForecast()
                try await viewModel.getDetails()
                configureUI()
                hourlyCollectionView.reloadData()
                
                
                
            } catch {
                showAlert(title: "Oops...", message: error.localizedDescription)
            }
        }
    }
   
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.hourlyForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HourlyForecastCell",
            for: indexPath
        ) as! HourlyForecastCell
        
        let item = viewModel.hourlyForecast[indexPath.item]
        cell.hourLabel.text = item.hourText
        cell.temperatureLabel.text = item.temperatureText
        cell.weatherImageView.image = UIImage(named: item.condition.imageName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 70, height: 110)
    }
}
