//
//  EventCell.swift
//  EvenHub
//
//  Created by Никита Грицунов on 16.09.2025.
//

import UIKit

class EventCell: UICollectionViewCell {
    //MARK: - Constants
    static let cellID = "EventCell"
    private var isAddedInFavorite: Bool = false {
        didSet {
            fillingBookmark()
        }
    }
    
    private enum Drawings {
        static var imageCornerRadius: CGFloat { 10 }
        static var imageViewFrame: CGRect { CGRect(x: 0, y: 0, width: 79, height: 92)}
        static var locationViewFrame: CGRect { CGRect(x: 0, y: 0, width: 14, height: 14)}
    }
    
    
    //MARK: - UI elements
    private lazy var imageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(resource: .underConstruction3)
        element.contentMode = .scaleAspectFill
        element.layer.cornerRadius = Drawings.imageCornerRadius
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var dateLabel: UILabel = {
        let element = UILabel()
        element.text = "Fri, Apr 23 • 6:00 PM"
        element.font = UIFont(name: Constants.Fonts.book, size: 13)
        element.textColor = Constants.Colors.PrimaryBlue.blue50
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    private lazy var eventTitleLabel: UILabel = {
        let element = UILabel()
        element.text = "Jo Malone London’s Mother’s Day Presents"
        element.font = .systemFont(ofSize: 15, weight: .medium)
        element.textColor = Constants.Colors.TypographyColor.typographyColor50
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var locationLabel: UILabel = {
        let element = UILabel()
        element.text = "Radius Gallery"
        element.font = UIFont(name: Constants.Fonts.book, size: 13)
        element.textColor = Constants.Colors.TypographyColor.typographyColor30
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var pointer: UIImageView = {
        let element = UIImageView()
        element.image = Constants.Icons.Map.eventLocation
        element.frame = Drawings.locationViewFrame
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var bookmark: UIImageView = {
        let element = UIImageView()
        element.image = Constants.Icons.Common.favoriteEmpty
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(resource: .underConstruction3)
        dateLabel.text = nil
        eventTitleLabel.text = nil
        locationLabel.text = nil
        pointer.image = Constants.Icons.Map.eventLocation
        isAddedInFavorite = false
        
    }
    
    private lazy var mainStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 18
        element.distribution = .fillProportionally
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var cellStack: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.distribution = .fillProportionally
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var locationStack: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.alignment = .leading
        element.spacing = 6
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private func setViews() {
        
        locationStack.addArrangedSubview(pointer)
        locationStack.addArrangedSubview(locationLabel)
        
        cellStack.addArrangedSubview(dateLabel)
        cellStack.addArrangedSubview(eventTitleLabel)
        cellStack.addArrangedSubview(locationStack)
        
        mainStack.addArrangedSubview(imageView)
        mainStack.addArrangedSubview(cellStack)
        
        contentView.addSubview(mainStack)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 92),
            imageView.widthAnchor.constraint(equalToConstant: 79)
            
        ])
    }
    
    
    private func fillingBookmark() {
        bookmark.image = isAddedInFavorite ? Constants.Icons.Common.favoriteSelected : Constants.Icons.Common.favoriteEmpty
    }
}
