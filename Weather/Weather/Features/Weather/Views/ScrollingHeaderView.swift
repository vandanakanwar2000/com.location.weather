//
//  ScrollingHeaderView.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

class ScrollingHeaderView: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet var stackView: UIStackView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    /// Setup view of this component
    private func setupViews() {
        Bundle(for: ScrollingHeaderView.self).loadNibNamed("ScrollingHeaderView",
                                                           owner: self,
                                                           options: nil)
        add(containerView)
    }

    func bind(viewModels: [DayViewDataSource]?) {
        guard let viewModels = viewModels, !viewModels.isEmpty
        else { return }

        viewModels.forEach { model in
            let dayView = DayView(frame: .zero)
            dayView.translatesAutoresizingMaskIntoConstraints = false
            dayView.widthAnchor.constraint(equalToConstant: stackView.frame.height).isActive = true
            dayView.bind(dataSource: model)
            stackView.addArrangedSubview(dayView)
        }
    }
}
