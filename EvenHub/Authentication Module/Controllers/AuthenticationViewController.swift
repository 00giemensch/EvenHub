//
//  AutenticationViewController.swift
//  EvenHub
//
//  Created by Aliaksandr Zuyeu on 8.09.25.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    var account: AuthenticationModel?
    
    //MARK: - UI Components
    private let eventHubImage: UIImageView = {
        let eventHubImage = UIImageView()
        eventHubImage.translatesAutoresizingMaskIntoConstraints = false
        eventHubImage.image = Constants.Icons.Authentication.eventHub
        return eventHubImage
    }()
    
    private let appLabel: UILabel = {
        let appLabel = UILabel()
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        appLabel.attributedText = Constants.Fonts.attributedString(for: Constants.appName, font: Constants.Fonts.bold, fontSize: 50, lineHeigh: 72)
        return appLabel
    }()
    
    private let loginTextField: UITextField = {
       let loginTextField = UITextField()
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        loginTextField.attributedPlaceholder = Constants.Fonts.attributedString(for: <#T##String#>, font: <#T##String#>, fontSize: <#T##CGFloat#>, lineHeigh: <#T##CGFloat#>)
        return loginTextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setupUI() {
        
    }
    
//    func attributedString(for text: String, font: String, fontSize: CGFloat, lineHeigh: CGFloat, letterSpacing: CGFloat = 0) -> NSAttributedString {
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.minimumLineHeight = lineHeigh
//        paragraphStyle.maximumLineHeight = lineHeigh
//        
//        let attributes: [NSAttributedString.Key: Any] = [
//            .paragraphStyle: paragraphStyle,
//            .font: UIFont(name: font, size: fontSize) as Any,
//            .kern: letterSpacing
//        ]
//        
//        return NSAttributedString(string: text, attributes: attributes)
//    }
}
