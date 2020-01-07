//
//  LocationViewModel.swift
//  Weather
//
//  Created by Vandana Kanwar on 20/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Contacts
import CoreLocation
import MapKit
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

extension Location {
    func toDefaultsDic() -> [String: Any]? {
        guard let address = placemark.postalAddress,
            let placemarkCoordinatesDic = placemark.location?.coordinate.toDefaultsDic()
        else { return nil }

        var dic: [String: Any] = [LocationKeys.placemarkCoordinates.rawValue: placemarkCoordinatesDic]
        do { let addressData = try NSKeyedArchiver.archivedData(withRootObject: address,
                                                                requiringSecureCoding: false)
            dic[LocationKeys.placemarkAddressDic.rawValue] = addressData
        } catch { return nil }

        if let name = name {
            dic[LocationKeys.name.rawValue] = name as Any?
        }
        return dic
    }

    class func fromDefaultsDic(_ dic: NSDictionary) -> Location? {
        guard let placemarkCoordinatesDic: [String: NSNumber] = dic[LocationKeys.placemarkCoordinates.rawValue] as? Dictionary,
            let placemarkCoordinates = CLLocationCoordinate2D.fromDefaultsDic(placemarkCoordinatesDic),
            let placemarkAddressData = dic[LocationKeys.placemarkAddressDic.rawValue] as? Data
        else { return nil }

        do { let addressData = try NSKeyedUnarchiver.unarchivedObject(ofClass: CNPostalAddress.self,
                                                                      from: placemarkAddressData)
            guard let postalAddress = addressData else { return nil }
            return Location(name: dic[LocationKeys.name.rawValue] as? String,
                            location: nil,
                            placemark: MKPlacemark(coordinate: placemarkCoordinates,
                                                   postalAddress: postalAddress))
        } catch { return nil }
    }
}

extension CLLocationCoordinate2D {
    func toDefaultsDic() -> [String: NSNumber] {
        return [LocationKeys.latitude.rawValue: NSNumber(value: latitude), LocationKeys.longitude.rawValue: NSNumber(value: longitude)]
    }

    static func fromDefaultsDic(_ dic: [String: NSNumber]) -> CLLocationCoordinate2D? {
        guard let latitude = dic[LocationKeys.latitude.rawValue],
            let longitude = dic[LocationKeys.longitude.rawValue]
        else { return nil }
        return CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
    }
}
