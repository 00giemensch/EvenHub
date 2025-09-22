//
//  EventDetailsCell.swift
//  EvenHub
//
//  Created by Ilnur on 10.09.2025.
//

import UIKit

// MARK: - test version
class EventDetailsCell: UITableViewCell {
    
    // MARK: - UI
    
    let titleEventLbl = UILabel.make(
        text: "14 December, 2021",
        font: UIFont(name: Constants.Fonts.book, size: 16),
        kern: 0.6
    )
    
    let subtitleEventLbl = UILabel.make(
        text: "Tuesday, 4:00PM - 9:00PM",
        font: UIFont(name: Constants.Fonts.book, size: 12),
        color: .gray,
    )
    
    lazy var cellView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        return $0
    }(UIView())
    
    lazy var imgView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .blue10
        $0.heightAnchor.constraint(equalToConstant: 53).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 53).isActive = true
        return $0
    }(UIView())
    
    
    lazy var cellImage = UIImageView.make(
        contentMode: .scaleAspectFill,
        cornerRadius: 12,
        height: 30,
        width: 30
    )
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true

        contentView.addSubviews(cellView, titleEventLbl, subtitleEventLbl, imgView, cellImage)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        titleEventLbl.text = nil
        subtitleEventLbl.text = nil
        cellImage.image = nil
    }
    
    // MARK: - Configure
        func configure(with item: Items) {
            titleEventLbl.text = item.title
            subtitleEventLbl.text = item.subtitle
            
            switch item.image {
            case .local(let name):
                cellImage.image = name.isEmpty ? UIImage(named: "filter_art") : UIImage(named: name)
                imgView.isHidden = name.isEmpty && UIImage(named: "filter_art") == nil
            case .remote(let url):
                cellImage.load(urlString: url)
                imgView.isHidden = url.isEmpty
            case nil:
                cellImage.image = UIImage(named: "filter_art")
                imgView.isHidden = UIImage(named: "filter_art") == nil
            }
        }
    
    // MARK: - Layout
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            imgView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            imgView.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            
            cellImage.centerXAnchor.constraint(equalTo: imgView.centerXAnchor),
            cellImage.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            
            titleEventLbl.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 13),
            titleEventLbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 16),

            subtitleEventLbl.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -13),
            subtitleEventLbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 16),

        ])
    }
    
    
}
