//
//  AutenticationViewController.swift
//  EvenHub
//
//  Created by Aliaksandr Zuyeu on 8.09.25.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    var account: AuthenticationModel?
    
    //MARK: - UI Components
    private let eventHubImage: UIImageView = {
        let eventHubImage = UIImageView()
        eventHubImage.translatesAutoresizingMaskIntoConstraints = false
        eventHubImage.image = Constants.Icons.Authentication.eventHub
        return eventHubImage
    }()
    
    private let appLabel: UILabel = {
        let appLabel = UILabel()
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        appLabel.font = UIFont(name: Constants.Fonts.bold, size: 50)
        appLabel.text = Constants.appName
//        appLabel.attributedText = Constants.Fonts.attributedString(for: Constants.appName, font: Constants.Fonts.bold, fontSize: 50, lineHeigh: 72)
        return appLabel
    }()
    
    private let loginTextField: AuthenticationTextField = {
       let loginTextField = AuthenticationTextField()
        loginTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.passwordPlaceholder, font: Constants.Fonts.book, fontSize: 14, lineHeigh: 23)
        loginTextField.updateImage(image: Constants.Icons.Authentication.mail!)
        return loginTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = Constants.Colors.PrimaryBlue.blue0
        view.addSubview(eventHubImage)
        NSLayoutConstraint.activate([
            eventHubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -77),
            eventHubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -296),
            eventHubImage.widthAnchor.constraint(equalToConstant: 56),
            eventHubImage.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        view.addSubview(appLabel)
        NSLayoutConstraint.activate([
            appLabel.centerXAnchor.constraint(equalTo: eventHubImage.centerXAnchor),
            appLabel.centerYAnchor.constraint(equalTo: eventHubImage.centerYAnchor, constant: 61),
            appLabel.widthAnchor.constraint(equalToConstant: 150),
            appLabel.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
