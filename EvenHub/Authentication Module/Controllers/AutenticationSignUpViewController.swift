//
//  AutenticationSignUpViewController.swift
//  EvenHub
//
//  Created by Aliaksandr Zuyeu on 14.09.25.
//

import UIKit

class AutenticationSignUpViewController: UIViewController {
    
    //MARK: - UI Components
    
    private let profileTextField: AuthenticationTextField = {
       let profileTextField = AuthenticationTextField()
        profileTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: "Full name", font: Constants.Fonts.book, fontSize: 14)
        profileTextField.updateLeftImage(image: Constants.Icons.Authentication.profile!)
        return profileTextField
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
    
    private let confirmPasswordTextField: AuthenticationSecureTextField = {
       let confirmPasswordTextField = AuthenticationSecureTextField()
        confirmPasswordTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.passwordConfirmationPlaceholder, font: Constants.Fonts.book, fontSize: 14)
        return confirmPasswordTextField
    }()
    
    private let recoverPasswordButton: UIButton = {
        let recoverPasswordButton = UIButton()
        recoverPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        recoverPasswordButton.setAttributedTitle(Constants.Fonts.attributedString(for: "Forgot Password?", font: Constants.Fonts.book, fontSize: 14), for: .normal)
        return recoverPasswordButton
    }()
    
    private let signUpButton: AuthenticationButton = {
        let signUpButton = AuthenticationButton(title: "SIGN UP")
        return signUpButton
    }()
    
    private let orLabel: UILabel = {
        let orLabel = UILabel()
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.attributedText = Constants.Fonts.attributedString(
            for: "OR",
            font: Constants.Fonts.medium,
            fontSize: 16)
        orLabel.textColor = Constants.Colors.TypographyColor.typographyColor30
        return orLabel
    }()
    
    private let loginWithGoogleButton: AuthenticationGoogleLogin = {
        let loginWithGoogleButton = AuthenticationGoogleLogin()
        loginWithGoogleButton.translatesAutoresizingMaskIntoConstraints = false
        return loginWithGoogleButton
    }()
    
    private let signInLabel: UILabel = {
        let signInLabel = UILabel()
        signInLabel.translatesAutoresizingMaskIntoConstraints = false
        signInLabel.attributedText = Constants.Fonts.attributedString(
            for: "Already have an account?",
            font: Constants.Fonts.book,
            fontSize: 16)
        signInLabel.textColor = Constants.Colors.TypographyColor.typographyColor50
        return signInLabel
    }()
    
    private let signInButton: UIButton = {
        let signInButton = UIButton()
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setAttributedTitle(Constants.Fonts.attributedString(for: "Sign in", font: Constants.Fonts.book, fontSize: 16), for: .normal)
        signInButton.setTitleColor(Constants.Colors.PrimaryBlue.blue50, for: .normal)
        return signInButton
    }()
    
    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    //MARK: - Methods
    func setupUI() {
        
        view.backgroundColor = Constants.Colors.Background.white
        
        view.addSubview(profileTextField)
        NSLayoutConstraint.activate([
            profileTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 71),
            profileTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            profileTextField.heightAnchor.constraint(equalToConstant: 56),
            profileTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        view.addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: profileTextField.bottomAnchor,constant: 22),
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
        
        view.addSubview(confirmPasswordTextField)
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 22),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 56),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52),
            signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 38),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -52),
            signUpButton.heightAnchor.constraint(equalToConstant: 58)
        ])
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        
        view.addSubview(orLabel)
        NSLayoutConstraint.activate([
            orLabel.centerXAnchor.constraint(equalTo: signUpButton.centerXAnchor),
            orLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 30),
            orLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        view.addSubview(loginWithGoogleButton)
        NSLayoutConstraint.activate([
            loginWithGoogleButton.centerXAnchor.constraint(equalTo: signUpButton.centerXAnchor),
            loginWithGoogleButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 30),
            loginWithGoogleButton.heightAnchor.constraint(equalToConstant: 58),
            loginWithGoogleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52),
            loginWithGoogleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -52)
        ])
        
        view.addSubview(signInLabel)
        NSLayoutConstraint.activate([
            signInLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            signInLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            signInLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: signInLabel.centerYAnchor),
            signInButton.leadingAnchor.constraint(equalTo: signInLabel.trailingAnchor, constant: 5),
            signInButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        
    }
    
    @objc private func signUpButtonPressed(_ sender: UIButton) {
        // Animation for tap on button
        UIView.animate(withDuration: 0.01, animations: {
            sender.alpha = 0.5
                }) { _ in
                    UIView.animate(withDuration: 0.01) {
                        sender.alpha = 1.0
                    }
                }
        // Navigation to Sign In VC
    }
    
    @objc private func loginWithGooglePressed(_ sender: UIButton) {
        
    }
    
    @objc private func signInPressed(_ sender: UIButton) {
        //Navigation to SignIn VC
        navigationController?.pushViewController(AuthenticationSignInViewController(), animated: true)
    }
}
