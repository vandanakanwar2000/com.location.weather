//
//  FooterViewModel.swift
//  Weather
//
//  Created by Vandana Kanwar on 22/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

/// View model used for displaying receipt tile
struct FooterViewModel: FooterRowDataSource {
    var labelName: String {
        return "Further info please visit"
    }

    var labelValue: String {
        return ""
    }

    var attachmentImage: UIImage? {
        guard let image = UIImage(named: Asset.iconRightChevron.rawValue)
        else { return nil }
        return image
    }

    var rightImage: UIImage? {
        guard let image = UIImage(named: Asset.iconSearchRed.rawValue)
        else { return nil }
        return image
    }
}
