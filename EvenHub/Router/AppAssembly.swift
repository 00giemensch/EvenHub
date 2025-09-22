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
    
    func makeAuth(
        onSignUp: @escaping () -> Void,
        onResetPassword: @escaping () -> Void,
        onMain: @escaping () -> Void
    ) -> UIViewController {
        let vc = SignInViewController()
        vc.onSignUp = onSignUp
        vc.onResetPassword = onResetPassword
        vc.onMain = onMain
        return vc
    }
    
    func makeSignUp(
        onSignIn: @escaping () -> Void,
        onMain: @escaping () -> Void
    ) -> UIViewController {
        let vc = SignUpViewController()
        vc.onSignIn = onSignIn
        vc.onMain = onMain
        return vc
    }
    
    func makeResetPasswordMain(
        onSignIn: @escaping () -> Void,
        onResetPasswordSecondStep: @escaping () -> Void
    ) -> UIViewController {
        let vc = ResetPasswordMainViewController()
        vc.onSignIn = onSignIn
        vc.onResetPasswordSecondStep = onResetPasswordSecondStep
        return vc
    }
    
    func makeResetPasswordSecond() -> UIViewController {
        let vc = ResetPasswordSecondViewController()
        return vc
    }
    
    func makeResetPasswordSecond(
        onSignIn: @escaping () -> Void,
        onResetPassword: @escaping () -> Void
    ) -> UIViewController {
        let vc = ResetPasswordSecondViewController()
        vc.onSignIn = onSignIn
        vc.onResetPassword = onResetPassword
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
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }
    
    func makeProfileModule(onSignIn: @escaping () -> Void) -> UIViewController {
        let vc = ProfileViewController()
        vc.onSigin = onSignIn
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
                    let mockEvents: [FavoriteEvent] = []
                    let seeAllVC = SeeAllViewController(events: mockEvents, type: .upcoming)
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
