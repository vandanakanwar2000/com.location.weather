//
//  Date+Extension.swift
//  WeatherAssignment
//
//  Created by Vandana Kanwar on 23/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation

extension Date {
    var dayOfTheWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }

    var hourAndDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE hh a"
        return dateFormatter.string(from: self)
    }

    var hourOfTheDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }

    var timeOfTheDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
