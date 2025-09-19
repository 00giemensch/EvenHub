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
        textContentType = .none
        updateLeftImage(image: Constants.Icons.Authentication.password!)
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }
    
    //FIXME: Если я нахожусь в этом же поле и нажимаю на кнопку - клавиатура "прыгает"
//    @objc func togglePasswordVisibility(_ sender: UIButton) {
//        let wasFirstResponder = isFirstResponder
//        isSecureTextEntry.toggle()
//        sender.setImage(isSecureTextEntry ? Constants.Icons.Authentication.passwordHidden : Constants.Icons.Authentication.passwordNotHidden, for: .normal)
//        
//        if wasFirstResponder {
//            becomeFirstResponder()
//            if let existingSelectedTextRange = selectedTextRange {
//                selectedTextRange = nil
//                selectedTextRange = existingSelectedTextRange
//            }
//        }
//    }
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        if !self.isFirstResponder { self.becomeFirstResponder() }
        sender.setImage(isSecureTextEntry ? Constants.Icons.Authentication.passwordHidden : Constants.Icons.Authentication.passwordNotHidden, for: .normal)
        if let existingSelectedTextRange = selectedTextRange {
            selectedTextRange = nil
            selectedTextRange = existingSelectedTextRange
        }
    }
}
