//
//  TabBarVC2ViewController.swift
//  COP
//
//  Created by Mac on 31/07/24.
//

import UIKit

class TabBarVC2ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // ser role from UserDefaults
           let userRole = UserDefaults.standard.string(forKey: "userRole")
           
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
           let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
           let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
           
           var viewControllers: [UIViewController] = [homeVC, profileVC, settingsNavController]
           
           if userRole != "USER" {
               let adminVC = storyboard.instantiateViewController(withIdentifier: "AdminViewController")
               let adminNavController = UINavigationController(rootViewController: adminVC)
                viewControllers.insert(adminNavController, at: 1)// Insert Admin tab at the desired position
           }
           
           self.viewControllers = viewControllers
           
           homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
      
           if userRole != "USER" {
               let adminVC = viewControllers[2]
               adminVC.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "shield.lefthalf.filled.badge.checkmark"), tag: 1)
           }
           profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
           settingsNavController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 3)
    }
    
}
