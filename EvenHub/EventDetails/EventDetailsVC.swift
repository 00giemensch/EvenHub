//
//  EventDetailsVC.swift
//  EvenHub
//
//  Created by Ilnur on 09.09.2025.
//

import UIKit

class EventDetailsVC: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        $0.addSubview(scrollContentView)
        $0.contentInsetAdjustmentBehavior = .never
        $0.alwaysBounceVertical = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        //$0.delegate = self
        return $0
    }(UIScrollView())
    
    lazy var scrollContentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addSubview(headerImg)
        $0.addSubview(titleLbl)
        return $0
    }(UIView())
    
    lazy var headerImg: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 244).isActive = true
        $0.backgroundColor = .white
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    lazy var titleLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "International Band Music Concert"
        $0.font = .systemFont(ofSize: 35, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .black
        return $0
    }(UILabel())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        view.addSubview(scrollView)
        setupConstr()
    }
    
    func setupConstr() {
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                headerImg.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
                headerImg.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
                headerImg.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
                
                titleLbl.topAnchor.constraint(equalTo: headerImg.bottomAnchor, constant: 50),
                titleLbl.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 24),
                titleLbl.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -24),
//                headerImg.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -115)
            ])
        }
    

}

extension EventDetailsVC: UIScrollViewDelegate {}
