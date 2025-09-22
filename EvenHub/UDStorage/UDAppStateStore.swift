//
//  UDAppStateStore.swift
//  EvenHub
//
//  Created by Иван Семенов on 19.09.2025.
//

import Foundation

protocol AppStateStoring {
    var hasCompletedOnboarding: Bool { get set }
    var hasEnabledRememberMe: Bool { get set }
}

final class UDAppStateStore: AppStateStoring {
    private enum Key { static let onboardingDone = "app.onboardingDone" }
    private enum RememberMe { static let isRememberMeEnabled = "app.isRememberMeEnabled"}
    
    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: Key.onboardingDone) }
        set { UserDefaults.standard.set(newValue, forKey: Key.onboardingDone) }
    }
    
    var hasEnabledRememberMe: Bool {
        get { UserDefaults.standard.bool(forKey: RememberMe.isRememberMeEnabled) }
        set { UserDefaults.standard.set(newValue, forKey: RememberMe.isRememberMeEnabled) }
    }
}
