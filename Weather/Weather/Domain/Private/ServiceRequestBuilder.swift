//
//  ServiceRequestBuilder.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

class ServiceRequestBuilder {
    private let urlBuilder: ServiceUrlBuilder

    // MARK: - lifecycle

    init(urlBuilder: ServiceUrlBuilder) {
        self.urlBuilder = urlBuilder
    }

    // MARK: - internal

    func build(for activity: WeatherActivity, type: ActivityType) -> URLRequest? {
        guard let url = urlBuilder.build(for: activity, activityType: type)
        else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = WeatherEndpoint.weatherInfo(type: type.rawValue).method
        return request
    }
}
