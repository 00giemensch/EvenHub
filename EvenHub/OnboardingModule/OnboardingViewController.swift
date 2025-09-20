//
//  OnboardingViewController.swift
//  EvenHub
//
//  Created by Евгений Васильев on 11.09.2025.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private var model = OnboardingModel()
    private let onboardingView = OnboardingView()
    var onFinish: (() -> Void)?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePageIndicators()
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        view = onboardingView
    }
    
    private func setupActions() {
        onboardingView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - Func
    
    private func updatePageIndicators() {
        for (index, view) in onboardingView.indicatorStackView.arrangedSubviews.enumerated() {
            if index == model.currentPage {
                view.backgroundColor = .white
            } else {
                view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [self] in
            let newImage = UIImage(named: OnboardingModel.Constants.iphoneImages[model.currentPage])
            UIView.transition(with: onboardingView.sampleImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.onboardingView.sampleImageView.image = newImage
            })
            UIView.transition(with: onboardingView.titleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.onboardingView.titleLabel.text = OnboardingModel.Constants.titleLabelText[self.model.currentPage]
            })
            updatePageIndicators()
        }
    }
    
    @objc private func nextButtonTapped(sender: UIButton) {
        sender.buttonTappedAnimate()
        if model.currentPage < model.numberOfPages - 1 {
            model.currentPage += 1
            updateUI()
        } else {
            onFinish?()
        }
    }
    
    @objc private func skipButtonTapped(sender: UIButton) {
        sender.buttonTappedAnimate()
        onFinish?()
    }
}
