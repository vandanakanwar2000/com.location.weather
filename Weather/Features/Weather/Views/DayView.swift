//
//  DayView.swift
//  ScrollingInHorizontalStackView
//
//  Created by Nayem on 4/23/18.
//  Copyright © 2018 Mufakkharul Islam Nayem. All rights reserved.
//

import UIKit

// Protocol to set RowAccount data source
public protocol DayViewDataSource {
    var title: String { get }
    var detail: String { get }
    var image: String { get }
}

class DayView: UIView {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var detailLabel: UILabel!

    @IBOutlet private var trailingConstraint: NSLayoutConstraint!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var topConstraint: NSLayoutConstraint!
    @IBOutlet private var leadingConstraint: NSLayoutConstraint!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    /// Setup view of this component
    private func setupViews() {
        Bundle(for: DayView.self).loadNibNamed("DayView",
                                               owner: self,
                                               options: nil)
        add(containerView)
    }

    var insets: UIEdgeInsets = .init(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0) {
        didSet {
            topConstraint.constant = insets.top
            leadingConstraint.constant = insets.left
            bottomConstraint.constant = insets.bottom
            trailingConstraint.constant = insets.right
        }
    }

    func bind(dataSource: DayViewDataSource) {
        titleLabel.text = dataSource.title
        detailLabel.text = dataSource.detail
        imageView.image = UIImage(named: "clear-day")
        imageView.imageFrom(link: dataSource.image)
    }
}
