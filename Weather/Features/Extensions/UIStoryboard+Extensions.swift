//
//  UIStoryboard+Extensions.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

extension UIStoryboard {
    private static let main = UIStoryboard(name: "Main", bundle: nil)

    static var weatherViewController: WeatherViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
    }

    static var locationSearch: LocationSearchResultsViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "LocationSearchResultsViewController") as! LocationSearchResultsViewController
    }

    static var locationList: LocationListViewController {
        return UIStoryboard.main.instantiateViewController(withIdentifier: "LocationListViewController") as! LocationListViewController
    }
}
