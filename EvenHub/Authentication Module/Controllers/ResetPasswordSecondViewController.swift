import UIKit
import AuthenticationServices
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class ResetPasswordSecondViewController: UIViewController {
    
    private let passwordTextField: AuthenticationSecureTextField = {
        let passwordTextField = AuthenticationSecureTextField()
        passwordTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.passwordPlaceholder, font: Constants.Fonts.book, fontSize: 14)
        passwordTextField.passwordRules = UITextInputPasswordRules(descriptor: "required: upper, lower, digit, special; minlength: 8;")
        return passwordTextField
    }()
    
    private let confirmPasswordTextField: AuthenticationSecureTextField = {
        let confirmPasswordTextField = AuthenticationSecureTextField()
        confirmPasswordTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.passwordConfirmationPlaceholder, font: Constants.Fonts.book, fontSize: 14)
        return confirmPasswordTextField
    }()
    
    private let changePasswordButton: AuthenticationButton = {
        let changePasswordButton = AuthenticationButton(title: "CHANGE \nPASSWORD")
        changePasswordButton.alpha = 0.5
        changePasswordButton.isEnabled = false
        return changePasswordButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    private func setupUI() {
        
        view.backgroundColor = Constants.Colors.Background.white
        
        //MARK: Navigation Bar Items
        title = "Reset Password"
        

        
        //MARK: Adding UIElements
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 75),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        passwordTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        
        view.addSubview(confirmPasswordTextField)
        NSLayoutConstraint.activate([
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor,constant: 22),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 56),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        
        view.addSubview(changePasswordButton)
        NSLayoutConstraint.activate([
            changePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52),
            changePasswordButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 38),
            changePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -52),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 58)
        ])
        changePasswordButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func textFieldsDidChange() {
        validatePasswords()
    }
    
    private func validatePasswords() {
        
        // Password validation
        guard let newPass = passwordTextField.text, !newPass.isEmpty else {
            changePasswordButton.isEnabled = false
            changePasswordButton.alpha = 0.5
            passwordTextField.layer.borderColor = Constants.Colors.TypographyColor.typographyColor10?.cgColor
            return
        }
        
        let errors = PasswordRules.validate(newPass)
        
        if errors.isEmpty {
            passwordTextField.layer.borderColor = (Constants.Colors.Accent.green)?.cgColor
            passwordTextField.layer.borderWidth = 1
        } else {
            passwordTextField.layer.borderColor = (Constants.Colors.Accent.red)?.cgColor
            passwordTextField.layer.borderWidth = 1
            changePasswordButton.isEnabled = false
        }
        
        // Confirm Password Validation
        guard let confirmPass = confirmPasswordTextField.text, !confirmPass.isEmpty, errors.isEmpty
        else {
            changePasswordButton.isEnabled = false
            changePasswordButton.alpha = 0.5
            confirmPasswordTextField.layer.borderColor = Constants.Colors.TypographyColor.typographyColor10?.cgColor
            return
        }
        
        if newPass == confirmPass {
            confirmPasswordTextField.layer.borderColor = (Constants.Colors.Accent.green)?.cgColor
            confirmPasswordTextField.layer.borderWidth = 1
            changePasswordButton.alpha = 1
            changePasswordButton.isEnabled = true
        } else {
            confirmPasswordTextField.layer.borderColor = (Constants.Colors.Accent.red)?.cgColor
            confirmPasswordTextField.layer.borderWidth = 1
            changePasswordButton.alpha = 0.5
            changePasswordButton.isEnabled = false
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        navigationController?.pushViewController(SignInViewController(), animated: true)
    }
}
