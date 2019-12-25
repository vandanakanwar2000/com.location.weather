//
//  ForecastDetails.swift
//  WeatherAssignment
//
//  Created by Vandana Kanwar on 23/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation
import SwiftUI

struct ForecastDetails: Codable, Identifiable {
    let id = UUID()

    let dt: TimeInterval
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }

    let dtTxt: String
    let clouds: Cloud
    let wind: Wind
    let weather: [Weather]
    let rain: Rain?

    struct Main: Codable {
        let temp: Double
        let temperature: Double
        var tempMin: Double
        var tempMax: Double
        let pressure: Float
        let seaLevel: Float
        let grndLevel: Float
        let humidity: Int
        let tempKf: Double
    }

    var main: Main
}

extension ForecastDetails: Equatable {
    static func == (lhs: ForecastDetails, rhs: ForecastDetails) -> Bool {
        return Date(timeIntervalSince1970: lhs.dt).dayOfTheWeek == Date(timeIntervalSince1970: rhs.dt).dayOfTheWeek
    }
}
