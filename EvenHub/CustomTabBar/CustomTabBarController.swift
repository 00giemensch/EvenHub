//
//  CustomTabBarController.swift
//  EventsApp
//
//  Created by Никита Грицунов on 10.09.2025.
//
import UIKit


class CustomTabBarController: UITabBarController {
    
    private var btnSelectedTintColor: UIColor { UIColor(red: 86 / 255, green: 105 / 255, blue: 255 / 255, alpha: 1) }
    private var btnTintColor: UIColor { UIColor(red: 213 / 255, green: 215 / 255, blue: 220 / 255, alpha: 1) }
    var onCenterTap: (() -> Void)?
    /// кложура в которой будет настройка exploreVC
    var exploreProvider: (() -> UIViewController)?
    /// навигатор контроллер для exploreVC
    private(set) var exploreNavigationController: UINavigationController?
    
    var eventsProvider: (() -> UIViewController)?
    private(set) var eventsNavigationController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupCustomTabBar()
        /// вызываем в ручную т.к. viewDidLoad вызывается позже и мы получим nil
        //        setupViewControllers()
        setupCustomTabBarAppearance()
    }
    
    private func setupCustomTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: btnTintColor,
                                                                         .font: UIFont(name: "Arial", size: 12)!]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: btnSelectedTintColor]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupCustomTabBar() {
        let customTabBar = CustomTabBar()
        customTabBar.onCenterTap = { [weak self] in
            self?.onCenterTap?()
        }
        self.setValue(customTabBar, forKey: "tabBar")
    }
    
    func setupViewControllers() {
        
        // Explore
        /// настройка UINavigationController exploreTestProvider вернет либо то, что настроили в func makeMainTabBar(onCenterTap: ) либо пустой контроллер
        /// если что-то пошло не так мб можно сделать краше без опционалов, но щас надо другие задачи доделать
        let exploreVC = UINavigationController(rootViewController: exploreProvider?() ?? UIViewController())
        /// присваеваем UINavigationController наш exploreVC 👆
        exploreNavigationController = exploreVC
        
        let exploreVCNormalImage = UIImage(named: "tabBar_explore")?.withTintColor(btnTintColor, renderingMode: .alwaysOriginal)
        let exploreVCSelectedImage = UIImage(named: "tabBar_explore")?.withTintColor(btnSelectedTintColor, renderingMode: .alwaysOriginal)
        
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: exploreVCNormalImage, selectedImage: exploreVCSelectedImage)
        exploreVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        
        // Events
        let eventsVC = UINavigationController(rootViewController: eventsProvider?() ?? UIViewController())
        
        eventsNavigationController = eventsVC
        let eventsVCNormalImage = UIImage(named: "tabBar_calendar")?.withTintColor(btnTintColor, renderingMode: .alwaysOriginal)
        let eventsVCSelectedImage = UIImage(named: "tabBar_calendar")?.withTintColor(btnSelectedTintColor, renderingMode: .alwaysOriginal)
        
        eventsVC.tabBarItem = UITabBarItem(title: "Events", image: eventsVCNormalImage, selectedImage: eventsVCSelectedImage)
        eventsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        // Empty
        let emptyVC = MapViewController()
        emptyVC.tabBarItem = UITabBarItem(title: "", image: nil, tag: 2)
        emptyVC.tabBarItem.isEnabled = false
        
        // Map
        let mapVC = MapViewController()
        let mapVCNormalImage = UIImage(named: "tabBar_location")?.withTintColor(btnTintColor, renderingMode: .alwaysOriginal)
        let mapVCSelectedImage = UIImage(named: "tabBar_location")?.withTintColor(btnSelectedTintColor, renderingMode: .alwaysOriginal)
        
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: mapVCNormalImage, selectedImage: mapVCSelectedImage)
        mapVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        // Profile
        let profileVC = ProfileViewController()
        let profileVCNormalImage = UIImage(named: "tabBar_profile")?.withTintColor(btnTintColor, renderingMode: .alwaysOriginal)
        let profileVCSelectedImage = UIImage(named: "tabBar_profile")?.withTintColor(btnSelectedTintColor, renderingMode: .alwaysOriginal)
        
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: profileVCNormalImage, selectedImage: profileVCSelectedImage)
        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        self.viewControllers = [exploreVC, eventsVC, emptyVC, mapVC, profileVC]
    }
    
}
