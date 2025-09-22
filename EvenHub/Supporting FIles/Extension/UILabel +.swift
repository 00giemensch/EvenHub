//
//  UILabel+Factory.swift
//  EvenHub
//
//  Created by Ilnur on 20.09.2025.
//

import UIKit

extension UILabel {
    static func make(
        text: String? = nil,
        font: UIFont? = nil,
        color: UIColor = .black,
        lines: Int = 0,
        lineSpacing: CGFloat? = nil,
        kern: CGFloat? = nil
    ) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = lines

        let appliedFont = font ?? .systemFont(ofSize: 16)

        if let text {
            // Если нужны атрибуты
            if lineSpacing != nil || kern != nil {
                let paragraphStyle = NSMutableParagraphStyle()
                if let lineSpacing {
                    paragraphStyle.lineSpacing = lineSpacing
                }

                var attributes: [NSAttributedString.Key: Any] = [
                    .font: appliedFont,
                    .foregroundColor: color,
                    .paragraphStyle: paragraphStyle
                ]

                if let kern {
                    attributes[.kern] = kern
                }

                label.attributedText = NSAttributedString(string: text, attributes: attributes)
            } else {
                // Обычный текст без атрибутов
                label.text = text
                label.font = appliedFont
                label.textColor = color
            }
        }

        return label
    }
}
