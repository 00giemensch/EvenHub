//
//  SearchCollectionViewCell.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 21.09.2025.
//

import UIKit
import Kingfisher

class SearchCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let cellId = "SearchCollectionViewCell"
    
    //MARK: - UI Components
    private let eventImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let whiteView = UIView()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.attributedText = nil
        eventImageView.image = nil
    }
    
    //MARK: - Public method
    func getImage() -> UIImage {
        guard let image = eventImageView.image else { return UIImage()}
        
        return image == UIImage(systemName: "photo.artframe")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal) ? UIImage() : image
    }
    func configure(with event: FavoriteEvent) {
        let dateString = getStringDate(date: event.startDate, time: event.startTime)
        titleLabel.text = event.title?.capitalized
        dateLabel.attributedText = setupSubtitleAttributedString(date: dateString)
        loadImage(eventImages: event.images)
    }
    
    //MARK: - Support UI methods
    private func loadImage(eventImages: NSSet?) {
        guard let images = eventImages?.allObjects as? [ImagesEntity],
              let strUrl = images[0].image,
              let url = URL(string: strUrl) else { return }
        let placeholderImage = UIImage(systemName: "photo.circle")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        eventImageView.kf.setImage(with: url, placeholder: placeholderImage)
        eventImageView.kf.indicatorType = .activity
    }
    private func setupSubtitleAttributedString(date: String) -> NSAttributedString {
        let subtitleText = NSMutableAttributedString()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Constants.Fonts.medium, size: 12) ?? .systemFont(ofSize: 12, weight: .light),
            .foregroundColor: UIColor(resource: .blue50).withAlphaComponent(0.7)
        ]
        subtitleText.append(NSAttributedString(string: date, attributes: attributes))
        
        return subtitleText
    }
    private func getStringDate(date: String?, time: String?) -> String {
        guard let date, let time else {
            return ""
        }
        let weekDayStr = getWeekDay(date: date)
        let montAndDay = getDayAndMonth(date: date)
        let timeStr = getTime(time: time)
        return montAndDay + " - " + weekDayStr + " - " + timeStr
    }
    private func getDayAndMonth(date: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = inputFormatter.date(from: date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd LLL"
            dateFormatter.locale = Locale(identifier: "en_US")
            let dayMonthStr = dateFormatter.string(from: date)
            return dayMonthStr.uppercased()
        } else {
            return ""
        }
    }
    private func getWeekDay(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        if let dateStr = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "EE"
            let shortWeekday = dateFormatter.string(from: dateStr)
            return shortWeekday.uppercased()
        } else {
            return ""
        }
    }
    private func getTime(time: String) -> String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let timeStr = timeFormatter.date(from: time) {
            timeFormatter.dateFormat = "HH:mm a"
            let resTime = timeFormatter.string(from: timeStr)
            return resTime.uppercased()
        } else {
           return ""
        }
    }
    
    //MARK: - Setup Layout
    private func setupCell() {
        setupBackground()
        setupEventImageView()
        setupDateLabel()
        setupTitleLabel()
    }
    private func setupBackground() {
        contentView.addSubview(whiteView)
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 12
        whiteView.layer.shadowOpacity = 0.1
        whiteView.layer.shadowRadius = 0.5
        whiteView.layer.shadowOffset = .init(width: 0, height: 0)
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            whiteView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            whiteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            whiteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            whiteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1)
        ])
    }
    private func setupEventImageView() {
        whiteView.addSubview(eventImageView)
        eventImageView.backgroundColor = .backgroundGray
        eventImageView.layer.cornerRadius = 16
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.layer.masksToBounds = true
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 10),
            eventImageView.leadingAnchor.constraint(equalTo: whiteView.leadingAnchor, constant: 10),
            eventImageView.bottomAnchor.constraint(equalTo: whiteView.bottomAnchor, constant: -10),
            eventImageView.widthAnchor.constraint(equalToConstant: 79)
        ])
    }
    private func setupTitleLabel() {
        whiteView.addSubview(titleLabel)
        titleLabel.font = UIFont(name: Constants.Fonts.medium, size: 18)
        titleLabel.textColor = UIColor(resource: .color50)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = .zero
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -27),
            titleLabel.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor)
        ])
    }
    private func setupDateLabel() {
        whiteView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: whiteView.topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 18),
            dateLabel.trailingAnchor.constraint(equalTo: whiteView.trailingAnchor, constant: -27)
        ])
    }
}
