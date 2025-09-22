//
//  UIButton+Factory.swift
//  EvenHub
//
//  Created by Ilnur on 20.09.2025.
//

import UIKit

extension UIButton {
    static func make(
        image: UIImage? = nil,
        backgroundColor: UIColor = .clear,
        cornerRadius: CGFloat = 0,
        size: CGSize? = nil,
        tintColor: UIColor? = nil,
        action: UIAction? = nil
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let size = size {
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: size.height),
                button.widthAnchor.constraint(equalToConstant: size.width)
            ])
        }
        if let image = image {
            button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.clipsToBounds = true
        if let tintColor = tintColor {
            button.tintColor = tintColor
        }
        if let action = action {
            button.addAction(action, for: .touchUpInside)
        }
        return button
    }
}
