//
//  SearchTextField.swift
//  EvenHub
//
//  Created by Andrei Kovryzhenko on 14.09.2025.
//

import UIKit

class SearchTextField: UITextField {
    //MARK: - Properties
    enum SearchScheme {
        case gray
        case blue
    }
    private let scheme: SearchScheme
    var action: (() -> Void)?
    
    //MARK: - UI Components
    private let button = UIButton()
    
    //MARK: - Lifecycle
    init(scheme: SearchScheme) {
        self.scheme = scheme
        super.init(frame: .zero)
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    @objc private func buttonPressed() {
           guard let action = self.action else { return }
           action()
       }
    
    //MARK: - Setup Layout
    private func setupLayout() {
        setupTextField()
        setupLeftView()
        setupButton()
        setupRightView()
    }
    private func setupTextField() {
        self.font = UIFont(name: Constants.Fonts.book, size: 20)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(resource: .blue0).withAlphaComponent(0.3),
            .font: UIFont(name: Constants.Fonts.book, size: 20) ?? .systemFont(ofSize: 20)
        ]
        self.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: attributes)
    }
    private func setupLeftView() {
        let imageView = UIImageView(frame: CGRect(x: 2, y: 0 , width: 24, height: 24))
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 24))
        leftPaddingView.addSubview(imageView)
        let separatorView = UIView(frame: CGRect(x: leftPaddingView.frame.maxX - 6, y: 0, width: 1, height: 24))
        separatorView.layer.cornerRadius = 2
        switch scheme {
        case .gray:
            imageView.image = UIImage(resource: .exploreSearch)
            separatorView.backgroundColor = UIColor(resource: .color10).withAlphaComponent(0.3)
        case .blue:
            imageView.image = UIImage(resource: .searchBlue)
            separatorView.backgroundColor = UIColor(resource: .blue50).withAlphaComponent(0.7)
        }
        leftPaddingView.addSubview(separatorView)
        self.leftView = leftPaddingView
        self.leftViewMode = .always
    }
    private func setupButton() {
        button.frame = CGRect(x: 0, y: 0, width: 75, height: 32)
        button.setImage(UIImage(resource: .filterPic), for: .normal)
        let subtitleText = NSMutableAttributedString()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Constants.Fonts.book, size: 12) ?? .systemFont(ofSize: 12, weight: .light),
            .foregroundColor: UIColor.white
        ]
        subtitleText.append(NSAttributedString(string: "Filters", attributes: attributes))
        button.setAttributedTitle(subtitleText, for: .normal)
        button.layer.backgroundColor = Constants.Colors.PrimaryBlue.buttonBlue.cgColor
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    private func setupRightView() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 75, height: 32))
        paddingView.addSubview(button)
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
