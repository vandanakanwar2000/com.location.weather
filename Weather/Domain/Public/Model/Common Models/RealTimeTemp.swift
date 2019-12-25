//
// Kelvin.swift
//  WeatherAssignment
//
//  Created by Vandana Kanwar on 23/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation

public struct RealTimeTemp: Codable {
    private var temp: Double

    init(temp: Double) {
        self.temp = temp
    }

    func celsius() -> Int {
        return Int(temp - 273.15)
    }

    func fahrenheit() -> Int {
        return Int((temp * 9 / 5) - 459.67)
    }
}

extension RealTimeTemp: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(temp: value)
    }
}

extension RealTimeTemp: Comparable {
    public static func < (lhs: RealTimeTemp, rhs: RealTimeTemp) -> Bool {
        return lhs.temp < rhs.temp
    }
}
