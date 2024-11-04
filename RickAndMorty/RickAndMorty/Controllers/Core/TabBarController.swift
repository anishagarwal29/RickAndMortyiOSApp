//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Anish Agarwal on 2/11/24.
//

import UIKit

/// Controller to house tabs and root tab controllers
final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpTabs()
    }
    
    private func setUpTabs() {
        let charactersVC = CharacterViewController()
        let settingsVC = SettingsViewController()
        let episodesVC = EpisodeViewController()
        let locationsVC = LocationViewController()
        
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: locationsVC)
        let nav3 = UINavigationController(rootViewController: episodesVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.3.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "globe.asia.australia.fill"), tag: 4)
        nav3.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "rectangle.stack.fill"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "wrench.and.screwdriver.fill"), tag: 2)
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        
    }
    
}

