//
//  ViewController.swift
//  NetworkDemo
//
//  Created by Alex Tarragó on 01/11/2022.
//  Copyright © 2022 Dribba GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    var cityName: String = "Madrid"
    var forecastData: [ForecastData] = []
    
    /**
    View lifecycle methods
     */
    override func viewDidLoad() {
        super.viewDidLoad()
       setupView()
        self.title = cityName
    }
    /**
    Helpers
     */
    func setupView() {
        APIManager.shared.requestWeatherForCity(cityName, "es") { ( response: WeatherData) in
            DispatchQueue.main.async {
                self.currentTempLabel.text = "\(String(describing: response.temp!))ºC"
                self.maxTempLabel.text = "\(String(describing: response.tempMax!))ºC"
                self.minTempLabel.text = "\(String(describing: response.tempMin!))ºC"
                self.weatherDescriptionLabel.text = response.description!
                
                switch response.description{
                case "clear sky": self.weatherImage.image = UIImage(named: "sunny")
                    break
                    
                default: break
                    
                }
            }
        }
        
        APIManager.shared.requestForecastForCity(cityName, "es") { data in
            DispatchQueue.main.async {
                /**
                    Update Table View Data
                 */
                self.forecastData=data
                print(self.forecastData[0].date!)
                print(self.forecastData[1].date!)
            }
        }
    }
}

