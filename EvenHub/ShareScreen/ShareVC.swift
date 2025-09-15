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
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "share_copy_link"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return $0
    }(UIButton())

    
    lazy var whatsAppBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "share_whatsApp"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return $0
    }(UIButton())
    
    lazy var facebookBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "share_facebook"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return $0
    }(UIButton())
    
    lazy var MessengerBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "share_messenger"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return $0
    }(UIButton())
    
    
    let copyLinkBtnText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Copy Link"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    
    let whatsAppBtnText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "WhatsApp"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    let facebookBtnText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Facebook"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    let MessengerBtnText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Messenger"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    
    lazy var telegramBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "share_messenger"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageView?.contentMode = .scaleAspectFit
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return $0
    }(UIButton())

    
    lazy var instagramBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "share_instagram"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return $0
    }(UIButton())
    
    lazy var maxBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "share_facebook"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return $0
    }(UIButton())
    
    lazy var messageBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 70).isActive = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .clear
        $0.setImage(UIImage(named: "share_message"), for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return $0
    }(UIButton())
    
    
    let telegramBtnText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Telegram"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    
    let instagramBtnText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Instagram"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    let maxBtnText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Max"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    
    let messageBtnText: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Message"
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        return $0
    }(UILabel())
    
    lazy var hStackOneIcons: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.backgroundColor = .clear
        
        $0.addArrangedSubview(copyLinkBtn)
        $0.addArrangedSubview(whatsAppBtn)
        $0.addArrangedSubview(facebookBtn)
        $0.addArrangedSubview(MessengerBtn)
        return $0
    }(UIStackView())
    
    lazy var hStackOneText: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.backgroundColor = .clear
        $0.addArrangedSubview(copyLinkBtnText)
        $0.addArrangedSubview(whatsAppBtnText)
        $0.addArrangedSubview(facebookBtnText)
        $0.addArrangedSubview(MessengerBtnText)
        return $0
    }(UIStackView())
    
    
    lazy var hStackTwoIcons: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.backgroundColor = .clear
        $0.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        $0.addArrangedSubview(telegramBtn)
        $0.addArrangedSubview(instagramBtn)
        $0.addArrangedSubview(maxBtn)
        $0.addArrangedSubview(messageBtn)
        return $0
    }(UIStackView())
    
    lazy var hStackTwoText: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalCentering
        $0.backgroundColor = .clear
        $0.addArrangedSubview(telegramBtnText)
        $0.addArrangedSubview(instagramBtnText)
        $0.addArrangedSubview(maxBtnText)
        $0.addArrangedSubview(messageBtnText)
        return $0
    }(UIStackView())
    
    
    lazy var cancelBtn: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 60).isActive = true
        $0.setTitle("CANCEL", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.color50, for: .normal)
        $0.backgroundColor = .color0
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(shareLbl)
        view.addSubview(hStackOneIcons)
        view.addSubview(hStackOneText)
        view.addSubview(hStackTwoIcons)
        view.addSubview(hStackTwoText)
        view.addSubview(cancelBtn)
        
        setupConstraints()
    }
    
    // MARK: - Setup
    
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            shareLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            shareLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            hStackOneIcons.topAnchor.constraint(equalTo: shareLbl.bottomAnchor, constant: 5),
            hStackOneIcons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hStackOneIcons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            
            hStackOneText.topAnchor.constraint(equalTo: hStackOneIcons.bottomAnchor, constant: 0),
            hStackOneText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hStackOneText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            
            hStackTwoIcons.topAnchor.constraint(equalTo: hStackOneText.bottomAnchor, constant: 0),
            hStackTwoIcons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hStackTwoIcons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            
            hStackTwoText.topAnchor.constraint(equalTo: hStackTwoIcons.bottomAnchor, constant: 0),
            hStackTwoText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            hStackTwoText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            
            cancelBtn.topAnchor.constraint(equalTo: hStackTwoText.bottomAnchor, constant: 40),
            cancelBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            cancelBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),

        ])
    }
}
