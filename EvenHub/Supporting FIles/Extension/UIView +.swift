//
//  UIView +.swift
//  EvenHub
//
//  Created by Ilnur on 22.09.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
