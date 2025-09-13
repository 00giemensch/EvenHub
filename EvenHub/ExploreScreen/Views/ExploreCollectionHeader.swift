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
        self.titleLabel.text = title
    }
    //MARK: - Setup Layout
    private func setupLayout() {
        setupSeeAllButton()
        setupTitleLabel()
    }
    private func setupSeeAllButton() {
        self.addSubview(seeAllButton)
        seeAllButton.setTitle("SeeAll", for: .normal)
        seeAllButton.setTitleColor(.gray, for: .normal)
        seeAllButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        seeAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            seeAllButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            seeAllButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    private func setupTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.text = "ExploreCollectionHeader title "
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
           // titleLabel.trailingAnchor.constraint(equalTo: seeAllButton.leadingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
