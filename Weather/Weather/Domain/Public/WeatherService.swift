//
//  WeatherService.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

/// Weather service protocol.
protocol WeatherServiceProvider {
    /// Retrieve weather info
    func getWeatherInfo<T: Decodable>(operation: WeatherActivity,
                                      type: ActivityType, result: T.Type,
                                      completion: @escaping (Result<T>) -> Void)

    func loadImage(iconUrl: URL, completion: @escaping (UIImage?) -> Void?)
}

class WeatherService: Service, WeatherServiceProvider {
    private var urlRequestBuilder: ServiceRequestBuilder?

    override init() {
        let urlBuilder = ServiceUrlBuilder()
        urlRequestBuilder = ServiceRequestBuilder(urlBuilder: urlBuilder)
    }

    public func getCurrentWeather<T: Decodable>(city: String,
                                                country: String? = nil,
                                                requestType: ActivityType,
                                                result: T.Type,
                                                completion: @escaping (Result<T>) -> Void) {
        let operation: WeatherActivity = .byCityName(city: city, countryCode: country)
        getWeatherInfo(operation: operation, type: requestType, result: result, completion: completion)
    }

    public func getCurrentWeather<T: Decodable>(at location: CLLocationCoordinate2D,
                                                requestType: ActivityType,
                                                result: T.Type,
                                                completion: @escaping (Result<T>) -> Void) {
        let operation: WeatherActivity = .byGeographic(lat: location.latitude, lon: location.longitude)
        getWeatherInfo(operation: operation, type: requestType, result: result, completion: completion)
    }

    public func getCurrentWeather<T: Decodable>(for zip: Int,
                                                country: String? = nil,
                                                requestType: ActivityType,
                                                result: T.Type,
                                                completion: @escaping (Result<T>) -> Void) {
        let operation: WeatherActivity = .byZip(zip: zip, countryCode: country)
        getWeatherInfo(operation: operation, type: requestType, result: result, completion: completion)
    }

    func getWeatherInfo<T>(operation: WeatherActivity, type: ActivityType, result: T.Type, completion: @escaping (Result<T>) -> Void) where T: Decodable {
        guard let request = urlRequestBuilder?.build(for: operation, type: type),
            let url = request.url
        else {
            return completion(.failure(ServiceError.general(messsage: "Error")))
        }

        submitRequest(with: url) { result in
            switch result {
            case let .success(data):
                do {
                    let response = try JSONDecoder().decode(T.self, jsonObject: data)
                    completion(.success(response))
                } catch {
                    return completion(.failure(ServiceError.general(messsage: "Error")))
                }

            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func loadImage(iconUrl: URL, completion: @escaping (UIImage?) -> Void?) {
        downloadImage(url: iconUrl, completion: completion)
    }
}
