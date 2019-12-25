//
//  Preferences.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

public struct Preferences {
    private init() {}
}

extension Preferences {
    public static func standard(name _: String? = nil) -> PreferencesStore {
        return StandardPreferencesStore()
    }
}
