//
//  Extension UIFont.swift
//  EvenHub
//
//  Created by Евгений Васильев on 15.09.2025.
//
import UIKit

extension UIFont {
    func bold() -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(.traitBold) ?? fontDescriptor
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}
