import UIKit

class AuthenticationTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let image = UIImageView()
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        rightView = image
        rightViewMode = .always
        
    }
}
