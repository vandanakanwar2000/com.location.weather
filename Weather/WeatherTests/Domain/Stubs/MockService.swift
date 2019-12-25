//
//  MockService.swift
//  WeatherUITests
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation
import XCTest

@testable import Weather

class MockService: WeatherService {
    private let mockPath: String?
    private var urlRequestBuilder: ServiceRequestBuilder?

    init(mockPath: String?) {
        let urlBuilder = ServiceUrlBuilder()
        urlRequestBuilder = ServiceRequestBuilder(urlBuilder: urlBuilder)
        self.mockPath = mockPath
    }

    override func submitRequest(with _: URL, completion: @escaping ServiceCallback) {
        guard let path = mockPath else {
            return completion(.failure(ServiceError.general(messsage: "Unable to find json")))
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            if let json = try JSONSerialization.jsonObject(with: data,
                                                           options: JSONSerialization.ReadingOptions()) as? JSON {
                completion(.success(json))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
