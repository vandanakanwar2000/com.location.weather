//
//  PreferencesStore.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

/**
 * Protocol for accessing and modifying preference data.
 */
public protocol PreferencesStore {
    /**
     Set a string value in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set(_ value: String, forKey: Preference.Key)

    /**
     Set a integer value in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set(_ value: Int, forKey: Preference.Key)

    /**
     Set a double value in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set(_ value: Double, forKey: Preference.Key)

    /**
     Set a float value in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set(_ value: Float, forKey: Preference.Key)

    /**
     Set a bool value in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set(_ value: Bool, forKey: Preference.Key)

    /**
     Set a data value in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set(_ value: Data, forKey: Preference.Key)

    /**
     Set a dictionary in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set<T>(_ value: [String: T], forKey: Preference.Key) where T: PreferenceValueStorable

    /**
     Set a array in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set<T>(_ value: [T], forKey: Preference.Key) where T: PreferenceValueStorable

    /**
     Set Any value in the preferences.

     - Parameters:
     - value: The new value for the preference.
     - forKey: The name of the preference to modify.
     */
    func set(_ value: Any, forKey: Preference.Key)

    /**
     Retrieve a string value from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: String value if it exists in preference, or nil.
     */
    func string(forKey: Preference.Key) -> String?

    /**
     Retrieve a integer value from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: Integer value if it exists in preference, or nil.
     */
    func int(forKey: Preference.Key) -> Int?

    /**
     Retrieve a double value from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: Double value if it exists in preference, or nil.
     */
    func double(forKey: Preference.Key) -> Double?

    /**
     Retrieve a float value from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: Float value if it exists in preference, or nil.
     */
    func float(forKey: Preference.Key) -> Float?

    /**
     Retrieve a bool value from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: Bool value if it exists in preference, or nil.
     */
    func bool(forKey: Preference.Key) -> Bool?

    /**
     Retrieve a data value from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: Data value if it exists in preference, or nil.
     */
    func data(forKey: Preference.Key) -> Data?

    /**
     Retrieve a dictionary from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: Dictionary if it exists in preference, or nil.
     */
    func dictionary(forKey: Preference.Key) -> [String: Any]?

    /**
     Retrieve a array from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: Array if it exists in preference, or nil.
     */
    func array(forKey: Preference.Key) -> [Any]?

    /**
     Retrieve a array from the preferences.

     - Parameter forKey: The name of the preference to retrieve.

     - Returns: Array if it exists in preference, or nil.
     */
    func array<T>(forKey: Preference.Key) -> [T]? where T: PreferenceValueStorable

    /**
     Removes item from the preferences.

     - Parameter key: Name of the preference to remove.
     */
    func remove(key: Preference.Key)

    /**
     Removes items from the preferences.

     - Parameter keys: Names of the preference to remove.
     */
    func remove(keys: [Preference.Key])

    /**
     Remove all items from the preferences.
     */
    func removeAll()
}

public struct Preference {
    /**
     The type of preference store.
     */
    public enum Store {
        /// Securely encrpted preferences, used to store sensitive data (using Keychain)
        case secure
        /// Standard preference type (userdefaults, file)
        case standard
    }

    /**
     Defines a Key that is used to store a preference.
     */
    public struct Key: RawRepresentable, Equatable, Hashable {
        public var rawValue: String

        public init(_ rawValue: String) { self.rawValue = rawValue }
        public init(rawValue: String) { self.init(rawValue) }
    }
}

public protocol PreferenceValueStorable {}

extension String: PreferenceValueStorable {}
extension Data: PreferenceValueStorable {}
extension Date: PreferenceValueStorable {}
extension NSNumber: PreferenceValueStorable {}
extension Dictionary: PreferenceValueStorable {}
