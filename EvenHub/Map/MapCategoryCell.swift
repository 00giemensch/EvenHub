//
//  MapCategoryCell.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 16.09.2025.
//

import UIKit

class MapCategoryCell: UICollectionViewCell {
    static let cellID = "MapCategoryCell"
    //MARK: - Properties
    private var category: CategoryType = .art {
        didSet {
            setupLayout()
        }
    }
    var action: (()->Void)?
    
    //MARK: - UI Components
    private let button = UIButton()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    public func setCategory(_ category: CategoryType) {
        self.category = category
    }
    
    private func createAttributedString(from text: String, imageName: String) -> NSAttributedString {
        let titleText = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        
        switch text {
        case "Sports":
            attachment.image = UIImage(named: imageName)?.withTintColor(UIColor(resource: .accentRed), renderingMode: .alwaysTemplate)
        case "Art":
            attachment.image = UIImage(named: imageName)?.withTintColor(UIColor(resource: .accentDarkCyan), renderingMode: .alwaysTemplate)
        case "Food":
            attachment.image = UIImage(named: imageName)?.withTintColor(UIColor(resource: .accentGreen), renderingMode: .alwaysTemplate)
        case "Music":
            attachment.image = UIImage(named: imageName)?.withTintColor(UIColor(resource: .blue50), renderingMode: .alwaysTemplate)
        default:
            attachment.image = UIImage(named: imageName)?.withTintColor(UIColor(resource: .blue0), renderingMode: .alwaysTemplate)
        }
        
        attachment.bounds = CGRect(x: 0, y: 0, width: 17.73, height: 17.73)
        let imageString = NSAttributedString(attachment: attachment)
        titleText.append(imageString)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Constants.Fonts.book, size: 15) ?? .systemFont(ofSize: 15, weight: .light),
            .foregroundColor: UIColor.color30
        ]
        titleText.append(NSAttributedString(string: " " + text, attributes: attributes))
        
        return titleText
    }
    
    @objc private func buttonPressed() {
        guard let action = self.action else { return }
        action()
    }
    //MARK: - Setup Layout
    private func setupLayout() {
        self.layer.cornerRadius = 20
        self.backgroundColor = UIColor.white
        setupButton()
    }
    
    private func setupButton() {
        addSubview(button)
        switch category {
        case .art:
            button.setAttributedTitle(createAttributedString(from: "Art", imageName: "artPic"), for: .normal)
        case .sport:
            button.setAttributedTitle(createAttributedString(from: "Sports", imageName: "sportPic"), for: .normal)
        case .food:
            button.setAttributedTitle(createAttributedString(from: "Food", imageName: "foodPic"), for: .normal)
        case .music:
            button.setAttributedTitle(createAttributedString(from: "Music", imageName: "musicPic"), for: .normal)
        }
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
