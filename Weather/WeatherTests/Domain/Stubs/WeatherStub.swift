//
//  WeatherStub.swift
//  WeatherUITests
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import XCTest

enum WeatherStub: String {
    case weather = "Weather"
    case forecast = "Forecast"
    case details = "ForecastDetails"
    case weatherMalformed = "WeatherMalformed"
    case forecastMalformed = "ForecastMalformed"
    case detailsMalformed = "ForecastDetailsMalformed"

    var path: String? {
        return Bundle(for: MockService.self).path(forResource: rawValue,
                                                  ofType: "json")
    }
}
