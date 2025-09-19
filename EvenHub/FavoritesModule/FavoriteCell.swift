//
//  FavoriteCell.swift
//  EvenHub
//
//  Created by Евгений Васильев on 16.09.2025.
//
import UIKit

class FavoriteCell: UICollectionViewCell {
    static let cellID = "eventCell"
    
    let leftImageView : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 12
        view.backgroundColor = Constants.Colors.Background.gray
        view.image = UIImage(resource: .underConstruction3)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textColor = .blue50
        label.font = UIFont(name: FavoritesModel.Constants.airBnbCerealBookFont, size: 13)
        label.textAlignment = .left
        label.text = "Wed, Apr 28 • 5:30 PM"
        label.numberOfLines = 1
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .left
        label.text = "Jo Malone London’s Mother’s Day Presents"
        label.numberOfLines = 0
        return label
    }()
    
    let mapPointIcon : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: FavoritesModel.Constants.mapPointIcon)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.color30
        label.font = UIFont(name: FavoritesModel.Constants.airBnbCerealBookFont, size: 13)
        label.textAlignment = .left
        label.text = "Radius Gallery • Santa Cruz, CA"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 1
        return label
    }()
    
    let favIcon : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: FavoritesModel.Constants.favoriteIcon)
        return view
    }()
    
    //MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
        setShadow()
        setCornerRadius()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(leftImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mapPointIcon)
        contentView.addSubview(locationLabel)
        contentView.addSubview(favIcon)
        contentView.backgroundColor = .white
    }
    
    func setShadow() {
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 5
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.masksToBounds = false
    }
    
    func setCornerRadius() {
        contentView.layer.cornerRadius = 15
    }
    
    private func setConstraints() {
        leftImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftImageView.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            leftImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            leftImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7),
            leftImageView.widthAnchor.constraint(equalToConstant: 79),
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 9),
            dateLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 18)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 18)
        ])
        
        mapPointIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapPointIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 11),
            mapPointIcon.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 18),
            mapPointIcon.widthAnchor.constraint(equalToConstant: 14),
            mapPointIcon.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationLabel.centerYAnchor.constraint(equalTo: mapPointIcon.centerYAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            locationLabel.leadingAnchor.constraint(equalTo: mapPointIcon.trailingAnchor, constant: 6)
        ])
        
        favIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favIcon.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            favIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -7),
            favIcon.widthAnchor.constraint(equalToConstant: 16),
            favIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
}



