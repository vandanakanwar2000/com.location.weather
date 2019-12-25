//
//  WeatherViewModelTests.swift
//  WeatherTests
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import CoreLocation
import XCTest

@testable import Weather

class WeatherViewModelTests: XCTestCase {
    var weatherViewModel: WeatherViewModel?
    let location = CLLocationCoordinate2D(latitude: Double(-33.87454896969965), longitude: Double(151.19670667028254))

    var isViewLoaded = false

    override func setUp() {
        weatherViewModel = WeatherViewModel()
        weatherViewModel?.delegate = self
        weatherViewModel?.requestWeatherData(coordinates: location, cityName: "Sydney") {}
    }

    func testCurrentWeatherModel() {
        guard isViewLoaded else { return }
        XCTAssertNotNil(weatherViewModel?.getWeatherModel())
    }

    func testForcastModel() {
        guard isViewLoaded else { return }
        XCTAssertNotNil(weatherViewModel?.getForecastModel())
    }

    func testDetailsModel() {
        guard isViewLoaded else { return }
        XCTAssertNotNil(weatherViewModel?.getDailyForecastModel())
    }

    func testScrollingHeaderViewModel() {
        guard isViewLoaded else { return }
        let horizontalScrollingViewModels = weatherViewModel?.getScrollingHeaderViewModel()
        XCTAssertNotNil(horizontalScrollingViewModels)
        XCTAssertTrue(!horizontalScrollingViewModels!.isEmpty)
    }

    func testWeatherDescriptionViewModel() {
        guard isViewLoaded else { return }
        XCTAssertNotNil(weatherViewModel?.getWeatherDescriptionViewModel())
    }

    func testDetailViewModels() {
        guard isViewLoaded else { return }
        let detailViewModels = weatherViewModel?.getDetailViewModels()
        XCTAssertNotNil(detailViewModels)
        XCTAssertTrue(!detailViewModels!.isEmpty)
    }

    func testForcastViewModels() {
        guard isViewLoaded else { return }
        let forecastViewModels = weatherViewModel?.getForcastViewModels()
        XCTAssertNotNil(forecastViewModels)
        XCTAssertTrue(!forecastViewModels!.isEmpty)
    }

    override func tearDown() {
        weatherViewModel = nil
    }
}

extension WeatherViewModelTests: WeatherViewModelDelegate {
    func refreshView() {
        isViewLoaded = true
    }
}
