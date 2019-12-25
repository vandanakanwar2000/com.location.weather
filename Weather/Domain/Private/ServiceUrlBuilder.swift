//
//  ServiceUrlBuilder.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

/// Constructs a url from an WeatherActivity.
class ServiceUrlBuilder {
    enum QueryItemKey {
        static let q = "q"
        static let lat = "lat"
        static let lon = "lon"
        static let id = "id"
        static let zip = "zip"
        static let appIdKey = "APPID"
        static let unit = "units"
    }

    private let appId: String = "95d190a434083879a6398aafd54d9e73"
    private let temperatureUnitValue = "metric"

    // MARK: - lifecycle

    init() {}

    // MARK: - internal

    func build(for activity: WeatherActivity, activityType: ActivityType) -> URL? {
        let weatherEndPoint = WeatherEndpoint.weatherInfo(type: activityType.rawValue)

        var components = URLComponents()
        components.scheme = weatherEndPoint.scheme
        components.path = weatherEndPoint.path
        components.queryItems = buildQueryItems(for: activity)
        return components.url
    }

    // MARK: - private

    private func buildQueryItems(for activity: WeatherActivity) -> [URLQueryItem] {
        switch activity {
        case let .byCityName(city, countryCode):
            let value: String
            if let countryCode = countryCode {
                value = String(format: "%@,%@", city, countryCode)
            } else {
                value = city
            }

            return [
                URLQueryItem(name: QueryItemKey.q, value: value),
                URLQueryItem(name: QueryItemKey.unit, value: temperatureUnitValue),
                URLQueryItem(name: QueryItemKey.appIdKey, value: appId)
            ]

        case let .byGeographic(lat, lon):
            return [
                URLQueryItem(name: QueryItemKey.lat, value: "\(lat)"),
                URLQueryItem(name: QueryItemKey.lon, value: "\(lon)"),
                URLQueryItem(name: QueryItemKey.unit, value: temperatureUnitValue),
                URLQueryItem(name: QueryItemKey.appIdKey, value: appId)
            ]

        case let .byZip(zip, countryCode):
            let value: String
            if let countryCode = countryCode {
                value = String(format: "%@,%@", zip.description, countryCode)
            } else {
                value = zip.description
            }

            return [
                URLQueryItem(name: QueryItemKey.zip, value: value),
                URLQueryItem(name: QueryItemKey.unit, value: temperatureUnitValue),
                URLQueryItem(name: QueryItemKey.appIdKey, value: appId)
            ]
        }
    }
}
