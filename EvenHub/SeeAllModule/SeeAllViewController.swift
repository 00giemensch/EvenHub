//
//  SeeAllViewController.swift
//  EvenHub
//
//  Created by Евгений Васильев on 17.09.2025.
//
import UIKit

class SeeAllViewController : UIViewController {
  
    enum Constants {
        
    }
    
    //MARK: - Create UI
    
    let eventsLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .center
        label.text = "Events"
        label.numberOfLines = 0
        return label
    }()
    
    let backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: SeeAllModel.Constants.backButtonIcon), for: .normal)
        return button
    }()
    
    let searchButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: SeeAllModel.Constants.searchIcon), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let seeAllCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isHidden = false
        return view
    }()
    
    // Добавь в AppDelegate или ViewController
    func quickTest() {
        let testEvent = EventDTO(
            id: 999,
            title: "ТЕСТ",
            images: [ImageDTO(image: "test.jpg")],
            description: "test",
            bodyText: "test",
            favoritesCount: 0,
            dates: [EventDate(start: 1, end: 2, startDate: "test", startTime: "test", endTime: "test")],
            place: nil,
            location: nil,
            participants: nil
        )
        
        CoreDataManager.shared.cacheEvents([testEvent])
        
        let events = CoreDataManager.shared.getCachedEvents()
        print("✅ Тест завершен! Событий: \(events.count)")
        
        for event in events {
            print("📍 \(event.title ?? "") - \(event.id ?? "")")
        }
    }


    
    //MARK: - SetDelegates
    
    func setDelegates() {
        seeAllCollectionView.delegate = self
        seeAllCollectionView.dataSource = self
        seeAllCollectionView.register(SeeAllCell.self, forCellWithReuseIdentifier: "SeeAllCell")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
        quickTest()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(eventsLabel)
        view.addSubview(searchButton)
        view.addSubview(seeAllCollectionView)
        view.addSubview(backButton)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        eventsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            eventsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 57)
        ])
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        seeAllCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            seeAllCollectionView.topAnchor.constraint(equalTo: eventsLabel.bottomAnchor, constant: 24),
            seeAllCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            seeAllCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            seeAllCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            seeAllCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: eventsLabel.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 22),
            backButton.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}

//MARK: - Extension CollectionView

extension SeeAllViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeeAllCell", for: indexPath) as! SeeAllCell
        return cell
    }
    
}

