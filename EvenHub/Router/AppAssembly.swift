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
    
    func makeSignUp() -> UIViewController {
        let vc = SignUpViewController()
        return vc
    }
    
    ///добавляем параметр testClosure
    func makeExploreModule(openSearchScene: @escaping (UIViewController) -> Void) -> UIViewController {
        let exploreVC = ExploreViewController()
        ///присваеваем кложур
        exploreVC.pushNewVC = openSearchScene
        return exploreVC
    }
    
    func makeEventsModule(openSeeAllScene: @escaping () -> Void) -> UIViewController {
        let eventsVC = EventsViewController()
        eventsVC.openSeeAllScene = openSeeAllScene
        return eventsVC
    }
    
    func makeEventModule() -> UIViewController {
        let vc = EventDetailsVC()
        return vc
    }
    
    func makeMapModule() -> UIViewController {
        let vc = MapViewController()
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
        
        ///создание exploreVC
        tab.exploreProvider = { [weak self] in
            guard let self else { return UIViewController() }
            /// дергаем метод выше для создания exploreVC
            let exploreVC = self.makeExploreModule { newVC in
                /// обращаемся к навигаторконтролеру у exploreVC
                if let nav = tab.exploreNavigationController {
                    /// говорим че делать
                    
                    nav.pushViewController(newVC, animated: true)
                }
            }
            return exploreVC
        }
    
        tab.eventsProvider = { [weak self] in
            guard let self else { return UIViewController() }
            let eventsVC = self.makeEventsModule {
                if let nav = tab.eventsNavigationController {
                    let seeAllVC = SeeAllViewController()
                    nav.pushViewController(seeAllVC, animated: true)
                }
            }
            return eventsVC
        }
        ///вызываем настройку всех контроллеров
        tab.setupViewControllers()
        ///возвращаем таббар
        return tab
    }
}
