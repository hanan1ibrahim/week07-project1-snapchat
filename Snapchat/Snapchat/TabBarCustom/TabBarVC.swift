//
//  TabBarVC.swift
//  Snapchat
//
//  Created by HANAN on 05/04/1443 AH.
//


import UIKit
class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        viewControllers = [
            barItem(tabBarTitle: "Map", tabBarImage: UIImage(systemName: "mappin")!.withTintColor(.white, renderingMode: .alwaysOriginal), viewController:  MapScreen()),
            barItem(tabBarTitle: "Chat", tabBarImage: UIImage(systemName: "message")!.withTintColor(.white, renderingMode: .alwaysOriginal), viewController: ChatScreen()),
            
            barItem(tabBarTitle: "Camera", tabBarImage: UIImage(systemName: "camera")!.withTintColor(.white, renderingMode: .alwaysOriginal), viewController: CamVC()),
            barItem(tabBarTitle: "Users", tabBarImage: UIImage(systemName: "person.3")! .withTintColor(.white, renderingMode: .alwaysOriginal),viewController: ChatScreen()),
            barItem(tabBarTitle: "Profile", tabBarImage: UIImage(systemName: "person")!.withTintColor(.white, renderingMode: .alwaysOriginal), viewController: ProfileVC()),
        ]
        
        tabBar.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        tabBar.isTranslucent = false
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.cyan], for: .selected)
        tabBar.unselectedItemTintColor = .white
        
        selectedIndex   = 1
    }
    
    private func barItem(tabBarTitle: String, tabBarImage: UIImage, viewController: UIViewController) -> UINavigationController {
        let navCont = UINavigationController(rootViewController: viewController)
        navCont.tabBarItem.title = tabBarTitle
        navCont.tabBarItem.image = tabBarImage
        return navCont
    }
    
}


