import UIKit

class AuthenticationButton: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Constants.Colors.PrimaryBlue.blue0
        button.backgroundColor = Constants.Colors.PrimaryBlue.blue40
        button.layer.cornerRadius = 15
        return button
    }()
    
    let arrow: UIImageView = {
        let arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = Constants.Icons.Common.arrowWhiteRight
        arrow.backgroundColor = Constants.Colors.PrimaryBlue.blue50
        arrow.layer.cornerRadius = 25
        arrow.isUserInteractionEnabled = true
        arrow.contentMode = .scaleAspectFit
        return arrow
    }()
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 58),
            button.widthAnchor.constraint(equalToConstant: 271)
        ])
        
        addSubview(arrow)
        NSLayoutConstraint.activate([
            arrow.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 242),
            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrow.heightAnchor.constraint(equalToConstant: 30),
            arrow.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
