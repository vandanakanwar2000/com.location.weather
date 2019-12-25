//
//  CurrentWeather.swift
//  WeatherAssignment
//
//  Created by Vandana Kanwar on 23/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    let name: String?
    let dt: TimeInterval
    var date: Date {
        return Date(timeIntervalSince1970: dt)
    }

    let visibility: Int?
    let clouds: Cloud
    let wind: Wind
    let coord: Coordinates?
    let weather: [Weather]
    let rain: Rain?
    let main: Main
    let sys: Sys
}

struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

struct Main: Codable {
    let temp: Double
    var temperature: RealTimeTemp {
        return RealTimeTemp(temp: temp)
    }

    let pressure: Float
    let humidity: Int
    let tempMin: Double
    let tempMax: Double
}

struct Sys: Codable {
    let type: Int?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
