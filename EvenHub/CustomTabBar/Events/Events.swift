//
//  Events.swift
//  EventsApp
//
//  Created by Никита Грицунов on 10.09.2025.
//

import UIKit

class Events: UIViewController {
    
    //MARK: - Constants
    var segmentedPickerActions: [String] {["UPCOMING", "PAST EVENTS"]}
    
    //MARK: - UI
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Events"
        element.font = .systemFont(ofSize: 24, weight: .medium)
        element.textColor = Constants.Colors.TypographyColor.typographyColor50
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var picker: UISegmentedControl = {
        let element = UISegmentedControl(items: segmentedPickerActions)
    
//            element.setTitleTextAttributes([
//                .font: Constants.Fonts.book,
//                .foregroundColor: Constants.Colors.PrimaryBlue.blue50!
//            ], for: .selected)
//            
//            element.setTitleTextAttributes([
//                .font: Constants.Fonts.book,
//                .foregroundColor: Constants.Colors.TypographyColor.typographyColor30!
//            ], for: .disabled)
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var eventsCollectionView: UICollectionView = {
            let viewLayout = UICollectionViewFlowLayout()
            viewLayout.itemSize = CGSize(width: 327, height: 106)
            viewLayout.scrollDirection = .vertical
    
            let element = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
            element.showsVerticalScrollIndicator = false
            element.translatesAutoresizingMaskIntoConstraints = false
            return element
        }()
    
    
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setViews()
        setupConstraints()
    }
    
    
}





//MARK: - Setup constraints and set views

extension Events {
    private func setViews() {
        view.addSubview(titleLabel)
        view.addSubview(picker)
        view.addSubview(eventsCollectionView)
        
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            picker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 22.12),
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            eventsCollectionView.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 22.12),
            eventsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            eventsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            eventsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
