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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        return imageView
    }()
    
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        rightView = imageView
        rightViewMode = .always
    }
    
    func updateImage(image: UIImage) {
        imageView.image = image
        setup()
    }
}
