//
//  TabBarVC.swift
//  Snapchat
//
//  Created by HANAN on 05/04/1443 AH.
//


import UIKit

class TabBarVC : UITabBarController {
fileprivate func createNavController(for rootViewController: UIViewController,
             title: String,
             image: UIImage) -> UIViewController {
  let navController = UINavigationController(rootViewController: rootViewController)
  navController.tabBarItem.title = title
  navController.tabBarItem.image = image
  navController.navigationBar.prefersLargeTitles = true
  rootViewController.navigationItem.title = title
  return navController
 }
func setupVCs() {
    
  viewControllers = [
    
   createNavController(for:MapVC (), title: NSLocalizedString("location", comment: ""), image: UIImage(systemName: "location")!),
   createNavController(for:ConversationsVC(), title: NSLocalizedString("Chat", comment: ""), image: UIImage(systemName: "message")!),
   createNavController(for:CamVC(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "camera.fill")!),
   createNavController(for:Contacts(), title: NSLocalizedString("users", comment: ""), image: UIImage(systemName: "person.3")!),
   createNavController(for:ProfileVC(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person")!),
   
  ]
 }
override func viewDidLoad() {
 super.viewDidLoad()
 view.backgroundColor = .systemBackground
  UITabBar.appearance().barTintColor = .systemBackground
  tabBar.tintColor = .label
  setupVCs()
}
}







