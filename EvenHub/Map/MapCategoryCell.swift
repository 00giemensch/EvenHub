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
    
    private func createAttributedString(from text: String, imageName: String ) -> NSAttributedString {
        let titleText = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)?.withTintColor(UIColor(resource: .blue0), renderingMode: .alwaysTemplate)
        attachment.bounds = CGRect(x: 0, y: 0, width: 17.73, height: 17.73)
        let imageString = NSAttributedString(attachment: attachment)
        titleText.append(imageString)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Constants.Fonts.book, size: 15) ?? .systemFont(ofSize: 15, weight: .light),
            .foregroundColor: UIColor.white
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
        setupBackgroundView()
        setupButton()
    }
    private func setupBackgroundView() {
        self.layer.cornerRadius = 20
        switch category {
        case .art:
            self.backgroundColor = UIColor.gray
        case .sport:
            self.backgroundColor = UIColor.gray
        case .food:
            self.backgroundColor = UIColor.gray
        case .music:
            self.backgroundColor = UIColor.gray
        }
    }
    private func setupButton() {
        addSubview(button)
        switch category {
        case .art:
            button.setAttributedTitle(createAttributedString(from: "Art", imageName: "artPic"), for: .normal)
        case .sport:
            button.setAttributedTitle(createAttributedString(from: "Sport", imageName: "sportPic"), for: .normal)
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
