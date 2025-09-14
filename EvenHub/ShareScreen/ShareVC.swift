//
//  ShareVC.swift
//  EvenHub
//
//  Created by Ilnur on 13.09.2025.
//

import UIKit

class ShareVC: UIViewController {
    
    
    
    // MARK: - UI
    
    let shareLbl: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Share with friends"
        $0.font = .systemFont(ofSize: 24, weight: .medium)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    lazy var linksView: UIView = {
        return $0
    }(UIView())
    
    lazy var copyLinkBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 60).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor(red: 0.3437, green: 0.3569, blue: 0.3903, alpha: 1)
        $0.setImage(UIImage(named: "share_copy_link"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageView?.contentMode = .scaleAspectFit  // Важно: устанавливаем contentMode для imageView, а не UIButton
        return $0
    }(UIButton())

    
    lazy var whatsAppBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 60).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = #colorLiteral(red: 0.3437280655, green: 0.3569303751, blue: 0.3902622461, alpha: 1)
        $0.setImage(UIImage(named: "share_whatsApp"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIButton())
    
    lazy var facebookBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 60).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = #colorLiteral(red: 0.3437280655, green: 0.3569303751, blue: 0.3902622461, alpha: 1)
        $0.setImage(UIImage(named: "share_message"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        return $0
    }(UIButton())
    
    lazy var MessengerBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 60).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = #colorLiteral(red: 0.3437280655, green: 0.3569303751, blue: 0.3902622461, alpha: 1)
        $0.setImage(UIImage(named: "share_messenger"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return $0
    }(UIButton())
    
    lazy var vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.backgroundColor = .gray
        $0.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        $0.addArrangedSubview(copyLinkBtn)
        $0.addArrangedSubview(whatsAppBtn)
        $0.addArrangedSubview(facebookBtn)
        $0.addArrangedSubview(MessengerBtn)
        return $0
    }(UIStackView())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue20
        view.addSubview(shareLbl)
        view.addSubview(vStack)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            shareLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            shareLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            vStack.topAnchor.constraint(equalTo: shareLbl.bottomAnchor, constant: 24),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),

        ])
    }
}
