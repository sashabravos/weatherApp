//
//  WeatherViewController.swift
//  weatherApp
//
//  Created by Александра Кострова on 21.03.2023.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    var weatherView: WeatherView!
    var weatherManager = WeatherManager()
    var locationManager = CLLocationManager()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubviews()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setSubviews() {
        self.weatherView = WeatherView()
        self.weatherView.delegate = self
        view.addSubview(weatherView)
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            self.weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - WeatherViewDelegate
extension WeatherViewController: WeatherViewDelegate {
    
    func navigationButtonTapped(sender: UIButton) {
        locationManager.requestLocation()
    }
    func searchButtonTapped(sender: UIButton) {
        weatherView.searchTF.endEditing(true)
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
