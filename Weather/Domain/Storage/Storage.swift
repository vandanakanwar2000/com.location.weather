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

protocol StorageProtocol {
    associatedtype StorageType
    func fetch() -> [StorageType]
    func save(_ location: StorageType)
    func delete(_ location: StorageType)
}

struct Storage: StorageProtocol {
    private var defaults = Preferences.standard()

    func fetch() -> [Location] {
        let cache = defaults.array(forKey: .storage) as? [NSDictionary] ?? []
        return cache.compactMap(Location.fromDefaultsDic)
    }

    func save(_ location: Location) {
        guard let dic = location.toDefaultsDic()
        else { return }

        guard var caches: [[String: Any]] = defaults.array(forKey: .storage) as? [Dictionary],
            let locationNames: [String] = caches.compactMap({ $0[LocationKeys.name.rawValue] }) as? [String] ?? nil,
            !locationNames.isEmpty
        else {
            defaults.set([dic as [String: Any]], forKey: .storage)
            return
        }
        let alreadyInCaches = location.name.flatMap(locationNames.contains) ?? false
        if !alreadyInCaches {
            caches.insert(dic as [String: Any], at: 0)
            defaults.set(caches, forKey: .storage)
        }
    }

    func delete(_ location: Location) {
        guard var caches: [[String: Any]] = defaults.array(forKey: .storage) as? [Dictionary],
            let locationNames: [String] = caches.compactMap({ $0[LocationKeys.name.rawValue] }) as? [String] ?? nil,
            !locationNames.isEmpty,
            location.name.flatMap(locationNames.contains) ?? false,
            let index = caches.firstIndex(where: { $0[LocationKeys.name.rawValue] as? String == location.name })
        else { return }
        caches.remove(at: index)
        defaults.set(caches, forKey: .storage)
    }
}
