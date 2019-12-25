//
//  LocationViewModel.swift
//  Weather
//
//  Created by Vandana Kanwar on 20/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Contacts
import CoreLocation
import UIKit

// class because protocol
public class Location: NSObject {
    public let name: String?
    public let location: CLLocation?
    public let placemark: CLPlacemark

    public var address: String {
        guard let postalAddress = placemark.postalAddress
        else { return "" }

        return CNPostalAddressFormatter().string(from: postalAddress)
    }

    public init(name: String?, location: CLLocation? = nil, placemark: CLPlacemark) {
        self.name = name
        self.location = location ?? placemark.location
        self.placemark = placemark
    }
}
