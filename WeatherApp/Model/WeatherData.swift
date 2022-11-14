//
//  WeatherData.swift
//  NetworkDemo
//
//  Created by Alex on 1/11/22.
//  Copyright © 2022 Dribba GmbH. All rights reserved.
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
