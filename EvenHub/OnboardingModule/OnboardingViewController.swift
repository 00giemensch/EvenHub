//
//  OnboardingViewController.swift
//  EvenHub
//
//  Created by Евгений Васильев on 11.09.2025.
//
import UIKit
import Foundation

class OnboardingViewController : UIViewController {
    enum Constants {
        static let skipTitle = "Skip"
        static let nextTitle = "Next"
        static let titleLabelText = ["Explore Upcoming and\nNearby Events"," Web Have Modern Events\nCalendar Feature","  To Look Up More Events or\nActivities Nearby By Map"]
        static let detailLabelText = "In publishing and graphic design, Lorem is\na placeholder text commonly"
        static let iphoneImages = ["iPhoneOne","iPhoneTwo", "iPhoneThree"]
        static let blurImage = "mask"
    }
    
    let numberOfPages = 3
    private var currentPage = 0
    
    //MARK: - Create UI
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "5669FF", alpha: 1)
        view.layer.cornerRadius = 65
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.text = Constants.titleLabelText[0]
        label.numberOfLines = 0
        return label
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .light)
        label.textAlignment = .center
        label.text = Constants.detailLabelText
        label.numberOfLines = 0
        return label
    }()
    
    let skipButton : UIButton = {
        let button = UIButton()
        button.setTitle(Constants.skipTitle, for: .normal)
        button.titleLabel?.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        return button
    }()
    
    let nextButton : UIButton = {
        let button = UIButton()
        button.setTitle(Constants.nextTitle, for: .normal)
        button.titleLabel?.textColor = .white
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
    
    let sampleImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Constants.iphoneImages[0])
        return view
    }()
    
    let blurImageView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Constants.blurImage)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    //MARK: - Func
    
    private func updatePageIndicators() {
        for (index, view) in indicatorStackView.arrangedSubviews.enumerated() {
            if index == currentPage {
                view.backgroundColor = .white
            } else {
                view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [self] in
            let newImage = UIImage(named: Constants.iphoneImages[currentPage])
            UIView.transition(with: sampleImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.sampleImageView.image = newImage
            })
            UIView.transition(with: titleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.titleLabel.text = Constants.titleLabelText[self.currentPage]
            })
            updatePageIndicators()
        }
    }
    
    @objc private func nextButtonTapped(sender: UIButton) {
        sender.buttonTappedAnimate()
        if currentPage < numberOfPages - 1 {
            currentPage += 1
            updateUI()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePageIndicators()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(sampleImageView)
        view.addSubview(bottomView)
        bottomView.addSubview(titleLabel)
        bottomView.addSubview(detailLabel)
        bottomView.addSubview(skipButton)
        bottomView.addSubview(nextButton)
        bottomView.addSubview(indicatorStackView)
        view.addSubview(blurImageView)
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.topAnchor.constraint(equalTo: view.topAnchor, constant: 624)
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
            sampleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sampleImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35),
            sampleImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 54),
            sampleImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -54),
            sampleImageView.heightAnchor.constraint(equalToConstant: 540)
        ])
        
        blurImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            blurImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurImageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
        ])
    }
}
