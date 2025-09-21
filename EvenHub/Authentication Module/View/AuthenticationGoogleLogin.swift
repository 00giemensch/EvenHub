import UIKit
import GoogleSignIn
import FirebaseAuth

class AuthenticationGoogleLogin: UIButton {
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }
    
    private func setupStyle() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Login with Google"
        configuration.baseBackgroundColor = Constants.Colors.Background.googleButton
        configuration.baseForegroundColor =
        Constants.Colors.TypographyColor.typographyColor50
        if let icon = Constants.Icons.Authentication.googleIcon {
            configuration.image = icon
            configuration.imagePlacement = .leading
            configuration.imagePadding = 32
        }
        
        self.configuration = configuration
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont(name: Constants.Fonts.medium, size: 16)
    }
}

