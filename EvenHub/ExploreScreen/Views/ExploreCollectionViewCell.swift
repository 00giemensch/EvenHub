//
//  ExploreCollectionViewCell.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 09.09.2025.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let cellId = "ExploreCollectionViewCell"
    var isAddedInFavorite: Bool = false {
        didSet {
            fillingBookmark()
        }
    }
    var favoriteButtonAction: (() -> Void)?
    
    //MARK: - UI Components
    private let eventImageView = UIImageView()
    private let favoriteButton = UIButton()
    private let dateLabel = ExploreCellDateView()
    private let avatarsHStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
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
        subtitleLabel.attributedText = nil
        eventImageView.image = UIImage(systemName: "photo.artframe")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        dateLabel.removeText()
        avatarsHStack.subviews.forEach { $0.removeFromSuperview() }
        isAddedInFavorite = false
    }
    
    //MARK: - Methods
    func configure() {
        let image = UIImage(systemName: "photo.artframe")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        eventImageView.image = image
        titleLabel.text = "Title text fot testing textLabel"
        dateLabel.setDate(day: "10", month: "September")
        fillingHStack(URLs: ["person.circle","person.circle","person.circle","person.circle","person.circle"])
        subtitleLabel.attributedText = setupSubtitleAttributedString(place: "Subtitle text for subtitle lable")
    }
    //MARK: - Private methods
    @objc private func buttonPressed() {
        isAddedInFavorite.toggle()
        guard let action = self.favoriteButtonAction else { return }
        action()
    }
    private func fillingBookmark() {
        favoriteButton.tintColor = isAddedInFavorite ? .systemRed : .gray
    }
    
    //MARK: - Support UI methods
    private func setupSubtitleAttributedString(place: String) -> NSAttributedString {
        let subtitleText = NSMutableAttributedString()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Constants.Fonts.light, size: 13) ?? .systemFont(ofSize: 13, weight: .light),
            .foregroundColor: Constants.Colors.TypographyColor.typographyColor30 ?? .systemGray3
        ]
        let attachment = NSTextAttachment()
        attachment.image = UIImage(resource: .mapEventLocation)
        let imageString = NSAttributedString(attachment: attachment)
        subtitleText.append(imageString)
        subtitleText.append(NSAttributedString(string: " " + place, attributes: attributes))
        
        return subtitleText
    }
    private func createAvatarImageView(avatarURL: String) -> UIImageView {
        let avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 12
        let image = UIImage(systemName: avatarURL)?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        avatarImageView.image = image
        avatarImageView.backgroundColor = .white
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 2
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 24),
            avatarImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        return avatarImageView
    }
    private func fillingHStack(URLs: [String]) {
        guard URLs.count > 0 else { return }
        if URLs.count <= 3 {
            URLs.forEach { avatarsHStack.addArrangedSubview(createAvatarImageView(avatarURL: $0)) }
        } else {
            for i in 0..<3 {
                avatarsHStack.addArrangedSubview(createAvatarImageView(avatarURL: URLs[i]))
            }
            let count = URLs.count - 3
            let avatarsCountLabel = UILabel()
            let text = "+\(count) Going"
            let countText = NSMutableAttributedString()
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: Constants.Fonts.medium, size: 13) ?? UIFont.systemFont(ofSize: 13),
                .foregroundColor: UIColor(resource: .blue50)
            ]
            countText.append(NSAttributedString(string: text, attributes: attributes))
            avatarsCountLabel.attributedText = countText
            avatarsCountLabel.translatesAutoresizingMaskIntoConstraints = false
            avatarsHStack.addArrangedSubview(avatarsCountLabel)
            avatarsHStack.setCustomSpacing(10, after: avatarsHStack.subviews[2])
        }
    }
    private func fetchImage(with imageUrl: String, completion: @escaping ((UIImage) -> Void)) {
        guard let url = URL(string: imageUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                print("Error: \(String(describing: error?.localizedDescription))")
                return
            }
            completion(image)
        }.resume()
    }
    
    //MARK: - Setup Layout
    private func setupCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        setupEventImageView()
        setupTitleLabel()
        setupFavoriteButton()
        setupDateLabel()
        setupAvatarHStack()
        setupSubtitleLabel()
    }
    private func setupEventImageView() {
        eventImageView.backgroundColor = .backgroundGray
        eventImageView.layer.cornerRadius = 16
        let image = UIImage(systemName: "photo.artframe")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        eventImageView.image = image
        eventImageView.contentMode = .scaleAspectFit
        eventImageView.layer.masksToBounds = true
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        let shadowView = UIView()
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowRadius = 1
        shadowView.layer.shadowOffset = .init(width: 0, height: 0)
        shadowView.layer.cornerRadius = 20
        shadowView.frame = eventImageView.bounds
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: shadowView.layer.cornerRadius).cgPath
        contentView.addSubview(shadowView)
        shadowView.addSubview(eventImageView)
        
        NSLayoutConstraint.activate([
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9),
            eventImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            eventImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height * 0.514)
        ])
    }
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont(name: Constants.Fonts.bold, size: 18)
        titleLabel.textColor = UIColor(resource: .color50)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor),
        ])
    }
    private func setupFavoriteButton() {
        contentView.addSubview(favoriteButton)
        favoriteButton.backgroundColor = .white.withAlphaComponent(0.7)
        favoriteButton.layer.cornerRadius = 7
        let image = UIImage(resource: .favorite).withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(image, for: .normal)
        fillingBookmark()
        favoriteButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: 8),
            favoriteButton.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: -8),            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.layer.backgroundColor = UIColor.white.cgColor
        dateLabel.layer.cornerRadius = 10
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: eventImageView.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor, constant: 8),
            dateLabel.widthAnchor.constraint(equalToConstant: 45),
            dateLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    private func setupAvatarHStack() {
        contentView.addSubview(avatarsHStack)
        avatarsHStack.axis = .horizontal
        avatarsHStack.spacing = -10
        avatarsHStack.distribution = .fill
        avatarsHStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarsHStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            avatarsHStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            avatarsHStack.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    private func setupSubtitleLabel() {
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: avatarsHStack.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: eventImageView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: eventImageView.trailingAnchor)
        ])
    }
}
