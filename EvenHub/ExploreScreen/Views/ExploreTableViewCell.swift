//
//  ExploreTableViewCell.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 16.09.2025.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifire = "ExploreTableViewCell"
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    //MARK: - Methods
    public func configure(with city: String) {
        titleLabel.attributedText = createAttributedTitle(city)
    }
    private func createAttributedTitle(_ title: String) -> NSAttributedString {
        let titleText = NSMutableAttributedString()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Constants.Fonts.medium, size: 13) ?? .systemFont(ofSize: 13, weight: .light),
            .foregroundColor: UIColor(resource: .blue10)
        ]
        titleText.append(NSAttributedString(string: title.capitalized, attributes: attributes))
        
        return titleText
    }
    //MARK: - Setup Layout
    private func makeLayout() {
        setupBackground()
        setupTitleLabel()
    }
    private func setupBackground() {
        
//        backgroundColor = Constants.Colors.Background.backgroundBlue
        contentView.layer.backgroundColor = Constants.Colors.Background.backgroundBlue.cgColor
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 4)
        ])
    }
}
