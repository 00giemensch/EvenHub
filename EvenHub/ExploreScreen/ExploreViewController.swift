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
    private let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    private var isLocationListVisible = false
    private var locationListHeightConstraint = NSLayoutConstraint()
    private var tapOutsideGesture = UITapGestureRecognizer()
    
    //MARK: - UI Components
    private let locationButton = UIButton()
    private let locationLabel = UILabel()
    private let locationList = UITableView()
    private let searchTextField = SearchTextField(scheme: .gray)
    private lazy var exploreCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = Constants.Colors.Background.exploreBackground
        createBezier(on: view, withColor: Constants.Colors.Background.backgroundBlue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTapGesture()
    }
    //MARK: - Methods
    private func setupTapGesture() {
        tapOutsideGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapOutsideGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideGesture)
    }
    
    @objc private func changeLocationListVisible() {
        isLocationListVisible.toggle()
        if !isLocationListVisible {
            locationList.isHidden = true
            locationListHeightConstraint.constant = 0
        } else {
            UIView.animate(withDuration: 0.3) {
                self.locationList.isHidden = false
                let offset = self.options.count * 38 < 300  ? CGFloat(self.options.count * 38) : 300
                self.locationListHeightConstraint.constant += offset
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        guard isLocationListVisible,
              !locationList.frame.contains(location),
              !locationButton.frame.contains(location) else { return }
        changeLocationListVisible()
    }
    
    //MARK: - Setup UI
    private func setupLayout() {
        setupSearchTextField()
        setupCollectionView()
        setDataSource()
        setupLocationBar()
    }
    private func createBezier(on view: UIView, withColor color: UIColor) {
        let shapeLayer = CAShapeLayer()
        view.layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = color.cgColor
        let rect = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: view.frame.height * 0.221
        )
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [.bottomRight, .bottomLeft],
            cornerRadii: CGSize(width: 33, height: 33)
        )
        shapeLayer.path = path.cgPath
    }
    private func setDataSource() {
        setDataSourceSnapshots()
        setSectionHeader()
    }
    private func setDataSourceSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([1,2])
        snapshot.appendItems(Array(0...5), toSection: 1)
        snapshot.appendItems(Array(6...10), toSection: 2)
        dataSource.apply(snapshot)
    }
    private func setupLocationBar() {
        setupLocationButton()
        setupLocationLabel()
        setupLocationList()
    }
    private func setupLocationButton() {
        view.addSubview(locationButton)
        let titleText = NSMutableAttributedString()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Constants.Fonts.medium, size: 13) ?? .systemFont(ofSize: 13, weight: .light),
            .foregroundColor: UIColor(resource: .blue10)
        ]
        titleText.append(NSAttributedString(string: "Current Location", attributes: attributes))
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(UIColor(resource: .blue0), renderingMode: .alwaysTemplate)
        attachment.bounds = CGRect(x: 0, y: 0, width: 10, height: 5)
        let imageString = NSAttributedString(attachment: attachment)
        
        titleText.append(imageString)
        
        
        locationButton.setAttributedTitle(titleText, for: .normal)
        locationButton.setTitleColor(.black, for: .normal)
        locationButton.contentHorizontalAlignment = .left
        locationButton.addTarget(self, action: #selector(changeLocationListVisible), for: .touchUpInside)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationButton.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            locationButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    private func setupLocationLabel() {
        view.addSubview(locationLabel)
        locationLabel.text = "City"
        locationLabel.font = UIFont(name: Constants.Fonts.medium, size: 13)
        locationLabel.textColor = .white
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: locationButton.bottomAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationButton.leadingAnchor)
        ])
    }
    private func setupLocationList() {
        view.addSubview(locationList)
        locationList.delegate = self
        locationList.dataSource = self
        locationList.isHidden = true
        locationList.separatorStyle = .none
        locationList.layer.cornerRadius = 8
        locationList.showsVerticalScrollIndicator = false
        locationList.backgroundColor = Constants.Colors.Background.backgroundBlue
        locationList.register(ExploreTableViewCell.self, forCellReuseIdentifier: ExploreTableViewCell.identifire)
        locationList.translatesAutoresizingMaskIntoConstraints = false
        locationListHeightConstraint = locationList.bottomAnchor.constraint(equalTo: locationButton.bottomAnchor)
        locationListHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            locationList.topAnchor.constraint(equalTo: locationButton.bottomAnchor),
            locationList.leadingAnchor.constraint(equalTo: locationButton.leadingAnchor),
            locationList.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            locationListHeightConstraint
        ])
    }
    private func setupSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.action = { [weak self] in
            print("filter button tup")
        }
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func setSectionHeader() {
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ExploreCollectionHeader.reuseID,
                for: indexPath
            ) as! ExploreCollectionHeader
            header.action = { [weak self] in
                print("seeAll button tup")
            }
            if indexPath.section == 0 {
                header.setTitle("Upcoming Events")
            } else {
                header.setTitle("Nearby You")
            }
            
            return header
        }
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
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 8,
            leading: 16,
            bottom: 8,
            trailing: 16
        )
        section.interGroupSpacing = 16
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(34)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setupCollectionView() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.backgroundColor = .clear
        exploreCollectionView.delegate = self
        exploreCollectionView.showsHorizontalScrollIndicator = false
        exploreCollectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: ExploreCollectionViewCell.cellId)
        exploreCollectionView.register(ExploreCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ExploreCollectionHeader.reuseID)
        exploreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exploreCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: view.frame.height * 0.17),
            exploreCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exploreCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //            exploreCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.32)
            exploreCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.72)
        ])
    }
}

//MARK: - CollectionView Delegate
extension ExploreViewController: UICollectionViewDelegate {
    
}

//MARK: - TableView Delegate and DataSource
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreTableViewCell.identifire, for: indexPath) as! ExploreTableViewCell
        cell.configure(with: options[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("=\(options[indexPath.row])=")
        locationLabel.text = options[indexPath.row]
        isLocationListVisible = true
        changeLocationListVisible()
    }
}
