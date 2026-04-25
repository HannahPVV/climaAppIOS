//
//  WeatherViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 23/04/26.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: - ViewModel
    var viewModel: WeatherViewModel!
    
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
        
        if viewModel == nil {
                setupMockData()
            }// probar datos quitar para api
            
        
        configureCard()
        configureDelegates()
        configureUI()
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
    
    private func setupMockData() {
        let model = WeatherScreenModel(
            currentWeather: CurrentWeatherModel(
                city: "Querétaro",
                temperature: 25,
                condition: .sunny
            ),
            hourlyForecast: [
                HourlyForecastModel(hourText: "8 AM", temperature: 25, condition: .sunny),
                HourlyForecastModel(hourText: "9 AM", temperature: 26, condition: .cloudy),
                HourlyForecastModel(hourText: "10 AM", temperature: 27, condition: .sunny),
                HourlyForecastModel(hourText: "11 AM", temperature: 28, condition: .wind),
                HourlyForecastModel(hourText: "12 PM", temperature: 29, condition: .sunny)
            ],
            details: WeatherDetailsModel(
                feelsLike: 26,
                uvIndex: 8,
                windSpeed: 13,
                precipitation: 0,
                humidity: 60
            )
        )
        
        viewModel = WeatherViewModel(model: model)
    }//probar para api quitar depues
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
