//
//  OnboardingView.swift
//  EvenHub
//
//  Created by Евгений Васильев on 11.09.2025.
//
import UIKit

class OnboardingView: UIView {
    
    //MARK: - Create UI
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "5669FF", alpha: 1)
        view.layer.cornerRadius = 65
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.text = OnboardingModel.Constants.titleLabelText[0]
        label.numberOfLines = 0
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .center
        label.text = OnboardingModel.Constants.detailLabelText
        label.numberOfLines = 0
        return label
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle(OnboardingModel.Constants.skipTitle, for: .normal)
        button.titleLabel?.textColor = UIColor.lightGray
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle(OnboardingModel.Constants.nextTitle, for: .normal)
        button.titleLabel?.textColor = .white
        return button
    }()
    
    lazy var indicatorStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 10
        for i in 0...2 {
            let indicator = UIView()
            indicator.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            indicator.layer.cornerRadius = 4
            view.addArrangedSubview(indicator)
        }
        return view
    }()
    
    let sampleImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: OnboardingModel.Constants.iphoneImages[0])
        return view
    }()
    
    let blurImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: OnboardingModel.Constants.blurImage)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(sampleImageView)
        addSubview(bottomView)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(detailLabel)
        bottomView.addSubview(skipButton)
        bottomView.addSubview(nextButton)
        bottomView.addSubview(indicatorStackView)
        addSubview(blurImageView)
    }
    
    //MARK: - Constraints
    
    private func setConstraints() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.topAnchor.constraint(equalTo: topAnchor, constant: 624)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            detailLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
        
        indicatorStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorStackView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 43),
            indicatorStackView.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            indicatorStackView.widthAnchor.constraint(equalToConstant: 40),
            indicatorStackView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            skipButton.centerYAnchor.constraint(equalTo: indicatorStackView.centerYAnchor),
            skipButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 40),
            skipButton.heightAnchor.constraint(equalToConstant: 34),
            skipButton.widthAnchor.constraint(equalToConstant: 38)
        ])
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerYAnchor.constraint(equalTo: indicatorStackView.centerYAnchor),
            nextButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -40),
            nextButton.heightAnchor.constraint(equalToConstant: 34),
            nextButton.widthAnchor.constraint(equalToConstant: 38)
        ])
        
        sampleImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sampleImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            sampleImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 35),
            sampleImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 54),
            sampleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -54),
            sampleImageView.heightAnchor.constraint(equalToConstant: 540)
        ])
        
        blurImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            blurImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurImageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
        ])
    }
}
