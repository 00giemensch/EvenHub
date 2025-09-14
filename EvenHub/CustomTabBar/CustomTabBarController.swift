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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupCustomTabBar()
        setupViewControllers()
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
        self.setValue(customTabBar, forKey: "tabBar")
    }
    
    private func setupViewControllers() {
        let exploreVC = UINavigationController(rootViewController: ExploreViewController())
        
        let exploreVCNormalImage = UIImage(named: "tabBar_explore")?.withTintColor(btnTintColor, renderingMode: .alwaysOriginal)
        let exploreVCSelectedImage = UIImage(named: "tabBar_explore")?.withTintColor(btnSelectedTintColor, renderingMode: .alwaysOriginal)
        
        exploreVC.tabBarItem = UITabBarItem(title: "Explore", image: exploreVCNormalImage, selectedImage: exploreVCSelectedImage)
        exploreVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let eventsVC = EventDetailsVC()
        
        let eventsVCNormalImage = UIImage(named: "tabBar_calendar")?.withTintColor(btnTintColor, renderingMode: .alwaysOriginal)
        let eventsVCSelectedImage = UIImage(named: "tabBar_calendar")?.withTintColor(btnSelectedTintColor, renderingMode: .alwaysOriginal)
        
        eventsVC.tabBarItem = UITabBarItem(title: "Events", image: eventsVCNormalImage, selectedImage: eventsVCSelectedImage)
        eventsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        // Пустой контроллер для центральной кнопки
        let emptyVC = Map()
        emptyVC.tabBarItem = UITabBarItem(title: "", image: nil, tag: 2)
        emptyVC.tabBarItem.isEnabled = false
        
        let mapVC = Map()
        
        let mapVCNormalImage = UIImage(named: "tabBar_location")?.withTintColor(btnTintColor, renderingMode: .alwaysOriginal)
        let mapVCSelectedImage = UIImage(named: "tabBar_location")?.withTintColor(btnSelectedTintColor, renderingMode: .alwaysOriginal)
        
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: mapVCNormalImage, selectedImage: mapVCSelectedImage)
        mapVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let profileVC = Profile()
        
        let profileVCNormalImage = UIImage(named: "tabBar_profile")?.withTintColor(btnTintColor, renderingMode: .alwaysOriginal)
        let profileVCSelectedImage = UIImage(named: "tabBar_profile")?.withTintColor(btnSelectedTintColor, renderingMode: .alwaysOriginal)
        
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: profileVCNormalImage, selectedImage: profileVCSelectedImage)
        profileVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        self.viewControllers = [exploreVC, eventsVC, emptyVC, mapVC, profileVC]
    }
    
}
