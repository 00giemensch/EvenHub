//
//  ExploreViewController.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 09.09.2025.
//

import UIKit

class ExploreViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - UI Components
    private lazy var exploreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 237, height: 255)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGray5
        createBezier(on: view, withColor: .systemBlue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    //MARK: - Methods
    
    //MARK: - Setup UI
    private func setupLayout() {
        setupCollectionView()
    }
    private func createBezier(on view: UIView, withColor color: UIColor) {
        let shapeLayer = CAShapeLayer()
        view.layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = color.cgColor
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.221)
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.bottomRight, .bottomLeft],
                                cornerRadii: CGSize(width: 33, height: 33))
        shapeLayer.path = path.cgPath
    }
    private func setupCollectionView() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.delegate = self
        exploreCollectionView.dataSource = self
        exploreCollectionView.showsHorizontalScrollIndicator = false
        exploreCollectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: ExploreCollectionViewCell.cellId)
        exploreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        exploreCollectionView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            exploreCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.3),
            exploreCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exploreCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exploreCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.32)
        ])
        
    }
}

//MARK: - ... Delegate and DataSource
extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ExploreCollectionViewCell.cellId,
            for: indexPath
        ) as? ExploreCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure()
        
        return cell
    }
}
