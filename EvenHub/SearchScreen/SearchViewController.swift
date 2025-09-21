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
    
    //MARK: - UI Components
    private lazy var searchTextField = SearchTextField(scheme: .blue)
    private lazy var loader = UIActivityIndicatorView(style: .large)
    private lazy var searchCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = .init(width: view.frame.width, height: view.frame.height / 8)
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        viewModel.searchedEventsLoaded = { [weak self] in
            self?.hideLoader()
            DispatchQueue.main.async {
                self?.searchCollectionView.reloadData()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.clearSavedEvents()
        DispatchQueue.main.async {
            self.searchCollectionView.reloadData()
        }
    }
    
    //MARK: - Methods
    private func searchEvents(with text: String) {
        Task {
            await viewModel.searchEvent(with: text)
        }
    }
    private func showLoader() {
        DispatchQueue.main.async {
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
    //MARK: - Setup Layout
    private func setupLayout() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchTextField()
        setupSearchCollectionView()
        setupLoaderView()
    }
    private func setupNavigationBar() {
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: Constants.Fonts.medium, size: 24) ?? .systemFont(ofSize: 24)]
        navigationItem.title = "Search"
        let backImage = UIImage(systemName: "arrow.backward")
        
        let backButtonItem = UIBarButtonItem(image: backImage,
                                             style: .plain,
                                             target: navigationController,
                                             action: #selector(navigationController?.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    private func setupSearchTextField() {
        view.addSubview(searchTextField)
        searchTextField.delegate = self
        searchTextField.action = { [weak self] in
            print("filter button tup")
            self?.viewModel.checkStorage()
        }
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
        searchCollectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.cellID)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 28),
            searchCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.cellID, for: indexPath) as! FavoriteCell
        return cell
    }
}
//MARK: - TextField Delegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text else {
            textField.resignFirstResponder()
            return false
        }
        searchEvents(with: query)
        textField.resignFirstResponder()
        return true
    }
}
