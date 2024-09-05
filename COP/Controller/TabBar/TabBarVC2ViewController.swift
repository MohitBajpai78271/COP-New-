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

        // Fetch the user role from UserDefaults
           let userRole = UserDefaults.standard.string(forKey: "userRole")
           
           // Initialize view controllers from the storyboard
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
           let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
           let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
        
        let settingsNavController = UINavigationController(rootViewController: settingsVC)
           
           var viewControllers: [UIViewController] = [homeVC, profileVC, settingsNavController]
           
           // Add Admin tab if the user role is not "USER"
           if userRole != "USER" {
               let adminVC = storyboard.instantiateViewController(withIdentifier: "AdminViewController")
               viewControllers.insert(adminVC, at: 1) // Insert Admin tab at the desired position
           }
           
           // Set the view controllers to the tab bar
           self.viewControllers = viewControllers
           
           // Optionally set titles and images for each tab
           homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
      
           if userRole != "USER" {
               let adminVC = viewControllers[2] // The AdminVC will be at index 2 if inserted
               adminVC.tabBarItem = UITabBarItem(title: "Admin", image: UIImage(systemName: "shield.lefthalf.filled.badge.checkmark"), tag: 1)
           }
           profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
           settingsNavController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gearshape.fill"), tag: 3)
    }
    
}
