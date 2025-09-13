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
        return passwordTextField
    }()
    
    private let rememberMeSwitch: UISwitch = {
        let rememberMeSwitch = UISwitch()
        rememberMeSwitch.translatesAutoresizingMaskIntoConstraints = false
        rememberMeSwitch.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        rememberMeSwitch.isOn = false
        rememberMeSwitch.preferredStyle = .sliding
        rememberMeSwitch.onTintColor = Constants.Colors.PrimaryBlue.blue40
        return rememberMeSwitch
    }()
    
    private let rememberMeLabel: UILabel = {
        let rememberMeLabel = UILabel()
        rememberMeLabel.translatesAutoresizingMaskIntoConstraints = false
        rememberMeLabel.attributedText = Constants.Fonts.attributedString(for: "Remember Me", font: Constants.Fonts.book, fontSize: 14)
        rememberMeLabel.textColor = Constants.Colors.TypographyColor.typographyColor50
        return rememberMeLabel
    }()
    
    private let recoverPasswordButton: UIButton = {
        let recoverPasswordButton = UIButton()
        recoverPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        recoverPasswordButton.setAttributedTitle(Constants.Fonts.attributedString(for: "Forgot Password?", font: Constants.Fonts.book, fontSize: 14), for: .normal)
        return recoverPasswordButton
    }()
    
    private let signInButton: AuthenticationButton = {
        let signInButton = AuthenticationButton(config: .init(title: "SIGN IN", spacing: 14))
        return signInButton
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
        
        view.addSubview(rememberMeSwitch)
        NSLayoutConstraint.activate([
            rememberMeSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            rememberMeSwitch.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22)
        ])
        
        view.addSubview(rememberMeLabel)
        NSLayoutConstraint.activate([
            rememberMeLabel.leadingAnchor.constraint(equalTo: rememberMeSwitch.trailingAnchor, constant: 25),
            rememberMeLabel.centerYAnchor.constraint(equalTo: rememberMeSwitch.centerYAnchor),
            rememberMeLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        view.addSubview(recoverPasswordButton)
        NSLayoutConstraint.activate([
            recoverPasswordButton.centerYAnchor.constraint(equalTo: rememberMeSwitch.centerYAnchor),
            recoverPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29),
            recoverPasswordButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 73),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -52),
            signInButton.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
}
