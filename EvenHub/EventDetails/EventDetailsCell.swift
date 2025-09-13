//
//  EventDetailsCell.swift
//  EvenHub
//
//  Created by Ilnur on 10.09.2025.
//

import UIKit

class EventDetailsCell: UITableViewCell {
    
    // MARK: - UI
    
    let titleEventLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "14 December, 2021"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())
    
    let subtitleEventLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Tuesday, 4:00PM - 9:00PM"
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .gray
        return $0
    }(UILabel())
    
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
    
    
    lazy var cellImage: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
        $0.contentMode = .scaleAspectFill
        
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIImageView())
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        
        contentView.addSubview(cellView)
        contentView.addSubview(titleEventLbl)
        contentView.addSubview(subtitleEventLbl)
        contentView.addSubview(imgView)
        contentView.addSubview(cellImage)
        
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
    
    func configure(with items: Items) {
        titleEventLbl.text = items.title
        subtitleEventLbl.text = items.subtitle
        
        switch items.image {
        case .local(let name):
            cellImage.image = UIImage(named: name)
        case .remote(url: let url):
            break
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
            
//            cellImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            cellImage.centerXAnchor.constraint(equalTo: imgView.centerXAnchor),
            cellImage.centerYAnchor.constraint(equalTo: imgView.centerYAnchor),
            
            titleEventLbl.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 15),
            titleEventLbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 16),

            subtitleEventLbl.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -15),
            subtitleEventLbl.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 16),

        ])
    }
    
    
}
