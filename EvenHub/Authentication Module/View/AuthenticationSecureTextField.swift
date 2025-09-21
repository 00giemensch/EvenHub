import UIKit
import AuthenticationServices

class AuthenticationSecureTextField: AuthenticationTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let toggleButton: UIButton = {
        let toggleButton = UIButton()
        toggleButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        toggleButton.setImage(Constants.Icons.Authentication.passwordHidden, for: .normal)
        toggleButton.tintColor = Constants.Colors.TypographyColor.typographyColor10
        
        return toggleButton
    }()
    
    private func setup() {
        rightView = toggleButton
        rightViewMode = .always
        isSecureTextEntry = true
        updateLeftImage(image: Constants.Icons.Authentication.password!)
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        if !self.isFirstResponder { self.becomeFirstResponder() }
        isSecureTextEntry.toggle()
        sender.setImage(isSecureTextEntry ? Constants.Icons.Authentication.passwordHidden : Constants.Icons.Authentication.passwordNotHidden, for: .normal)
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
