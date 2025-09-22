//
//  AppCoordinator.swift
//  EvenHub
//
//  Created by Иван Семенов on 19.09.2025.
//

import UIKit

enum AppState {
    case onboarding, auth, main, singUp, resetPassword, resetPasswordSecondStep
}

enum AppEvent {
    case launchCompleted,
         onboardingCompleted,
         userAuthorized,
         userLoggedOut,
         userPressedSignUp,
         userPressedResetPassword,
         userEnteredEmail
}

final class AppCoordinator {
    private let window: UIWindow
    private let assembly: AppAssembly
    private(set) var state: AppState = .onboarding
    
    init(window: UIWindow, assembly: AppAssembly) {
        self.window = window
        self.assembly = assembly
    }
    
    func start() {
        transition(to: reduce(.launchCompleted))
    }
    
    func reduce(_ event: AppEvent) -> AppState {
        switch event {
        case .launchCompleted:
            return rootState()
        case .onboardingCompleted:
            assembly.appState.hasCompletedOnboarding = true
            return .auth
        case .userAuthorized:
            return .main
        case .userLoggedOut:
            return .auth
        case .userPressedSignUp:
            return .singUp
        case .userPressedResetPassword:
            return .resetPassword
        case .userEnteredEmail:
            return .resetPasswordSecondStep
        }
    }
    
    private func rootState() -> AppState {
        
        if assembly.appState.hasCompletedOnboarding && assembly.appState.hasEnabledRememberMe {
            return .main
        } else if assembly.appState.hasCompletedOnboarding && !assembly.appState.hasEnabledRememberMe {
            return .auth
        } else {
            return .onboarding
        }
    }
    
    private func transition(to newState: AppState) {
        state = newState
        var rootVC: UIViewController
        
        switch newState {
        case .onboarding:
            rootVC = assembly.makeOnboarding { [weak self] in
                guard let self else { return }
                self.transition(to: self.reduce(.onboardingCompleted))
            }
        case .auth:
            rootVC = assembly.makeAuth(
                onSignUp: {
                    [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.userPressedSignUp))
                },
                onResetPassword: { [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.userPressedResetPassword))
                },
                onMain: { [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.userAuthorized))
                })
        case .main:
            rootVC = assembly.makeMainTabBar { [weak self] in
                self?.presentShareFromRoot()
            }
        case .singUp:
            rootVC = assembly.makeSignUp(
                onSignIn:{
                    [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.onboardingCompleted))
                },
                onMain: {
                    [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.userAuthorized))
                }
            )
        case .resetPassword:
            rootVC = assembly.makeResetPasswordMain(
                onSignIn:{
                    [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.onboardingCompleted))
                },
                onResetPasswordSecondStep: {
                    [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.userEnteredEmail))
                }
            )
        case .resetPasswordSecondStep:
            rootVC = assembly.makeResetPasswordSecond(
                onSignIn:{
                    [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.onboardingCompleted))
                },
                onResetPassword: {
                    [weak self] in
                    guard let self else { return }
                    self.transition(to: self.reduce(.userPressedResetPassword))
                }
            )
        }
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        UIView.transition(
            with: window,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
    
    private func presentShareFromRoot() {
        let share = ShareVC()
        share.modalPresentationStyle = .pageSheet
        if let sheet = share.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        window.rootViewController?.present(share, animated: true)
    }
}
