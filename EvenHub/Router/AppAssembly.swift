//
//  AppAssembly.swift
//  EvenHub
//
//  Created by Иван Семенов on 19.09.2025.
//

import UIKit

final class AppAssembly {
    // services
    lazy var apiClient: APIClientProtocol = APIClient()
    lazy var eventService: IEventAPIService = EventAPIService(apiClient: apiClient)
    lazy var appState: AppStateStoring = UDAppStateStore()
    
    // factories
    func makeOnboarding(onFinish: @escaping () -> Void) -> UIViewController {
        let vc = OnboardingViewController()
        vc.onFinish = onFinish
        return vc
    }
    
    func makeExploreModule() -> UIViewController {
        let vc = UINavigationController(rootViewController: ExploreViewController())
        return vc
    }
    
    func makeEventModule() -> UIViewController {
        let vc = EventDetailsVC()
        return vc
    }
    
    func makeMapModule() -> UIViewController {
        let vc = Map()
        return vc
    }
    
    func makeFavoritesModule() -> UIViewController {
        let vc = FavoritesViewController()
        return vc
    }
    
    func makeProfileModule() -> UIViewController {
        let vc = ProfileViewController()
        return vc
    }
    
    func makeMainTabBar(onCenterTap: @escaping () -> Void) -> UIViewController {
        let tab = CustomTabBarController()
        tab.onCenterTap = onCenterTap
        return tab
    }
}
