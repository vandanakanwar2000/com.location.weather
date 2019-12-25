//
//  WeatherServiceTests.swift
//  WeatherUITests
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import CoreLocation
import XCTest

@testable import Weather

class WeatherServiceTests: XCTestCase {
    let location = CLLocationCoordinate2D(latitude: Double(-33.87454896969965), longitude: Double(151.19670667028254))

    func testCurrentWeatherHappyPath() {
        let service = MockService(mockPath: WeatherStub.weather.path)
        let weatherExpectation = expectation(description: #function + "WeatherServicerHappyPath")
        service.getCurrentWeather(at: location, requestType: .weather, result: CurrentWeather.self) { result in
            switch result {
            case .success:
                weatherExpectation.fulfill()
            case .failure:
                break
            }
        }
        waitForExpectations()
    }

    func testForcastWeatherHappyPath() {
        let service = MockService(mockPath: WeatherStub.forecast.path)
        let weatherExpectation = expectation(description: #function + "WeatherServicerHappyPath")
        service.getCurrentWeather(at: location, requestType: .forecast, result: ForcastResponse.self) { result in
            switch result {
            case .success:
                weatherExpectation.fulfill()
            case .failure:
                break
            }
        }
        waitForExpectations()
    }

    func testDailyWeatherHappyPath() {
        let service = MockService(mockPath: WeatherStub.details.path)
        let weatherExpectation = expectation(description: #function + "WeatherServicerHappyPath")
        service.getCurrentWeather(city: "Pyrmont", requestType: .dailyForecast, result: DailyForcastResponse.self) { result in
            switch result {
            case .success:
                weatherExpectation.fulfill()
            case .failure:
                break
            }
        }
        waitForExpectations()
    }

    func testCurrentWeatherServiceWhenBackEndFails() {
        let service = MockService(mockPath: WeatherStub.weatherMalformed.path)
        let weatherExpectation = expectation(description: #function + "WeatherServicerUnhappyPath")
        service.getCurrentWeather(at: location, requestType: .weather, result: CurrentWeather.self) { result in
            switch result {
            case .success: break
            case .failure:
                weatherExpectation.fulfill()
            }
        }
        waitForExpectations()
    }

    func testForecastWeatherServiceWhenBackEndFails() {
        let service = MockService(mockPath: WeatherStub.forecastMalformed.path)
        let weatherExpectation = expectation(description: #function + "WeatherServicerUnhappyPath")
        service.getCurrentWeather(at: location, requestType: .forecast, result: CurrentWeather.self) { result in
            switch result {
            case .success: break
            case .failure:
                weatherExpectation.fulfill()
            }
        }
        waitForExpectations()
    }

    func testDailyWeatherUnHappyPath() {
        let service = MockService(mockPath: WeatherStub.detailsMalformed.path)
        let weatherExpectation = expectation(description: #function + "WeatherServicerHappyPath")
        service.getCurrentWeather(city: "Pyrmont", requestType: .dailyForecast, result: DailyForcastResponse.self) { result in
            switch result {
            case .success: break
            case .failure:
                weatherExpectation.fulfill()
            }
        }
        waitForExpectations()
    }

    private func waitForExpectations() {
        waitForExpectations(timeout: 2, handler: nil)
    }
}
