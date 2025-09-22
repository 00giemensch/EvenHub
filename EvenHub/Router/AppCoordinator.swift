//
//  AppCoordinator.swift
//  EvenHub
//
//  Created by Иван Семенов on 19.09.2025.
//

import UIKit

enum AppState {
    case onboarding, auth, main
}

enum AppEvent {
    case launchCompleted, onboardingCompleted, userAuthorized, userLoggedOut
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
            return .main
        case .userAuthorized:
            return .main
        case .userLoggedOut:
            return .auth
        }
    }
    
    private func rootState() -> AppState {
        assembly.appState.hasCompletedOnboarding ? .main : .onboarding
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
            rootVC = assembly.makeSignUp()
            self.transition(to: self.reduce(.userLoggedOut))
        case .main:
            rootVC = assembly.makeMainTabBar { [weak self] in
                self?.presentShareFromRoot()
            }
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
        let share = FavoritesViewController()
        window.rootViewController?.present(share, animated: true)
    }
}
