//
//  ExploreCollectionHeader.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 13.09.2025.
//

import UIKit

class ExploreCollectionHeader: UICollectionReusableView {
    static let reuseID = "ExploreCollectionHeader"
    
    //MARK: - Properties
    var action: (() -> Void)?
    
    //MARK: - UI Components
    private let titleLabel = UILabel()
    private let seeAllButton = UIButton()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    @objc private func buttonPressed() {
           guard let action = self.action else { return }
           action()
       }
    func setTitle(_ title: String) {
        let text = Constants.Fonts.attributedString(for: title, font: Constants.Fonts.medium, fontSize: 18)
        self.titleLabel.attributedText = text
    }
    //MARK: - Setup Layout
    private func setupLayout() {
        setupSeeAllButton()
        setupTitleLabel()
    }
    private func setupSeeAllButton() {
        self.addSubview(seeAllButton)
        let title = Constants.Fonts.attributedString(for: "SeeAll", font: Constants.Fonts.light, fontSize: 16)
        seeAllButton.setAttributedTitle(title, for: .normal)
        seeAllButton.setTitleColor(Constants.Colors.TypographyColor.typographyColor30, for: .normal)
        seeAllButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seeAllButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.textColor = Constants.Colors.TypographyColor.typographyColor50
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
