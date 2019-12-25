//
//  StandardPreferencesStore.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

class StandardPreferencesStore: PreferencesStore {
    private let standardUserDefaults: UserDefaults

    init(_ name: String? = nil) {
        if (name ?? "").isEmpty {
            standardUserDefaults = UserDefaults.standard
        } else {
            standardUserDefaults = UserDefaults(suiteName: name!)!
        }
    }

    func set(_ value: String, forKey: Preference.Key) {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func set(_ value: Int, forKey: Preference.Key) {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func set(_ value: Double, forKey: Preference.Key) {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func set(_ value: Float, forKey: Preference.Key) {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func set(_ value: Bool, forKey: Preference.Key) {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func set(_ value: Data, forKey: Preference.Key) {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func set<T>(_ value: [String: T], forKey: Preference.Key) where T: PreferenceValueStorable {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func set<T>(_ value: [T], forKey: Preference.Key) where T: PreferenceValueStorable {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func set(_ value: Any, forKey: Preference.Key) {
        standardUserDefaults.set(value, forKey: forKey.rawValue)
    }

    func string(forKey: Preference.Key) -> String? {
        return standardUserDefaults.string(forKey: forKey.rawValue)
    }

    func int(forKey: Preference.Key) -> Int? {
        return standardUserDefaults.object(forKey: forKey.rawValue) as? Int
    }

    func double(forKey: Preference.Key) -> Double? {
        return standardUserDefaults.object(forKey: forKey.rawValue) as? Double
    }

    func float(forKey: Preference.Key) -> Float? {
        return standardUserDefaults.object(forKey: forKey.rawValue) as? Float
    }

    func bool(forKey: Preference.Key) -> Bool? {
        return standardUserDefaults.object(forKey: forKey.rawValue) as? Bool
    }

    func data(forKey: Preference.Key) -> Data? {
        return standardUserDefaults.data(forKey: forKey.rawValue)
    }

    func dictionary(forKey: Preference.Key) -> [String: Any]? {
        return standardUserDefaults.dictionary(forKey: forKey.rawValue)
    }

    func array(forKey: Preference.Key) -> [Any]? {
        return standardUserDefaults.array(forKey: forKey.rawValue)
    }

    func array<T>(forKey: Preference.Key) -> [T]? where T: PreferenceValueStorable {
        return standardUserDefaults.object(forKey: forKey.rawValue) as? [T]
    }

    func remove(key: Preference.Key) {
        standardUserDefaults.removeObject(forKey: key.rawValue)
    }

    func remove(keys: [Preference.Key]) {
        for key in keys {
            standardUserDefaults.removeObject(forKey: key.rawValue)
        }
    }

    func removeAll() {
        let dictionary = standardUserDefaults.dictionaryRepresentation()

        for item in dictionary {
            standardUserDefaults.removeObject(forKey: item.key)
        }
    }
}
