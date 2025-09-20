//
//  Events.swift
//  EventsApp
//
//  Created by Никита Грицунов on 10.09.2025.
//

import UIKit

class EventsViewController: UIViewController {
    
    //MARK: - Constants
    private let exploreButtonTitle = NSAttributedString(string: "EXPLORE EVENTS", attributes: [.kern: 1.0])
    private let segmented = CapsuleSegmentedControl(items: ["UPCOMING", "PAST EVENTS"])
    private let topFadeView = UIView()
    private let bottomFadeView = UIView()
    private let coreDM = CoreDataManager.shared
    
    
    
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Events"
        element.font = .systemFont(ofSize: 24, weight: .medium)
        element.textColor = Constants.Colors.TypographyColor.typographyColor50
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var eventsCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.itemSize = CGSize(width: 327, height: 106)
        viewLayout.scrollDirection = .vertical
        viewLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 120, right: 0)

        let element = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        element.showsVerticalScrollIndicator = false
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var exploreButton: UIButton = {
        let element = UIButton(type: .custom)
        
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 17
        
        element.layer.shadowColor = UIColor(red: 111 / 255, green: 126 / 255, blue: 201 / 255, alpha: 0.25).cgColor
        element.layer.shadowRadius = 25
        element.layer.shadowOffset = CGSize(width: 0, height: 10)
        element.layer.shadowOpacity = 1
    
        
        
        
        
        element.configuration = configuration
        element.contentHorizontalAlignment = .right
        element.setAttributedTitle(exploreButtonTitle, for: .normal)
        element.tintColor = .white
        element.backgroundColor = Constants.Colors.PrimaryBlue.blue50
        element.layer.cornerRadius = 15
        element.setImage(UIImage.group4, for: .normal)
        
        element.addTarget(self, action: #selector(exploreButtonTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var calendarIcon: UIImageView = {
        let element = UIImageView()
        element.image = .upcomingEventsIcon
        element.isHidden = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        eventsCollectionView.delegate = self
        eventsCollectionView.dataSource = self
        eventsCollectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.cellID)
        
        setViews()
        setupConstraints()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupFade()
    }
    
    //MARK: - Methods
    @objc private func exploreButtonTapped() {
        print("Explore button tapped")
    }
    private func setupFadeView(_ view: UIView, _ isTop: Bool) {
        let gradient = CAGradientLayer()
        gradient.colors = isTop ? [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor] : [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        gradient.locations = [0, 1]
        
        view.layer.addSublayer(gradient)
        view.isUserInteractionEnabled = false
    }
    private func setupFade() {
        topFadeView.frame = CGRect(
            x: eventsCollectionView.frame.minX,
            y: eventsCollectionView.frame.minY,
            width: eventsCollectionView.bounds.width,
            height: 20
        )
        if let gradient = topFadeView.layer.sublayers?.first as? CAGradientLayer {
            gradient.frame = topFadeView.bounds
        }
        
        bottomFadeView.frame = CGRect(
            x: eventsCollectionView.frame.minX,
            y: eventsCollectionView.frame.maxY - 20,
            width: eventsCollectionView.bounds.width,
            height: 20
        )
        if let gradient = bottomFadeView.layer.sublayers?.last as? CAGradientLayer {
            gradient.frame = bottomFadeView.bounds
        }
    }
}

//MARK: - Setup constraints and set views
extension EventsViewController {
    private func setViews() {
        
        view.addSubview(titleLabel)
        view.addSubview(eventsCollectionView)
        view.addSubview(topFadeView)
        view.addSubview(bottomFadeView)
        view.addSubview(exploreButton)
        view.addSubview(segmented)
        view.addSubview(calendarIcon)
        setupFadeView(topFadeView, true)
        setupFadeView(bottomFadeView, false)
        
        
        if eventsCollectionView.numberOfItems(inSection: 0) == 0 {
            calendarIcon.isHidden = false
        }
        
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.addTarget(self, action: #selector(segmentedChanged), for: .valueChanged)
        
    }
    private func setupConstraints() {
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        // eventsCollectionView
        NSLayoutConstraint.activate([
            eventsCollectionView.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 10),
            eventsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            eventsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            eventsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        // segmented
        NSLayoutConstraint.activate([
            segmented.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            segmented.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmented.widthAnchor.constraint(equalToConstant: 300),
            segmented.heightAnchor.constraint(equalToConstant: 44)
        ])
        // exploreButton
        NSLayoutConstraint.activate([
            exploreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -128),
            exploreButton.heightAnchor.constraint(equalToConstant: 58),
            exploreButton.widthAnchor.constraint(equalToConstant: 271),
            exploreButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        //calendareIcon
        NSLayoutConstraint.activate([
            calendarIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    @objc func segmentedChanged() {
            print("Selected index: \(segmented.selectedIndex)")
        }
}

//MARK: - Extension UICollectionViewDelegate & UICollectionViewDataSource
extension EventsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
        //        return CoreDataManager.shared.getCachedEventsCount()
}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.cellID, for: indexPath) as! FavoriteCell
        let events = coreDM.getCachedEvents(cacheKey: "title")
        print(events)
        return cell
    }
}
