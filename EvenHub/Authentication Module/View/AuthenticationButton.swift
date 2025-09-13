import UIKit

//TODO: Переработать кнопку
class AuthenticationButton: UIButton {
    struct Config {
            var title: String = "Button"
            var backgroundColor: UIColor = Constants.Colors.PrimaryBlue.blue40 ?? .systemBlue
            var textColor: UIColor = Constants.Colors.PrimaryBlue.blue0 ?? .white
            var cornerRadius: CGFloat = 20
            var font: UIFont = UIFont(name: Constants.Fonts.medium, size: 16) ?? .systemFont(ofSize: 16, weight: .medium)
            var icon: UIImage? = Constants.Icons.Common.arrowWhiteRight ?? UIImage(systemName: "arrow.right")
            var spacing: CGFloat = 8
        
        }
        
        private var customConfig: Config
        
        // MARK: - Init
        init(config: Config) {
            self.customConfig = config
            super.init(frame: .zero)
            setupStyle()
        }
        
        required init?(coder: NSCoder) {
            self.customConfig = Config(
                title: "Button",
                backgroundColor: Constants.Colors.PrimaryBlue.blue40 ?? .systemBlue,
                textColor: Constants.Colors.PrimaryBlue.blue0 ?? .white,
                cornerRadius: 20,
                font: UIFont(name: Constants.Fonts.medium, size: 16) ?? .systemFont(ofSize: 16, weight: .medium),
                icon: Constants.Icons.Common.arrowWhiteRight ?? UIImage(systemName: "arrow.right"),
                spacing: 8
            )
            super.init(coder: coder)
            setupStyle()
        }
        
        private func setupStyle() {
            var configuration = UIButton.Configuration.filled()
            
            // Текст
            configuration.title = customConfig.title
            configuration.baseForegroundColor = customConfig.textColor
            
            // Иконка
            if let icon = customConfig.icon {
                configuration.image = icon
                configuration.imagePlacement = .trailing
                configuration.imagePadding = customConfig.spacing
            }
            
            // Фон
            configuration.baseBackgroundColor = customConfig.backgroundColor
            
            self.configuration = configuration
            
            // Скругление
            self.layer.cornerRadius = customConfig.cornerRadius
            self.layer.masksToBounds = true
            
            // Шрифт (отдельно на titleLabel)
            self.titleLabel?.font = customConfig.font
        }
        
        func update(config: Config) {
            self.customConfig = config
            setupStyle()
        }
}

//import UIKit
//
//class AuthenticationButton: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
//    let button: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.tintColor = Constants.Colors.PrimaryBlue.blue0
//        button.backgroundColor = Constants.Colors.PrimaryBlue.blue40
//        button.layer.cornerRadius = 18
//        return button
//    }()
//
//    let arrow: UIImageView = {
//        let arrow = UIImageView()
//        arrow.translatesAutoresizingMaskIntoConstraints = false
//        arrow.image = Constants.Icons.Common.arrowWhiteRight
//        arrow.backgroundColor = Constants.Colors.PrimaryBlue.blue50
//        arrow.layer.cornerRadius = 25
//        arrow.isUserInteractionEnabled = true
//        arrow.contentMode = .scaleAspectFit
//        return arrow
//    }()
//
//    private func setup() {
//        translatesAutoresizingMaskIntoConstraints = false
//        addSubview(button)
//        NSLayoutConstraint.activate([
//            button.centerXAnchor.constraint(equalTo: centerXAnchor),
//            button.centerYAnchor.constraint(equalTo: centerYAnchor),
//            button.heightAnchor.constraint(equalToConstant: 58),
//            button.widthAnchor.constraint(equalToConstant: 271)
//        ])
//
//        addSubview(arrow)
//        NSLayoutConstraint.activate([
//            arrow.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 242),
//            arrow.centerYAnchor.constraint(equalTo: centerYAnchor),
//            arrow.heightAnchor.constraint(equalToConstant: 30),
//            arrow.widthAnchor.constraint(equalToConstant: 30)
//        ])
//    }
//}
