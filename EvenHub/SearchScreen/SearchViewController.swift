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
    private lazy var noResultLabel = UILabel()
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
            DispatchQueue.main.async {
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
    
    //MARK: - Setup Layout
    private func setupLayout() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupSearchTextField()
        setupSearchCollectionView()
        setupNoResultLabel()
        setupLoaderView()
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
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.cellId)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
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
