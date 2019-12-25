//
//  WeatherActivity.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import CoreLocation
import UIKit

enum WeatherActivity {
    case byCityName(city: String, countryCode: String?)
    case byGeographic(lat: Double, lon: Double)
    case byZip(zip: Int, countryCode: String?)
}

public enum ActivityType: String {
    case weather
    case forecast
    case dailyForecast = "forecast/daily"
}

extension WeatherActivity {
    init(locationCoordinate: CLLocationCoordinate2D) {
        self = .byGeographic(lat: locationCoordinate.latitude,
                             lon: locationCoordinate.longitude)
    }
}
