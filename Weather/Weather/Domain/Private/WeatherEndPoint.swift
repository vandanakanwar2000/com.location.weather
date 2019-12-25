//
//  WeatherEndPoint.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

public enum WeatherEndpoint {
    case weatherInfo(type: String)
    case image(icon: String)

    var path: String {
        switch self {
        case let .weatherInfo(type):
            return ["api.openweathermap.org/data/2.5/", type].joined()
        case let .image(icon):
            return "https://openweathermap.org/img/wn/\(icon)@2x.png"
        }
    }

    var scheme: String {
        switch self {
        case .weatherInfo:
            return "http"
        case .image:
            return "https"
        }
    }

    var method: String {
        switch self {
        case .weatherInfo, .image:
            return "GET"
        }
    }
}
