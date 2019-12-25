//
//  WeatherListViewModel.swift
//  Weather
//
//  Created by Vandana Kanwar on 22/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

struct WeatherListViewModel: LocationListDataSource {
    var temperatureLabelText: String

    var cityNameLabelText: String

    var timeLabelText: String

    var errorText: String?
}
