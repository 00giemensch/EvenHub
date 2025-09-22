//
//  Untitled.swift
//  EvenHub
//
//  Created by Евгений Васильев on 16.09.2025.
//
import UIKit
import Kingfisher

class FavoritesViewController : UIViewController {
    
    enum Constants {
        
    }
    
    private var favoriteEvents: [FavoriteEvent] = []
    
    //MARK: - Create UI
    
    let favLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .center
        label.text = "Favorites"
        label.numberOfLines = 0
        return label
    }()
    
    let searchButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: FavoritesModel.Constants.searchIcon), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let favCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHidden = true
        return view
    }()
    
    let noFavLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "NO FAVORITES"
        label.numberOfLines = 0
        label.isHidden = false
        return label
    }()
    
    let noFavContainer: UIView = {
        let view = UIView()
        view.isHidden = false
        return view
    }()
    
    let noFavImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: FavoritesModel.Constants.noFavImage)
        view.isHidden = false
        return view
    }()
    
    //MARK: - SetDelegates
    
    func setDelegates() {
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        favCollectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavCell")
    }
    
    //MARK: - Func
    
    private func updateUI() {
        if favoriteEvents.isEmpty {
            favCollectionView.isHidden = true
            noFavContainer.isHidden = false
            noFavImageView.isHidden = false
        } else {
            favCollectionView.isHidden = false
            noFavContainer.isHidden = true
            noFavImageView.isHidden = true
        }
    }
    
    private func loadFavoriteEvents() {
        favoriteEvents = CoreDataManager.shared.getAllFavoriteEvents()
        updateUI()
        favCollectionView.reloadData()
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
        loadFavoriteEvents()
        print("✅ navigationController: \(String(describing: navigationController))")
        print("✅ parent: \(String(describing: parent))")
        print("✅ tabBarController: \(String(describing: tabBarController))")
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(favLabel)
        view.addSubview(searchButton)
        view.addSubview(favCollectionView)
        view.addSubview(noFavContainer)
        noFavContainer.addSubview(noFavLabel)
        view.addSubview(noFavImageView)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        favLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            favLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        favCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favCollectionView.topAnchor.constraint(equalTo: favLabel.bottomAnchor, constant: 24),
            favCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            favCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            favCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        noFavContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noFavContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 72),
            noFavContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72),
            noFavContainer.topAnchor.constraint(equalTo: favLabel.bottomAnchor, constant: 103),
            noFavContainer.heightAnchor.constraint(equalToConstant: 240)
        ])
        
        noFavLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noFavLabel.centerXAnchor.constraint(equalTo: noFavContainer.centerXAnchor),
            noFavLabel.centerYAnchor.constraint(equalTo: noFavContainer.centerYAnchor),
        ])
        
        noFavImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noFavImageView.centerXAnchor.constraint(equalTo: noFavContainer.centerXAnchor),
            noFavImageView.topAnchor.constraint(equalTo: noFavContainer.bottomAnchor, constant: -34),
            noFavImageView.widthAnchor.constraint(equalToConstant: 136),
            noFavImageView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
}

//MARK: - Extension CollectionView

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteEvents.count
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavCell", for: indexPath) as! FavoriteCell
        let event = favoriteEvents[indexPath.item]
        cell.configure(with: event)
        cell.favoriteButtonAction = { [weak self] in
            guard let self = self else { return }
            
            let isAlreadyFavorite = CoreDataManager.shared.isEventFavorite(eventId: event.id ?? "")
            
            if isAlreadyFavorite {
                let success = CoreDataManager.shared.removeFromFavorites(eventId: event.id ?? "")
                if success {
                    cell.isAddedInFavorite = false
                    // Обновляем список после удаления
                    self.loadFavoriteEvents()
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? FavoriteCell else { return }
        let image = cell.getImage()
        let selectedEvent = favoriteEvents[indexPath.item]
        let vc = EventDetailsVC(event: selectedEvent, image: image)
        vc.configureWithEvent(event: selectedEvent)
        present(vc, animated: true)
    }
}
