//
//  UIImageView+Factory.swift
//  EvenHub
//
//  Created by Ilnur on 20.09.2025.
//

import UIKit

extension UIImageView {
    static func make(
        image: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        cornerRadius: CGFloat = 0,
        backgroundColor: UIColor? = nil,
        height: CGFloat? = nil,
        width: CGFloat? = nil
    ) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.backgroundColor = backgroundColor
        
        if let height {
            imageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let width {
            imageView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        return imageView
    }
}

extension UIImageView {
    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
