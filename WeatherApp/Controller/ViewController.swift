//
//  ViewController.swift
//  NetworkDemo
//
//  Created by Alex Tarragó on 01/11/2022.
//  Copyright © 2022 Dribba GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Outlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    
    
    // MARK: - Variables
    var cityName: String = "Barcelona"
    var forecastData: [ForecastData] = []
    
    /**
    View lifecycle methods
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        self.title = cityName
        self.forecastTableView.delegate = self
        self.forecastTableView.dataSource = self
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.forecastData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get corresponding task from the list and cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastCell
        let forecastItem = self.forecastData[indexPath.row]

        // Convert date to string
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd-MM-yyyy HH:mm")
        let convertedDate = dateFormatter.string(for: forecastItem.date)!
        
        // Set data to cell's labels
        cell.dateLabel.text = convertedDate
        cell.minTempLabel.text = forecastItem.tempMin
        cell.maxTempLabel.text = forecastItem.tempMax
        cell.forecastImage.image = UIImage(named: self.getImageType(weatherDescription: forecastItem.weatherDescription!))
        
        return cell
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
                
                self.weatherImage.image = UIImage(named: self.getImageType(weatherDescription: response.description!))
 
            }
        }
        
        APIManager.shared.requestForecastForCity(cityName, "es") { data in
            DispatchQueue.main.async {
                self.forecastData = data
                self.forecastTableView.reloadData()
            }
        }
    }
    
    private func getImageType(weatherDescription : String) -> String{
        switch weatherDescription {
            case "clear sky":
                return "sunny"
                
            case "few clouds", "scattered clouds", "broken clouds":
                return "cloudy"
                
            case "shower rain", "rain":
                return "rainy"
                
            case "thunderstorm":
                return "storm"
                
            case "snow":
               return "snow"
                
            default:
                return "windy"
        }
    }
}

