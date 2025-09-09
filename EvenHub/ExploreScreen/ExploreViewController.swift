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
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGray5
        createBezier(on: view, withColor: .systemBlue)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //MARK: - Methods
    
    //MARK: - Setup UI
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
}

