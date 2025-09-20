//
//  ExploreViewController.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 09.09.2025.
//

import UIKit

class ExploreViewController: UIViewController {
    //MARK: - Properties
    private let viewModel = ExploreViewModel.shared
    private lazy var dataSource = UICollectionViewDiffableDataSource<Int, EventDTO>(collectionView: exploreCollectionView) { collectionView, indexPath, itemIdentifier in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.cellId, for: indexPath) as! ExploreCollectionViewCell
        cell.configure(with: itemIdentifier)
        return cell
    }
    private var isLocationListVisible = false
    private var locationListHeightConstraint = NSLayoutConstraint()
    private var tapOutsideGesture = UITapGestureRecognizer()
    
    //MARK: - UI Components
    private let locationButton = UIButton()
    private let locationLabel = UILabel()
    private let locationList = UITableView()
    private let notificationButton = UIButton()
    private let searchTextField = SearchTextField(scheme: .gray)
    private lazy var exploreCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        return collectionView
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
        
        Task {
            await viewModel.fetchLocations()
            await viewModel.fetchUpcomingEvents()
            
        }
        viewModel.locationsIsLoaded = { [weak self] locationsPlaces in
            DispatchQueue.main.async {
                self?.locationLabel.text = locationsPlaces.first
                self?.locationList.reloadData()
            }
        }
        
        viewModel.eventsIsLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.setDataSourceSnapshots()
                self?.exploreCollectionView.reloadData()
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
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
                let locationsCount = self.viewModel.locationPlaces.count
                let offset = locationsCount * 38 < 300  ? CGFloat(locationsCount * 38) : 300
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
        setupCategoryCollectionView()
        setupExploreCollectionView()
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
//        setDataSourceSnapshots()
        setSectionHeader()
    }
    private func setDataSourceSnapshots() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, EventDTO>()
        snapshot.appendSections([1,2])
        let count = viewModel.upcomingEvents.count
        let half = count / 2
        snapshot.appendItems(Array(viewModel.upcomingEvents[0..<half]), toSection: 1)
        snapshot.appendItems(Array(viewModel.upcomingEvents[half..<count]), toSection: 2)
        dataSource.apply(snapshot)
    }
    private func setupLocationBar() {
        setupLocationButton()
        setupLocationLabel()
        setupLocationList()
        setupLocationBatton()
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
        locationLabel.text = "Finding your location..."
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
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.14),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func setupLocationBatton() {
        view.addSubview(notificationButton)
        notificationButton.setImage(UIImage(resource: .navNotificationFill), for: .normal)
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            notificationButton.centerYAnchor.constraint(equalTo: locationLabel.topAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notificationButton.widthAnchor.constraint(equalToConstant: 36),
            notificationButton.heightAnchor.constraint(equalToConstant: 36)
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
    private func setupExploreCollectionView() {
        view.addSubview(exploreCollectionView)
        exploreCollectionView.backgroundColor = .clear
        exploreCollectionView.delegate = self
        exploreCollectionView.showsHorizontalScrollIndicator = false
        exploreCollectionView.register(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: ExploreCollectionViewCell.cellId)
        exploreCollectionView.register(ExploreCollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ExploreCollectionHeader.reuseID)
        exploreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            exploreCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 10),
            exploreCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exploreCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            exploreCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.72)
        ])
    }
    private func setupCategoryCollectionView() {
        view.addSubview(categoryCollectionView)
        categoryCollectionView.backgroundColor = .clear
        categoryCollectionView.dataSource = self
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.register(ExploreCategoryCell.self, forCellWithReuseIdentifier: ExploreCategoryCell.cellID)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryCollectionView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.221),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

//MARK: - CollectionView Delegate
extension ExploreViewController: UICollectionViewDelegate {
    
}
//MARK: - CollectionView DataSource
extension ExploreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.category.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCategoryCell.cellID, for: indexPath) as! ExploreCategoryCell
        cell.setCategory(viewModel.category[indexPath.row])
        cell.action = { [weak self] in
            print("categoty cell tup")
        }
        return cell
    }
}

//MARK: - TableView Delegate and DataSource
extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.locationPlaces.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreTableViewCell.identifire, for: indexPath) as! ExploreTableViewCell
        cell.configure(with: viewModel.locationPlaces[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("=\(viewModel.locationPlaces[indexPath.row])=")
        locationLabel.text = viewModel.locationPlaces[indexPath.row]
        isLocationListVisible = true
        changeLocationListVisible()
    }
}
