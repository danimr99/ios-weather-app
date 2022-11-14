//
//  ForecastData.swift
//  WeatherApp
//
//  Created by Daniel Muelle on 14/11/2022.
//

import Foundation

class ForecastData {
    var date: Date?
    var weatherDescription: String?
    var temp: String?
    var tempMax: String?
    var tempMin: String?
    
    init(date: Date? = nil, weatherDescription: String? = nil, temp: String? = nil, tempMax: String? = nil, tempMin: String? = nil) {
        self.date = date
        self.weatherDescription = weatherDescription
        self.temp = temp
        self.tempMax = tempMax
        self.tempMin = tempMin
    }
}
