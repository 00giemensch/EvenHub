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
    
    var textInsets = UIEdgeInsets(top: 10, left: 51, bottom: 10, right: 10)
    var leftViewPadding: CGFloat = 16
    var rightViewPadding: CGFloat = 16
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        return imageView
    }()

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        borderStyle = .none
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = Constants.Colors.TypographyColor.typographyColor10?.cgColor
        leftView = imageView
        leftViewMode = .always
    }
    
    func updateLeftImage(image: UIImage) {
        imageView.image = image
        setup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += leftViewPadding
        return rect
    }
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= rightViewPadding
        return rect
    }
}
