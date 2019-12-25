//
//  LocationViewModelTests.swift
//  WeatherTests
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import CoreLocation
import XCTest

@testable import Weather
class LocationViewModelTests: XCTestCase {
    var locationViewModel: LocationListViewModel?

    override func setUp() {
        let location = Location(name: "Sydney",
                                location: CLLocation(latitude: CLLocationDegrees(-33.87454896969965),
                                                     longitude: CLLocationDegrees(151.19670667028254)),
                                placemark: CLPlacemark())

        locationViewModel = LocationListViewModel(locations: [location])
    }

    func testLocationViewModel() {
        XCTAssertNotNil(locationViewModel?.weatherListCellModel(model: nil, cityName: "Sydney"))
    }

    func testFooterViewModel() {
        let footerViewModel = locationViewModel?.getFooterModel()
        XCTAssertNotNil(footerViewModel)
        XCTAssertEqual(footerViewModel?.labelName, "Further info please visit")
        XCTAssertEqual(footerViewModel?.rightImage, UIImage(asset: Asset.iconSearchRed))
        XCTAssertEqual(footerViewModel?.attachmentImage, UIImage(asset: Asset.iconRightChevron))
    }
}
