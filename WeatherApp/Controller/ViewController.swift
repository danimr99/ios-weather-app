//
//  ViewController.swift
//  NetworkDemo
//
//  Created by Alex Tarragó on 01/11/2022.
//  Copyright © 2022 Dribba GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cityName: String = "Barcelona"
    var forecastData: [ForecastData] = []
    
    /**
    View lifecycle methods
     */
    override func viewDidLoad() {
        super.viewDidLoad()
       setupView()
    }
    /**
    Helpers
     */
    func setupView() {
        APIManager.shared.requestWeatherForCity(cityName, "es") { ( response: WeatherData) in
            DispatchQueue.main.async {
                /**
                    Update Main Weather Data
                 */
                print(response.tempMax!);
            }
        }
        
        APIManager.shared.requestForecastForCity(cityName, "es") { data in
            DispatchQueue.main.async {
                /**
                    Update Table View Data
                 */
            }
        }
    }
}

