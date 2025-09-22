//
//  Events.swift
//  EventsApp
//
//  Created by Никита Грицунов on 10.09.2025.
//

import UIKit
import MapKit


class MapViewController: UIViewController {
    let iOSCoordinate = CLLocationCoordinate2D(latitude: 36.72046, longitude: 25.32879)
    let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    
    //MARK: - UI components
    private lazy var mapView: MKMapView = {
        let element = MKMapView()
        element.mapType = .standard

        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 11
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = .init(width: 100, height: 39)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    private let favoriteCellView = FavoriteCell(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 327, height: 106)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let region = MKCoordinateRegion(center: iOSCoordinate, span: coordinateSpan)
        mapView.delegate = self
        mapView.setRegion(region, animated: true)
        
        view.addSubview(mapView)
        view.addSubview(categoryCollectionView)
        
        setConstraints()
        setupFavoriteCellView()
        setupCategoryCollectionView()
        
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    private func setupCategoryCollectionView() {
        view.addSubview(categoryCollectionView)
        categoryCollectionView.backgroundColor = .clear
        categoryCollectionView.dataSource = self
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.register(MapCategoryCell.self, forCellWithReuseIdentifier: MapCategoryCell.cellID)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 96),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    private func setupFavoriteCellView() {
        view.addSubview(favoriteCellView)
        favoriteCellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteCellView.heightAnchor.constraint(equalToConstant: 106),
            favoriteCellView.widthAnchor.constraint(equalToConstant: 327),
            favoriteCellView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favoriteCellView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -128)
        ])
    }
    
    
}

//MARK: - Extension MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {

}

//MARK: - CollectionView Delegate
extension MapViewController: UICollectionViewDelegate {
    
}
//MARK: - CollectionView DataSource
extension MapViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ExploreViewModel.shared.category.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapCategoryCell.cellID, for: indexPath) as! MapCategoryCell
        cell.setCategory(ExploreViewModel.shared.category[indexPath.row])
        cell.action = { [weak self] in
            print("categoty cell tup")
        }
        return cell
    }
}
