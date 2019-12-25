//
//  WeatherDescriptionView.swift
//  Weather
//
//  Created by Vandana Kanwar on 23/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

public struct WeatherDescriptionViewModel {
    var detail: String
}

class WeatherDescriptionView: UIView {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var detailLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    /// Setup view of this component
    private func setupViews() {
        Bundle(for: WeatherDescriptionView.self).loadNibNamed("WeatherDescriptionView",
                                                              owner: self,
                                                              options: nil)
        add(containerView)
    }

    func bind(dataSource: WeatherDescriptionViewModel) {
        detailLabel.text = dataSource.detail
    }
}
