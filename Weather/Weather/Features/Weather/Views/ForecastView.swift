//
//  ForecastView.swift
//  Weather
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

// Protocol to set RowAccount data source
struct ForecastViewModel {
    let title: String
    let detail: String
    let image: String
    let subTitle: String
}

class ForecastView: UIView {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!
    @IBOutlet private var subTitleLabel: UILabel!
    @IBOutlet private var trailingConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var topConstraint: NSLayoutConstraint!
    @IBOutlet private var leadingConstraint: NSLayoutConstraint!

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
        Bundle(for: ForecastView.self).loadNibNamed("ForecastView",
                                                    owner: self,
                                                    options: nil)
        add(containerView)
    }

    var insets: UIEdgeInsets = .init(top: 16.0,
                                     left: 16.0,
                                     bottom: 16.0,
                                     right: 16.0) {
        didSet {
            topConstraint.constant = insets.top
            leadingConstraint.constant = insets.left
            bottomConstraint.constant = insets.bottom
            trailingConstraint.constant = insets.right
        }
    }

    func bind(viewModel: ForecastViewModel) {
        titleLabel.text = viewModel.title
        detailLabel.text = viewModel.detail
        imageView.image = UIImage(named: "clear-day")
        imageView.imageFrom(link: viewModel.image)
        subTitleLabel.text = viewModel.subTitle
    }
}
