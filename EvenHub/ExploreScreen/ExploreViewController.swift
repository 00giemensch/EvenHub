//
//  ExploreViewController.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 09.09.2025.
//

import UIKit

class ExploreViewController: UIViewController {
    //MARK: - Properties
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: exploreCollectionView) { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.cellId, for: indexPath) as! ExploreCollectionViewCell
        cell.configure()
        return cell
    }
    
    //MARK: - UI Components
    private lazy var exploreCollectionView: UICollectionView = {
//        let layout = createLayout()
//        layout.itemSize = CGSize(width: 237, height: 255)
//        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
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
        setDataSource()
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
    private func setDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([1,2])
        snapshot.appendItems(Array(0...5), toSection: 1)
        snapshot.appendItems(Array(6...10), toSection: 2)
        dataSource.apply(snapshot)
    }
    private func createLayout() -> UICollectionViewCompositionalLayout {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(255)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(237),
                heightDimension: .absolute(255)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.contentInsets = NSDirectionalEdgeInsets(top: 18, leading: 16, bottom: 16, trailing: 16)
            section.interGroupSpacing = 10
            
        
            let layout = UICollectionViewCompositionalLayout(section: section)
                   
            return layout
    }

    
    private func setupCollectionView() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.delegate = self
        exploreCollectionView.showsHorizontalScrollIndicator = false
        exploreCollectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: ExploreCollectionViewCell.cellId)
        exploreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        exploreCollectionView.backgroundColor = .blue
        
        NSLayoutConstraint.activate([
            exploreCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.17),
            exploreCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exploreCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            exploreCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.32)
            exploreCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.72)
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

#Preview{
    ExploreViewController()
}
