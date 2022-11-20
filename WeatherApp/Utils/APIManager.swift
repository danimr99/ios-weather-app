//
//  APIManager.swift
//
//  Created by Daniel Muelle on 14/11/2022.
//

import Foundation

private let mainBaseURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(API_KEY)&q="
private let forecastBaseURL = "https://api.openweathermap.org/data/2.5/forecast?units=metric&appid=\(API_KEY)&q="

class APIManager {
    // MARK: - Properties
    static let shared = APIManager()
    
    // MARK: - Constructor
    init() {}
   
    // MARK: - Methods
    func requestWeatherForCity(_ city: String, _ countryCode: String,
                                   callback: @escaping (_ data: WeatherData) -> Void) {
            
            let request = NSMutableURLRequest(url: NSURL(string: "\(mainBaseURL)\(city),\(countryCode)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            
            let dataTask = session.dataTask( with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if (error != nil) {
                    print(error!)
                } else {
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            let data = self.convertToDictionary(text: jsonString)
                            
                            // Get main and description from dictionary
                            let weatherArray = data!["weather"] as? [[String:Any]]
                            let weatherFirst = weatherArray?.first as? [String : Any]
                            let weatherMain = weatherFirst!["main"]
                            let weatherDescription = weatherFirst!["description"]
                            
                            // Get temperatures from dictionary
                            let main = data!["main"] as? [String: Double]
                            let temp = String(format: "%0.1f", main!["temp"]!)
                            let tempMax = String(format: "%0.1f", main!["temp_max"]!)
                            let tempMin = String(format: "%0.1f", main!["temp_min"]!)
                            
                            let weather = WeatherData(main: weatherMain as? String, description: weatherDescription as? String, temp: temp, tempMax: tempMax, tempMin: tempMin)
                            
                           callback(weather)
                        }
                    }
                }
            })
            dataTask.resume()
        }
            
        func requestForecastForCity(_ city: String, _ countryCode: String,
                                    callback: @escaping (_ data: [ForecastData]) -> Void) {
            
            let request = NSMutableURLRequest(url: NSURL(string: "\(forecastBaseURL)\(city),\(countryCode)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
            request.httpMethod = "GET"
            let session = URLSession.shared
            
            let dataTask = session.dataTask( with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                if (error != nil) {
                    print(error!)
                } else {
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            let data = self.convertToDictionary(text: jsonString)

                            var forecast: [ForecastData] = []
                            
                            let list = data!["list"] as! [[String: Any]]

                            for item in list {
                                let date = Date(timeIntervalSince1970: item["dt"] as! Double)
                                let description = (item["weather"] as! [[String: Any]]).first!["description"] as! String
                                let temp = String(format: "%0.1f", (item["main"] as! [String: Double])["temp"]!)
                                let tempMin = String(format: "%0.1f", (item["main"] as! [String: Double])["temp_min"]!)
                                let tempMax = String(format: "%0.1f", (item["main"] as! [String: Double])["temp_max"]!)

                                forecast.append(ForecastData(date: date, weatherDescription: description, temp: temp, tempMax: tempMax, tempMin: tempMin))
                            }

                            callback(forecast)
                        }
                    }
                }
            })
            dataTask.resume()
        }
    
    /**
        Helpers
     */
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
