import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private var authService = AuthService.shared
    var onSignIn: (() -> Void)?
    var onMain: (() -> Void)?
    
    //MARK: - UI Components
    //Navigation Bar Items
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(Constants.Icons.NavigationBar.backBlack, for: .normal)
        return backButton
    }()
    
    private let navLabel: UILabel = {
        let navLabel = UILabel()
        navLabel.translatesAutoresizingMaskIntoConstraints = false
        navLabel.attributedText = Constants.Fonts.attributedString(for: "Sign up", font: Constants.Fonts.medium, fontSize: 24)
        return navLabel
    }()
    
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
        passwordTextField.textContentType = .oneTimeCode
        return passwordTextField
    }()
    
    private let confirmPasswordTextField: AuthenticationSecureTextField = {
        let confirmPasswordTextField = AuthenticationSecureTextField()
        confirmPasswordTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.passwordConfirmationPlaceholder, font: Constants.Fonts.book, fontSize: 14)
        confirmPasswordTextField.textContentType = .oneTimeCode
        return confirmPasswordTextField
    }()
    
    private let signUpButton: AuthenticationButton = {
        let signUpButton = AuthenticationButton(title: "SIGN UP")
        signUpButton.alpha = 0.5
        signUpButton.isEnabled = false
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
        passwordTextField.delegate = self
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Methods
    func setupUI() {
        view.backgroundColor = Constants.Colors.Background.white
        navigationItem.titleView = navLabel
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
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
        loginWithGoogleButton.addTarget(self, action: #selector(loginWithGooglePressed), for: .touchUpInside)

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
    
    // MARK: - Validation
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            guard let newPass = passwordTextField.text, !newPass.isEmpty else { return }
            
            let passwordErrors = PasswordRules.validate(newPass)
            if !passwordErrors.isEmpty {
                passwordTextField.layer.borderColor = Constants.Colors.Accent.red?.cgColor
                passwordTextField.layer.borderWidth = 1
                signUpButton.isEnabled = false
                signUpButton.alpha = 0.5
                showErrorAlert(title: "Invalid Password", message: passwordErrors.joined(separator: "\n"))
            } else {
                passwordTextField.layer.borderColor = Constants.Colors.Accent.green?.cgColor
                passwordTextField.layer.borderWidth = 1
            }
        }
    }
    
    @objc private func confirmPasswordDidChange() {
        guard
            let newPass = passwordTextField.text, !newPass.isEmpty,
            let confirmPass = confirmPasswordTextField.text, !confirmPass.isEmpty
        else {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
            return
        }
        
        if newPass == confirmPass {
            confirmPasswordTextField.layer.borderColor = Constants.Colors.Accent.green?.cgColor
            confirmPasswordTextField.layer.borderWidth = 1
            signUpButton.isEnabled = true
            signUpButton.alpha = 1.0
        } else {
            confirmPasswordTextField.layer.borderColor = Constants.Colors.Accent.red?.cgColor
            confirmPasswordTextField.layer.borderWidth = 1
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.5
        }
    }
    
    //MARK: - Actions
    @objc private func backButtonPressed(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
        onSignIn?()
    }
    
    @objc private func signUpButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.01, animations: {
            sender.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.01) {
                sender.alpha = 1.0
            }
        }
        guard let email = loginTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                print("Sign up is successful")
                self.showErrorAlert(title: "Congratulations!", message: "Sign up is successful")
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Переход на SignInVC
//                    self.navigationController?.pushViewController(ResetPasswordSecondViewController(), animated: true)
                    self.onMain?()
                }
            }
            else {
                self.showErrorAlert(title: "Error", message: error?.localizedDescription)
            }
        }
    }
    
    @objc private func loginWithGooglePressed() {
        authService.signInWithGoogle(presentingViewController: self) { [weak self] result in
            switch result {
            case .success(let user):
                print("Enter: \(user.email ?? "unknown")")
                //                    let exploreVC = ExploreViewController()
                //                    self?.navigationController?.pushViewController(exploreVC, animated: true)
            case .failure(let error):
                self?.showErrorAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    private func showErrorAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func signInPressed(_ sender: UIButton) {
//        navigationController?.pushViewController(SignInViewController(), animated: true)
        onSignIn?()
    }
}
