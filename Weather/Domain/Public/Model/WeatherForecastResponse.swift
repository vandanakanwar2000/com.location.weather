//
//  ForcastResponse.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

struct DailyForcastResponse: Decodable {
    let list: [DailyForcastList]?
    let city: City?
}

struct ForcastResponse: Decodable {
    let list: [CurrentWeather]
    let city: City?
}

struct Coord: Decodable {
    let lon: Double
    let lat: Double
}

struct City: Decodable {
    let name: String?
    let country: String?
    let population: Int?
    let geoname_id: Int?
    let lat: Double?
    let lon: Double?
    let iso2: String?
    let type: String?
    let id: Int?
    let coord: Coord?
    let timezone: Int?
}

struct DailyForcastList: Decodable {
    let dt: Int
    var date: Date {
        return Date(timeIntervalSince1970: TimeInterval(dt))
    }

    let weather: [Weather]?
    let temp: Temperature?
    let sunrise: Int?
    let sunset: Int?
    let pressure: Int?
    let humidity: Int?
    let speed: Double?
    let degree: Int?
    let clouds: Int?
}

struct Temperature: Decodable {
    public var day: Double?
    public var min: Double?
    public var max: Double?
    public var night: Double?
    public var eve: Double?
    public var morn: Double?
}

struct Clouds: Decodable {
    let all: Double?
}
