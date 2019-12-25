//
//  Assets.swift
//  Weather
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation
import UIKit

public typealias AssetImageTypeAlias = UIImage

public enum Asset: String {
    case iconSearchRed = "icon-search-red"
    case iconRightChevron = "icon-arrow-right"
    case iconHamburger = "icon-hamburger"
    case iconAdd = "icon-plus"
    case cityImage = "city"
    case background
}

public extension AssetImageTypeAlias {
    convenience init!(asset: Asset) {
        #if os(iOS) || os(tvOS)
            let bundle = Bundle(for: BundleToken.self)
            self.init(named: asset.rawValue, in: bundle, compatibleWith: nil)
        #elseif os(OSX)
            self.init(named: NSImage.Name(asset.rawValue))
        #elseif os(watchOS)
            self.init(named: asset.rawValue)
        #endif
    }
}

private final class BundleToken {}
