//
//  WeatherView.swift
//  weatherApp
//
//  Created by Александра Кострова on 31.03.2023.
//

import UIKit

protocol WeatherViewDelegate: AnyObject {
    func navigationButtonTapped(sender: UIButton)
    func searchButtonTapped(sender: UIButton)
}

final class WeatherView: UIView {
    
    var delegate: WeatherViewDelegate?
    var weatherManager = WeatherManager()
    
    private var someView = MakeSomeView()
    private var backgroundImage = MakeSomeView().makeImageView(UIImage(named: "background") ?? UIImage())
    
    lazy var conditionImageView: UIImageView = {
        let condition = MakeSomeView().makeImageView(UIImage(systemName: "sun.max") ?? UIImage())
        condition.tintColor = .label
        return condition
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = someView.makeStackView(.vertical, .trailing, 10.0)
        
        [topSV, conditionImageView, weatherSV, cityLabel, emptyView].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return stackView
    }()
    private lazy var topSV: UIStackView = {
        let stackView = someView.makeStackView(.horizontal, .fill, 10.0)
        stackView.contentMode = .scaleToFill
        
        [navigationButton, searchTF, searchButton].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return stackView
    }()
    private lazy var weatherSV: UIStackView = {
        let stackView = someView.makeStackView(.horizontal, .fill, 0.0)
        
        [temperatureNum, temperatureDegree, temperatureLiteral].forEach {
            stackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        return stackView
    }()
    
    var cityLabel = MakeSomeView().makeLabel("London", .natural, 30.0, .regular)
    var temperatureNum = MakeSomeView().makeLabel("21", .right, 80.0, .black)
    private var temperatureDegree = MakeSomeView().makeLabel("°", .left, 100.0, .light)
    private var temperatureLiteral = MakeSomeView().makeLabel("C", .left, 100.0, .light)
    
    lazy var navigationButton: UIButton = {
        let button = MakeSomeView().makeButton(UIImage(systemName: "location.circle.fill") ?? UIImage())
        button.addTarget(self, action: #selector(self.navigationButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var searchButton: UIButton = {
        let button = MakeSomeView().makeButton(UIImage(systemName: "magnifyingglass") ?? UIImage())
        button.addTarget(self, action: #selector(self.searchButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    var searchTF = MakeSomeView().makeTextField()
    private var emptyView = MakeSomeView().makeView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        searchTF.delegate = self
        weatherManager.delegate = self
        addSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Add constraints
    func addSubView() {
        [backgroundImage, mainStackView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            mainStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            
            topSV.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            topSV.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            
            conditionImageView.heightAnchor.constraint(equalToConstant: 120.0),
            conditionImageView.widthAnchor.constraint(equalToConstant: 120.0),
            
            navigationButton.heightAnchor.constraint(equalToConstant: 40.0),
            navigationButton.widthAnchor.constraint(equalToConstant: 40.0),
            
            searchButton.heightAnchor.constraint(equalToConstant: 40.0),
            searchButton.widthAnchor.constraint(equalToConstant: 40.0)
        ])
    }
    
    @objc func navigationButtonTapped(sender: UIButton) {
        self.delegate?.navigationButtonTapped(sender: sender)
    }
    
    @objc func searchButtonTapped(sender: UIButton) {
        self.delegate?.searchButtonTapped(sender: sender)
    }
}
// MARK: - WeatherManagerDelegate
extension WeatherView: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureNum.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - UITextFieldDelegate
extension WeatherView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else { textField.placeholder = "Type the city here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTF.text {
            weatherManager.fetchWeather(cityName: city)
        }
    }
}
