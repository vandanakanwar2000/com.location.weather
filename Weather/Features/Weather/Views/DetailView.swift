//
//  DetailView.swift
//  Weather
//
//  Created by Vandana Kanwar on 24/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import Foundation
import UIKit
// Protocol to set RowAccount data source
struct DetailViewViewModel {
    let titlePrimary: String
    let detailPrimary: String
    let titleSecondary: String
    let detailSecondary: String
}

class DetailView: UIView {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleLabelPrimary: UILabel!
    @IBOutlet private var detailLabelPrimary: UILabel!
    @IBOutlet private var titleLabelSecondary: UILabel!
    @IBOutlet private var detailLabelSecondary: UILabel!

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
        Bundle(for: DetailView.self).loadNibNamed("DetailView",
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

    func bind(viewModel: DetailViewViewModel) {
        titleLabelSecondary.text = viewModel.titleSecondary
        detailLabelSecondary.text = viewModel.detailSecondary
        titleLabelPrimary.text = viewModel.titlePrimary
        detailLabelPrimary.text = viewModel.detailPrimary
    }
}
