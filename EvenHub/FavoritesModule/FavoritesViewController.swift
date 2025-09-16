//
//  Untitled.swift
//  EvenHub
//
//  Created by Евгений Васильев on 16.09.2025.
//
import UIKit

class FavoritesViewController : UIViewController {
  
    enum Constants {
        
    }
    
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
        return view
    }()
    
    //MARK: - SetDelegates
    
    func setDelegates() {
        favCollectionView.delegate = self
        favCollectionView.dataSource = self
        favCollectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "FavCell")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(favLabel)
        view.addSubview(searchButton)
        view.addSubview(favCollectionView)
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
    }
}

//MARK: - Extension CollectionView

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
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
        return cell
    }
    
}
