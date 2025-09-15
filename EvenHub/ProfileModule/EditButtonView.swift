//
//  EditButtonView.swift
//  EvenHub
//
//  Created by Евгений Васильев on 15.09.2025.
//
import UIKit

class EditButtonView : UIButton {
    
    //MARK: - Create UI
    
    let editIconImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: ProfileModel.Constants.editIconImage)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let editLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.blue50
        label.font = UIFont(name: ProfileModel.Constants.airBnbCerealBookFont, size: 16)
        label.textAlignment = .center
        label.text = "Edit Profile"
        label.numberOfLines = 0
        return label
    }()
    
    let stackView : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        view.distribution = .fill
        view.alignment = .center
        return view
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    convenience init(iconImage: String, labelText: String) {
            self.init(frame: .zero)
            configure(with: iconImage, labelText: labelText)
        }
    
    func configure(with iconImage: String, labelText: String) {
            editIconImageView.image = UIImage(named: iconImage)
            editLabel.text = labelText
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .clear
        addSubview(stackView)
        stackView.addArrangedSubview(editIconImageView)
        stackView.addArrangedSubview(editLabel)
    }
    
    //MARK: - Constraints
    
    private func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
         ])
    }
}
