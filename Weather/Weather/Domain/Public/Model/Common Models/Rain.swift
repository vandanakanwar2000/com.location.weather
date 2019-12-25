//
//  Rain.swift
//  WeatherAssignment
//
//  Created by Vandana Kanwar on 23/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation

class Rain: Codable {
    let threeHour: Float

    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        threeHour = try container.decodeIfPresent(Float.self, forKey: .threeHour) ?? 0.0
    }
}
