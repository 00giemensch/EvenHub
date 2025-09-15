//
//  ProfileViewController.swift
//  EvenHub
//
//  Created by Евгений Васильев on 15.09.2025.
//
import UIKit

class ProfileViewController: UIViewController {
    enum Constants {
        
    }
    
    private var isTextExpanded = false
    
    //MARK: - Create UI
    
    let profileLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = ProfileModel.Constants.profileTitle
        label.numberOfLines = 0
        return label
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 48
        view.image = UIImage(named: ProfileModel.Constants.profileImage)
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .black
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.textAlignment = .center
        label.text = ProfileModel.Constants.nameLabel
        label.numberOfLines = 0
        return label
    }()
    
    let editButton: EditButtonView = {
        let button = EditButtonView(iconImage: ProfileModel.Constants.editIconImage, labelText: "Edit Profile")
        button.layer.borderColor = UIColor.blue50.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        return button
    }()
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .left
        label.text = ProfileModel.Constants.aboutLabel
        label.numberOfLines = 0
        return label
    }()
    
    let detailTextField: UITextView = {
        let view = UITextView()
        view.font = UIFont(name: ProfileModel.Constants.airBnbCerealBookFont, size: 18)
        view.isEditable = false
        view.isScrollEnabled = true
        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return view
    }()
    
    let editNameButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ProfileModel.Constants.editIconImage), for: .normal)
        return button
    }()
    
    let editDetailButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ProfileModel.Constants.editIconImage), for: .normal)
        return button
    }()
    
    let signoutButton: EditButtonView = {
        let button = EditButtonView(iconImage: ProfileModel.Constants.signoutIconImage, labelText: "Sign Out")
        button.editLabel.textColor = .black
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupTextView()
        updateTextViewText()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(profileLabel)
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(editButton)
        view.addSubview(aboutLabel)
        view.addSubview(detailTextField)
        view.addSubview(editNameButton)
        view.addSubview(editDetailButton)
        view.addSubview(signoutButton)
    }
    
    //MARK: - Func
    
    private func setupTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTextViewTap(_:)))
        detailTextField.addGestureRecognizer(tapGesture)
        detailTextField.isUserInteractionEnabled = true
    }
    
    @objc private func handleTextViewTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: detailTextField)
        guard let textPosition = detailTextField.closestPosition(to: location) else { return }
        let tapOffset = detailTextField.offset(from: detailTextField.beginningOfDocument, to: textPosition)
        let fullText = isTextExpanded ?
            ProfileModel.Constants.fullText + "Show Less" :
            ProfileModel.Constants.truncatedText + "Read More"
        let readMoreRange = (fullText as NSString).range(of: isTextExpanded ? "Show Less" : "Read More")
        if tapOffset >= readMoreRange.location && tapOffset < readMoreRange.location + readMoreRange.length {
            toggleTextExpansion()
        }
    }
    
    @objc private func toggleTextExpansion() {
        isTextExpanded.toggle()
        updateTextViewText()
    }
    
    private func updateTextViewText() {
        let baseText = isTextExpanded ? ProfileModel.Constants.fullText : ProfileModel.Constants.truncatedText
        let actionText = isTextExpanded ? "Show Less" : "Read More"
        let fullText = baseText + actionText
        let attributedString = NSMutableAttributedString(string: fullText)
        let mainFont = UIFont(name: ProfileModel.Constants.airBnbCerealBookFont, size: 16) ?? UIFont.systemFont(ofSize: 16)
        attributedString.addAttribute(.font, value: mainFont, range: NSRange(location: 0, length: fullText.count))
        let actionRange = (fullText as NSString).range(of: actionText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: actionRange)
        detailTextField.attributedText = attributedString
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor, constant: 31),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 96),
            profileImageView.heightAnchor.constraint(equalToConstant: 96)
        ])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 21),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.widthAnchor.constraint(equalToConstant: 154)
        ])
        
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aboutLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 35),
            aboutLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        detailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailTextField.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor, constant: 25),
            detailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            detailTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])
        
        editNameButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editNameButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            editNameButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 17),
            editNameButton.heightAnchor.constraint(equalToConstant: 22),
            editNameButton.widthAnchor.constraint(equalToConstant: 22)
        ])
        
        editDetailButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editDetailButton.centerYAnchor.constraint(equalTo: aboutLabel.centerYAnchor),
            editDetailButton.leadingAnchor.constraint(equalTo: aboutLabel.trailingAnchor, constant: 10),
            editDetailButton.heightAnchor.constraint(equalToConstant: 22),
            editDetailButton.widthAnchor.constraint(equalToConstant: 22)
        ])
        
        signoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signoutButton.topAnchor.constraint(equalTo: detailTextField.bottomAnchor, constant: 30),
            signoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signoutButton.heightAnchor.constraint(equalToConstant: 50),
            signoutButton.widthAnchor.constraint(equalToConstant: 154)
        ])
    }
}
