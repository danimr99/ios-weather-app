//
//  APIManager.swift
//  NetworkDemo
//
//  Created by Alex Tarragó on 1/11/2022.
//  Copyright © 2022 Dribba GmbH. All rights reserved.
//

import Foundation

private let mainBaseURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=\(API_KEY)&q="
private let forecastBaseURL = "https://api.openweathermap.org/data/2.5/forecast?units=metric&appid=\(API_KEY)&q="

class APIManager {
    static let shared = APIManager()
    
    init() {}
    // MARK: - Custom request
    
   
   
    // MARK: - Pre Built requests
    // Network requests
    func requestWeatherForCity(_ city: String, _ countryCode: String,
                               callback: @escaping (_ data: WeatherData) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(mainBaseURL)\(city),\(countryCode)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let dataTask = session.dataTask( with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print(error!)
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        let data = self.convertToDictionary(text: jsonString)
                        
                       
                        //var weatherMain, weatherDescription: [String:Any]
                        
                        
                        let weatherArray = data!["weather"] as? [[String:Any]]
                        let weatherFirst = weatherArray?.first as? [String : Any]
                        let weatherMain = weatherFirst!["main"]
                        let weatherDescription = weatherFirst!["description"]
                        
                       
                        let main = data!["main"] as? [String: Double]
                        
                        
                        let temp = String(format: "%f", main!["temp"]!)
                        let tempMax = String(format: "%f", main!["temp_max"]!)
                        let tempMin = String(format: "%f", main!["temp_min"]!)
                        
                        let weather = WeatherData(main: weatherMain as! String, description: weatherDescription as! String, temp: temp, tempMax: tempMax, tempMin: tempMin)
                        
                       callback(weather)
                       
                        
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    // MARK: - Request Forecast
    
    func requestForecastForCity(_ city: String, _ countryCode: String,
                                callback: @escaping (_ data: [ForecastData]) -> Void) {
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(forecastBaseURL)\(city),\(countryCode)")! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let dataTask = session.dataTask( with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        let data = self.convertToDictionary(text: jsonString)
                        /**
                            TODO: Complete
                         */
                        let list = data!["list"] as! [[String: Any]]

                        var forecast: [ForecastData] = []

                        for item in list {
                            let date = Date(timeIntervalSince1970: item["dt"] as! Double)
                            let description = (item["weather"] as! [[String: Any]]).first!["description"] as! String
                            let temp = String(format: "%f", (item["main"] as! [String: Double])["temp"]!)
                            let tempMin = String(format: "%f", (item["main"] as! [String: Double])["temp_min"]!)
                            let tempMax = String(format: "%f", (item["main"] as! [String: Double])["temp_max"]!)

                            forecast.append(ForecastData(date: date, weatherDescription: description, temp: temp, tempMax: tempMax, tempMin: tempMin))
                        }

                        callback(forecast)
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    //MARK: - DICTIONARY
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
