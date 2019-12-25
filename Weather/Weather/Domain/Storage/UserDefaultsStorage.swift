//
//  UserDefaultsStorage.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Contacts
import MapKit
import UIKit

extension Preference.Key {
    static let storage = Preference.Key(rawValue: "RecentLocationsKey")
}

enum LocationKeys: String {
    case name
    case locationCoordinates = "LocationCoordinates"
    case placemarkCoordinates = "PlacemarkCoordinates"
    case placemarkAddressDic = "PlacemarkAddressDic"
    case latitude = "Latitude"
    case longitude = "Longitude"
}

extension CLLocationCoordinate2D {
    func toDefaultsDic() -> [String: NSNumber] {
        return [LocationKeys.latitude.rawValue: NSNumber(value: latitude), LocationKeys.longitude.rawValue: NSNumber(value: longitude)]
    }

    static func fromDefaultsDic(_ dic: [String: NSNumber]) -> CLLocationCoordinate2D? {
        guard let latitude = dic[LocationKeys.latitude.rawValue],
            let longitude = dic[LocationKeys.longitude.rawValue] else { return nil }
        return CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
    }
}

struct SearchHistoryManager {
    fileprivate var defaults = Preferences.standard()

    func fetch() -> [Location] {
        let history = defaults.array(forKey: .storage) as? [NSDictionary] ?? []
        return history.compactMap(Location.fromDefaultsDic)
    }

    func save(_ location: Location) {
        guard let dic = location.toDefaultsDic() else { return }

        guard var history: [[String: Any]] = defaults.array(forKey: .storage) as? [Dictionary],
            let historyNames: [String] = history.compactMap({ $0[LocationKeys.name.rawValue] }) as? [String] ?? nil,
            !historyNames.isEmpty
        else {
            defaults.set([dic as [String: Any]], forKey: .storage)
            return
        }
        let alreadyInHistory = location.name.flatMap(historyNames.contains) ?? false
        if !alreadyInHistory {
            history.insert(dic as [String: Any], at: 0)
            defaults.set(history, forKey: .storage)
        }
    }

    func delete(_ location: Location) {
        guard var history: [[String: Any]] = defaults.array(forKey: .storage) as? [Dictionary],
            let historyNames: [String] = history.compactMap({ $0[LocationKeys.name.rawValue] }) as? [String] ?? nil,
            !historyNames.isEmpty,
            location.name.flatMap(historyNames.contains) ?? false,
            let index = history.firstIndex(where: { $0[LocationKeys.name.rawValue] as? String == location.name })
        else { return }
        history.remove(at: index)
        defaults.set(history, forKey: .storage)
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
