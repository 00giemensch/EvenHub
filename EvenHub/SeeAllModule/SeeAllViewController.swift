//
//  SeeAllViewController.swift
//  EvenHub
//
//  Created by Евгений Васильев on 17.09.2025.
//
import UIKit

class SeeAllViewController : UIViewController {
  
    enum SeeAllType {
        case upcoming
        case nearby
    }
    
    private let events: [FavoriteEvent]
    private let type: SeeAllType
    
    //MARK: - Create UI
    
    let eventsLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .center
        label.text = "Events"
        label.numberOfLines = 0
        return label
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: SeeAllModel.Constants.backButtonIcon), for: .normal)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let searchButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: SeeAllModel.Constants.searchIcon), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let seeAllCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHidden = false
        return view
    }()
    
    //MARK: - Init
    
    init(events: [FavoriteEvent], type: SeeAllType) {
        self.events = events
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - SetDelegates
    
    func setDelegates() {
        seeAllCollectionView.delegate = self
        seeAllCollectionView.dataSource = self
        seeAllCollectionView.register(SeeAllCell.self, forCellWithReuseIdentifier: "SeeAllCell")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
        eventsLabel.text = type == .upcoming ? "Upcoming Events" : "Nearby Events"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(eventsLabel)
        view.addSubview(searchButton)
        view.addSubview(seeAllCollectionView)
        view.addSubview(backButton)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        eventsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            eventsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 57)
        ])
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        seeAllCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeAllCollectionView.topAnchor.constraint(equalTo: eventsLabel.bottomAnchor, constant: 24),
            seeAllCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seeAllCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            seeAllCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            seeAllCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: eventsLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 22),
            backButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    //MARK: - Methods
    @objc private func backButtonTapped() {
        print("backButtonTapped")
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - Extension CollectionView

extension SeeAllViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 48
        let height: CGFloat = 106
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeeAllCell", for: indexPath) as! SeeAllCell
        let event = events[indexPath.item]
        cell.configure(with: event)
        cell.favoriteButtonAction = { [weak self] in
            guard let self = self else { return }
            let isAlreadyFavorite = CoreDataManager.shared.isEventFavorite(eventId: event.id ?? "")
            if isAlreadyFavorite {
                let success = CoreDataManager.shared.removeFromFavorites(eventId: event.id ?? "")
                if success {
                    cell.isAddedInFavorite = false
                }
            } else {
                let success = CoreDataManager.shared.addToFavorites(from: event)
                if success {
                    cell.isAddedInFavorite = true
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SeeAllCell else { return }
        let image = cell.getImage()
        let selectedEvent = events[indexPath.item]
        let vc = EventDetailsVC(event: selectedEvent, image: image)
        vc.configureWithEvent(event: selectedEvent)
        present(vc, animated: true)
    }
    
}

