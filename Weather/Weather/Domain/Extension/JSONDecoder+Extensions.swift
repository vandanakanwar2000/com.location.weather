//
//  JSONDecoder+Extensions.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

extension JSONDecoder {
    func decode<T>(_ type: T.Type, jsonObject: JSON) throws -> T where T: Decodable {
        keyDecodingStrategy = .convertFromSnakeCase
        let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [])
        return try decode(type, from: data)
    }
}
