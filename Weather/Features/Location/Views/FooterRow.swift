//
//  RowCompact.swift
//  Weather
//
//  Created by Vandana Kanwar on 22/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

// FooterRow data source
protocol FooterRowDataSource {
    var labelName: String { get }
    var labelValue: String { get }
    var attachmentImage: UIImage? { get }
    var rightImage: UIImage? { get }
}

// Protocol to handle FooterRow delegate
protocol FooterRowDelegate {
    func didTapLabel(_ sender: UITapGestureRecognizer, forView: FooterRow)
    func didTapImage(_ sender: UITapGestureRecognizer, forView: FooterRow)
}

final class FooterRow: UIView {
    @IBOutlet private var primaryValueContainer: UIView!
    @IBOutlet private var primaryLabel: UILabel!
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var attachmentImage: UIImageView!
    @IBOutlet private var iconImage: UIImageView!

    public var delegate: FooterRowDelegate?
    public private(set) var dataSource: FooterRowDataSource?
    private let attachmentScalingFactor: CGFloat = 0.75
    private let fixedWidthForCheveronImage: CGFloat = 44.0
    private let standardPadding = 16.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setStyle()
    }

    /// set data
    func bind(dataSource: FooterRowDataSource,
              showAttachmentImage _: Bool = false) {
        self.dataSource = dataSource

        /// Image attached at the end of name label
        if let image = dataSource.attachmentImage {
            attachmentImage.image = image
        } else {
            attachmentImage.isHidden = true
        }

        let attributedString = NSMutableAttributedString(
            string: dataSource.labelName,
            attributes: [.foregroundColor: UIColor.red, .font: UIFont.preferredFont(forTextStyle: .body)]
        )
        attributedString.append(NSMutableAttributedString(
            string: dataSource.labelValue,
            attributes: [.foregroundColor: UIColor.red]
        ))

        primaryLabel.attributedText = attributedString
        iconImage.image = dataSource.rightImage

        if let shareImage = dataSource.rightImage {
            iconImage.isHidden = false
            iconImage.image = shareImage
            iconImage.accessibilityIdentifier = dataSource.rightImage?.accessibilityIdentifier
            iconImage.accessibilityLabel = dataSource.rightImage?.accessibilityValue
            if let accessibilityTraits = dataSource.rightImage?.accessibilityTraits {
                iconImage.accessibilityTraits = accessibilityTraits
            }
        } else {
            iconImage.isHidden = true
        }
    }

    //  MARK: - Private routines

    private func setStyle() {
        primaryLabel.adjustsFontForContentSizeCategory = true
        primaryLabel.font = UIFont.preferredFont(forTextStyle: .body)
        primaryLabel.textColor = UIColor.black
    }

    /// Setup view of this component
    private func setupViews() {
        Bundle(for: FooterRow.self).loadNibNamed("FooterRow",
                                                 owner: self,
                                                 options: nil)
        add(containerView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapLabel(_:)))
        primaryValueContainer.addGestureRecognizer(tap)
    }

    // MARK: - IBAction

    @IBAction private func didTapLabel(_ sender: UITapGestureRecognizer) {
        delegate?.didTapLabel(sender, forView: self)
    }

    // MARK: - IBAction

    @IBAction private func didTapImage(_ sender: UITapGestureRecognizer) {
        delegate?.didTapImage(sender, forView: self)
    }
}
