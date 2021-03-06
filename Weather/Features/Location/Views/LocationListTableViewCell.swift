//
//  LocationListTableViewCell.swift
//  Weather
//
//  Created by Vandana Kanwar on 22/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

protocol LocationListDataSource {
    var temperatureLabelText: String { get }
    var cityNameLabelText: String { get }
    var timeLabelText: String { get }
    var errorText: String? { get }
}

class LocationListTableViewCell: UITableViewCell {
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func bind(dataSource: LocationListDataSource) {
        temperatureLabel.text = dataSource.temperatureLabelText
        cityNameLabel.text = dataSource.cityNameLabelText
        timeLabel.text = dataSource.timeLabelText
    }
}
