//
//  UIView+Extension.swift
//  Weather
//
//  Created by Vandana Kanwar on 21/12/19.
//  Copyright © 2019 Vandana Kanwar. All rights reserved.
//

import UIKit

extension UIView {
    func add(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func separator(color: UIColor) -> UIView {
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        separator.backgroundColor = color
        return separator
    }
}
