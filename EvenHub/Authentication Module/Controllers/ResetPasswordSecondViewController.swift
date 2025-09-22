import UIKit
import FirebaseAuth

class ResetPasswordSecondViewController: UIViewController, UITextFieldDelegate {
    
    var oobCode: String?
    var onSignIn: (() -> Void)?
    var onResetPassword: (() -> Void)?
    
    // MARK: - UI Components
    private let backButton: UIButton = {
        let backButton = UIButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setImage(Constants.Icons.NavigationBar.backBlack, for: .normal)
        return backButton
    }()
    
    private let navLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = Constants.Fonts.attributedString(for: "Reset Password", font: Constants.Fonts.medium, fontSize: 24)
        return label
    }()
    
    private let passwordTextField: AuthenticationSecureTextField = {
        let tf = AuthenticationSecureTextField()
        tf.attributedPlaceholder = Constants.Fonts.attributedString(for: "New password", font: Constants.Fonts.book, fontSize: 14)
        return tf
    }()
    
    private let confirmPasswordTextField: AuthenticationSecureTextField = {
        let tf = AuthenticationSecureTextField()
        tf.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.passwordConfirmationPlaceholder, font: Constants.Fonts.book, fontSize: 14)
        return tf
    }()
    
    private let codeTextField: AuthenticationSecureTextField = {
        let codeTextField = AuthenticationSecureTextField()
        codeTextField.placeholder = "oobCode"
        return codeTextField
    }()
    
    private let changePasswordButton: AuthenticationButton = {
        let btn = AuthenticationButton(title: "CHANGE \nPASSWORD")
        btn.alpha = 0.5
        btn.isEnabled = false
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
        
        if oobCode != nil {
            codeTextField.isHidden = true
        }
        passwordTextField.delegate = self
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = Constants.Colors.Background.white
        navigationItem.titleView = navLabel
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 75),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(confirmPasswordTextField)
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 22),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(codeTextField)
        NSLayoutConstraint.activate([
            codeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            codeTextField.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 22),
            codeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            codeTextField.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        view.addSubview(changePasswordButton)
        NSLayoutConstraint.activate([
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52),
            changePasswordButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 38),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -52),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 58)
        ])
        changePasswordButton.addTarget(self, action: #selector(changePasswordPressed), for: .touchUpInside)
    }
    
    // MARK: - Validation
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == passwordTextField {
            guard let newPass = passwordTextField.text, !newPass.isEmpty else { return }
            
            let passwordErrors = PasswordRules.validate(newPass)
            if !passwordErrors.isEmpty {
                passwordTextField.layer.borderColor = Constants.Colors.Accent.red?.cgColor
                passwordTextField.layer.borderWidth = 1
                changePasswordButton.isEnabled = false
                changePasswordButton.alpha = 0.5
                showAlert("Invalid Password", passwordErrors.joined(separator: "\n"))
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
            changePasswordButton.isEnabled = false
            changePasswordButton.alpha = 0.5
            return
        }
        
        if newPass == confirmPass, codeTextField.text != nil {
            confirmPasswordTextField.layer.borderColor = Constants.Colors.Accent.green?.cgColor
            confirmPasswordTextField.layer.borderWidth = 1
            changePasswordButton.isEnabled = true
            changePasswordButton.alpha = 1.0
        } else {
            confirmPasswordTextField.layer.borderColor = Constants.Colors.Accent.red?.cgColor
            confirmPasswordTextField.layer.borderWidth = 1
            changePasswordButton.isEnabled = false
            changePasswordButton.alpha = 0.5
        }
    }
    
    // MARK: - Actions
    @objc private func changePasswordPressed(_ sender: UIButton) {
        guard let newPass = passwordTextField.text else { return }
        
        let codeToUse = oobCode ?? codeTextField.text
        guard let code = codeToUse, !code.isEmpty else { return }
        Auth.auth().confirmPasswordReset(withCode: code, newPassword: newPass) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert("Error", error.localizedDescription)
            } else {
                //TODO: Если currentuser = nil, то переходим на SignIn, если нет - то возвращаемся на последний экран
                let alert = UIAlertController(title: "Done!", message: "Password was successfully changed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    let loginVC = SignInViewController()
                    if let nav = self.navigationController {
                        nav.setViewControllers([loginVC], animated: true)
                    } else {
                        self.present(loginVC, animated: true)
                    }
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    @objc private func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
