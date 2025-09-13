import UIKit

//TODO: Переработать кнопку
class AuthenticationButton: UIButton {
    var title: String
    
    // MARK: - Init
    
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        setupStyle()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.title = ""
        super.init(coder: coder)
        setupStyle()
        setupUI()
    }
    
    private let arrowIcon: UIImageView = {
        let arrowIcon = UIImageView()
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        arrowIcon.image = Constants.Icons.Authentication.arrowIcon
        arrowIcon.isUserInteractionEnabled = false
        arrowIcon.contentMode = .scaleAspectFit
        
        return arrowIcon
    }()
    
    //MARK: - Methods
    private func setupStyle() {
        self.setAttributedTitle(Constants.Fonts.attributedString(
            for: self.title,
            font: Constants.Fonts.medium.uppercased(),
            fontSize: 16,
            letterSpacing: 1),
                                for: .normal)
        self.setTitleColor(Constants.Colors.PrimaryBlue.blue0, for: .normal)
        self.backgroundColor = Constants.Colors.PrimaryBlue.blue40
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.titleLabel?.textAlignment = .center
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrowIcon)
        NSLayoutConstraint.activate([
            arrowIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            arrowIcon.heightAnchor.constraint(equalToConstant: 30),
            arrowIcon.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
