import UIKit
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage

class ResetPasswordMainViewController: UIViewController {
    
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.attributedText = Constants.Fonts.attributedString(
            for: "Please enter your email address to request a password reset",
            font: Constants.Fonts.book,
            fontSize: 15)
        headerLabel.numberOfLines = 2
        headerLabel.textAlignment = .left
        headerLabel.lineBreakMode = .byWordWrapping
        return headerLabel
    }()
    
    private let loginTextField: AuthenticationTextField = {
        let loginTextField = AuthenticationTextField()
        loginTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: Constants.loginPlaceholder, font: Constants.Fonts.book, fontSize: 14)
        loginTextField.updateLeftImage(image: Constants.Icons.Authentication.mail!)
        loginTextField.keyboardType = .emailAddress
        return loginTextField
    }()
    
    private let sendButton: AuthenticationButton = {
        let sendButton = AuthenticationButton(title: "SEND")
        return sendButton
    }()
    //MARK: VC LC
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Methods
    private func setupUI() {
        title = "Reset Password"
        view.backgroundColor = Constants.Colors.Background.white
        
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 63),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            headerLabel.heightAnchor.constraint(equalToConstant: 50),
            headerLabel.widthAnchor.constraint(equalToConstant: 244)
        ])
        
        view.addSubview(loginTextField)
        NSLayoutConstraint.activate([
            loginTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor,constant: 22),
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
    
    @objc private func sendButtonPressed(_ sender: UIButton) {
        //Validation + Navigation
        
        let auth = Auth.auth()
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        guard let email = loginTextField.text else { return }
        auth.sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                //TODO: Navigation to Explore VC
                alertController.title = "Success!"
                alertController.message = "Check email for password reset instructions."
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                alertController.title = "Error"
                alertController.message = error?.localizedDescription
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
