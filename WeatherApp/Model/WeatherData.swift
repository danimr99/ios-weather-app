//
//  WeatherData.swift
//
//  Created by Daniel Muelle on 14/11/22.
//

import Foundation

class WeatherData {
    var main: String?
    var description: String?
    var temp: String?
    var tempMax: String?
    var tempMin: String?
    
    init(main: String? = nil, description: String? = nil, temp: String? = nil, tempMax: String? = nil, tempMin: String? = nil) {
        self.main = main
        self.description = description
        self.temp = temp
        self.tempMax = tempMax
        self.tempMin = tempMin
    }
}
