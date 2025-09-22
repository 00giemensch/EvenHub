//
//  SearchViewController.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 20.09.2025.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Properties
    private lazy var viewModel = SearchViewModel.shared
    private lazy var isCategoryListVisible = false
    private lazy var tapOutsideGesture = UITapGestureRecognizer()
    var pushNewVC: ((UIViewController) -> Void)?
    
    //MARK: - UI Components
    private lazy var searchTextField = SearchTextField(scheme: .blue)
    private lazy var loader = UIActivityIndicatorView(style: .large)
    private lazy var noResultLabel = UILabel()
    private lazy var categoryList = UITableView()
    private lazy var categoryListHeightConstraint = NSLayoutConstraint()
    private lazy var searchCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: view.frame.width - 32 , height: view.frame.height / 8)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        viewModel.searchedEventsLoaded = { [weak self] in
            self?.hideLoader()
            self?.searchTextField.action = { [weak self] in
                print("filter button tup")
                self?.changeCategoryListVisible()
            }
            DispatchQueue.main.async {
                self?.categoryList.reloadData()
                self?.searchCollectionView.reloadData()
                if let result = self?.viewModel.filtredEvents {
                    self?.noResultLabel.isHidden = !result.isEmpty
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchTextField.becomeFirstResponder()
    }
    
    //MARK: - Methods
    private func searchEvents(with text: String) {
        Task {
            await viewModel.searchEvent(with: text)
        }
    }
    private func showLoader() {
        DispatchQueue.main.async {
            self.noResultLabel.isHidden = true
            self.loader.startAnimating()
            self.loader.isHidden = false
        }
    }
    private func hideLoader() {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.loader.stopAnimating()
            
        }
    }
    @objc private func backButtonTapped() {
        viewModel.clearSavedEvents()
        DispatchQueue.main.async {
            self.searchCollectionView.reloadData()
        }
        navigationController?.popViewController(animated: true)
    }
    private func setupTapGesture() {
        tapOutsideGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        tapOutsideGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapOutsideGesture)
    }
    
    private func changeCategoryListVisible() {
        guard viewModel.categories.count > 0 else { return }
        isCategoryListVisible.toggle()
        if !isCategoryListVisible {
            categoryList.isHidden = true
            categoryListHeightConstraint.constant = 0
        } else {
            UIView.animate(withDuration: 0.3) {
                self.categoryList.isHidden = false
                let categoriesCount = self.viewModel.categories.count
                let offset = categoriesCount * 38 < 300  ? CGFloat(categoriesCount * 38) : 300
                self.categoryListHeightConstraint.constant += offset
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        guard isCategoryListVisible,
              !categoryList.frame.contains(location) else { return }
        changeCategoryListVisible()
    }
    private func filterListByCategory(_ category: String) {
        viewModel.filterByCategory(category: category)
        DispatchQueue.main.async {
            self.searchCollectionView.reloadData()
        }
    }
    private func removeFilter() {
        viewModel.removeFilterCategory()
        DispatchQueue.main.async {
            self.searchCollectionView.reloadData()
        }
    }
    //MARK: - Setup Layout
    private func setupLayout() {
        view.backgroundColor = Constants.Colors.Background.exploreBackground
        setupNavigationBar()
        setupSearchTextField()
        setupSearchCollectionView()
        setupNoResultLabel()
        setupLoaderView()
        setupCategoryList()
        setupTapGesture() 
    }
    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: Constants.Fonts.medium, size: 24) ?? .systemFont(ofSize: 24)]
        navigationItem.title = "Search"
        let backImage = UIImage(systemName: "arrow.backward")
        
        let backButtonItem = UIBarButtonItem(image: backImage,
                                             style: .plain,
                                             target: self,
                                             action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    private func setupSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 0.14),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func setupSearchCollectionView() {
        view.addSubview(searchCollectionView)
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.cellId)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.backgroundColor = .clear
        searchCollectionView.showsVerticalScrollIndicator = false
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 28),
            searchCollectionView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            searchCollectionView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    private func setupNoResultLabel() {
        view.addSubview(noResultLabel)
        let text = Constants.Fonts.attributedString(for: "NO RESULTS", font: Constants.Fonts.bold, fontSize: 24)
        noResultLabel.attributedText = text
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    private func setupCategoryList() {
        view.addSubview(categoryList)
        categoryList.delegate = self
        categoryList.dataSource = self
        categoryList.isHidden = true
        categoryList.separatorStyle = .none
        categoryList.layer.cornerRadius = 8
        categoryList.showsVerticalScrollIndicator = false
        categoryList.backgroundColor = UIColor(resource: .blue50)
        categoryList.register(ExploreTableViewCell.self, forCellReuseIdentifier: ExploreTableViewCell.identifire)
        categoryList.translatesAutoresizingMaskIntoConstraints = false
        categoryListHeightConstraint = categoryList.bottomAnchor.constraint(equalTo: searchTextField.bottomAnchor)
        categoryListHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            categoryList.topAnchor.constraint(equalTo: searchTextField.topAnchor, constant: -1),
            categoryList.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            categoryList.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            categoryListHeightConstraint
        ])
    }
    private func setupLoaderView() {
        view.addSubview(loader)
        loader.isHidden = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: - CollectionView Delegate and DataSource
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.filtredEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.cellId, for: indexPath) as! SearchCollectionViewCell
        
        let event = viewModel.filtredEvents[indexPath.row]
        cell.configure(with: event)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let newVC = EventDetailsVC()
        let selectedEvent = viewModel.filtredEvents[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else { return }
        let image = cell.getImage()
        newVC.event = selectedEvent
        newVC.image = image
        newVC.configureWithEvent(event: selectedEvent)
        pushNewVC?(newVC)
    }
}
//MARK: - TextField Delegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else {
            textField.resignFirstResponder()
            return false
        }
        showLoader()
        searchEvents(with: query)
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - TableView Delegate and DataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreTableViewCell.identifire, for: indexPath) as! ExploreTableViewCell
        if indexPath.row == 0 {
            cell.configure(with: "All")
        } else {
            cell.configure(with: viewModel.categories[indexPath.row-1])
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            removeFilter()
        } else {
            let category = viewModel.categories[indexPath.row-1]
            filterListByCategory(category)
        }
        
        isCategoryListVisible = true
        changeCategoryListVisible()
    }
}
