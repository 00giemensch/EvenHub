import UIKit
import FirebaseAuth

class ResetPasswordMainViewController: UIViewController {
    
    //MARK: - UI Components
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.Icons.NavigationBar.backBlack, for: .normal)
        return button
    }()
    
    private let navLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = Constants.Fonts.attributedString(for: "Reset Password", font: Constants.Fonts.medium, fontSize: 24)
        return label
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = Constants.Fonts.attributedString(
            for: "Please enter your email address to request a password reset",
            font: Constants.Fonts.book,
            fontSize: 15
        )
        label.numberOfLines = 2
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let loginTextField: AuthenticationTextField = {
        let textField = AuthenticationTextField()
        textField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.loginPlaceholder, font: Constants.Fonts.book, fontSize: 14)
        textField.updateLeftImage(image: Constants.Icons.Authentication.mail!)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let sendButton: AuthenticationButton = {
        let button = AuthenticationButton(title: "SEND")
        return button
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = Constants.Colors.Background.white
        navigationItem.titleView = navLabel
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 63),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            headerLabel.heightAnchor.constraint(equalToConstant: 50),
            headerLabel.widthAnchor.constraint(equalToConstant: 244)
        ])
        
        view.addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 22),
            loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            loginTextField.heightAnchor.constraint(equalToConstant: 56),
            loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        view.addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52),
            sendButton.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 40),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -52),
            sendButton.heightAnchor.constraint(equalToConstant: 58)
        ])
        
        sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc private func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func sendButtonPressed(_ sender: UIButton) {
        guard let email = loginTextField.text, !email.isEmpty else { return }
        
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: email) { error in
            let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            if error == nil {
                // Successfull send
                alertController.title = "Success!"
                alertController.message = "If you entered an existing email address, check it for password reset instructions."
                
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Natigate to SignInVC
                    self.navigationController?.pushViewController(SignInViewController(), animated: true)
                }
                
                alertController.addAction(okAction)
                
            } else {
                // Error
                alertController.title = "Error"
                alertController.message = error?.localizedDescription
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
            }
            
            self.present(alertController, animated: true)
        }
    }
}
