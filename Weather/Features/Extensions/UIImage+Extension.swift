//
//  UIImage+Extension.swift
//  Weather
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

extension UIImageView {
    func imageFrom(link: String, contentMode _: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        WeatherService().loadImage(iconUrl: url) { image in
            self.image = image
        }
    }
}
