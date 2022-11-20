//
//  ViewController.swift
//
//  Created by Daniel Muelle on 14/11/2022.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    // MARK: - Outlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    
    
    // MARK: - Properties
    var cityName: String = "Madrid"
    var countryName: String = "España"
    var countryCode: String = "es"
    var forecastData: [ForecastData] = []
    var locationManager =  CLLocationManager()
    
    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        if self.locationManager.authorizationStatus == .authorizedWhenInUse {
            self.setupLocationManager()
        }
        
        // Delegate forecast table view
        self.forecastTableView.delegate = self
        self.forecastTableView.dataSource = self
        
        setupView()
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
    
    // MARK: - Helpers
    func setupView() {
        self.title = "\(self.cityName), \(self.countryName)"
        
        APIManager.shared.requestWeatherForCity(cityName, countryCode) { ( response: WeatherData) in
            DispatchQueue.main.async {
                self.currentTempLabel.text = "\(String(describing: response.temp!))ºC"
                self.maxTempLabel.text = "\(String(describing: response.tempMax!))ºC"
                self.minTempLabel.text = "\(String(describing: response.tempMin!))ºC"
                self.weatherDescriptionLabel.text = response.description!
                self.weatherImage.image = UIImage(named: self.getImageType(weatherDescription: response.description!))
            }
        }
        
        APIManager.shared.requestForecastForCity(cityName, countryCode) { data in
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
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchCity" {
            let destination = segue.destination as! SearchCityViewController

            destination.searchCityCallback = { (searchedCity, searchedCountryCode) in
                let splittedLocation = searchedCity.components(separatedBy: ", ")
                self.cityName = splittedLocation[0].folding(options: .diacriticInsensitive, locale: .current)
                self.countryName = splittedLocation[1].folding(options: .diacriticInsensitive, locale: .current)
                self.countryCode = searchedCountryCode.lowercased()
                
                self.setupView()
            }
        }
    }
    
    // MARK: - Location services
    private func setupLocationManager(){
        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var location: CLLocation
        
        if !locations.isEmpty {
            location =  locations.last!
            self.fetchCityAndCountry(from: location) { city, isoCountryCode, country, error in
                guard let city = city, let countryCode = isoCountryCode, let country = country, error == nil else { return }
                
                self.cityName = city.trimmingCharacters(in: .whitespaces)
                self.countryCode = countryCode.trimmingCharacters(in: .whitespaces)
                self.countryName = country
                
                self.setupView()
                
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
  
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ isoCountryCode:  String?, _ country: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality, placemarks?.first?.isoCountryCode, placemarks?.first?.country, error)
        }
    }
    
    // MARK: - Handlers
    @IBAction func resetUserLocationHandler(_ sender: Any) {
        self.setupLocationManager()
    }
}

