//
//  Weather.swift
//  WeatherAssignment
//
//  Created by Vandana Kanwar on 23/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import SwiftUI

struct Weather: Codable, Identifiable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
