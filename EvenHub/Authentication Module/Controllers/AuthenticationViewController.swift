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
        appLabel.attributedText = Constants.Fonts.attributedString(for: Constants.appName, font: Constants.Fonts.medium, fontSize: 35)
        return appLabel
    }()
    
    private let signInLabel: UILabel = {
        let signInLabel = UILabel()
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.attributedText = Constants.Fonts.attributedString(for: "Sign in", font: Constants.Fonts.medium, fontSize: 24)
        return signInLabel
    }()
    
    private let loginTextField: AuthenticationTextField = {
       let loginTextField = AuthenticationTextField()
        loginTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.loginPlaceholder, font: Constants.Fonts.book, fontSize: 14)
        loginTextField.updateLeftImage(image: Constants.Icons.Authentication.mail!)
        loginTextField.keyboardType = .emailAddress
        return loginTextField
    }()
    
    private let passwordTextField: AuthenticationSecureTextField = {
       let passwordTextField = AuthenticationSecureTextField()
        passwordTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.passwordPlaceholder, font: Constants.Fonts.book, fontSize: 14)
//        passwordTextField.updateLeftImage(image: Constants.Icons.Authentication.password!)
//        passwordTextField.isSecureTextEntry = true
//        passwordTextField.rightViewMode = .always
        return passwordTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        view.backgroundColor = Constants.Colors.PrimaryBlue.blue0
        view.addSubview(eventHubImage)
        NSLayoutConstraint.activate([
            eventHubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.bounds.width / 5),
            eventHubImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            eventHubImage.widthAnchor.constraint(equalToConstant: 56),
            eventHubImage.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        view.addSubview(appLabel)
        NSLayoutConstraint.activate([
            appLabel.centerXAnchor.constraint(equalTo: eventHubImage.centerXAnchor),
            appLabel.heightAnchor.constraint(equalToConstant: 48),
            appLabel.topAnchor.constraint(equalTo: eventHubImage.bottomAnchor)
        ])
        
        view.addSubview(signInLabel)
        NSLayoutConstraint.activate([
            signInLabel.topAnchor.constraint(equalTo: appLabel.bottomAnchor,constant: 29),
            signInLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 29),
            signInLabel.heightAnchor.constraint(equalToConstant: 29)
        ])
        
        view.addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: signInLabel.bottomAnchor,constant: 22),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            loginTextField.heightAnchor.constraint(equalToConstant: 56),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor,constant: 22),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
    }
}
