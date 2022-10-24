//
//  AppDelegate.swift
//  pokemon
//
//  Created by Maksimilian on 23.10.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: TableCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        let navController = UINavigationController()
        coordinator = TableCoordinator(navigationController: navController)
        coordinator?.start()
        window.rootViewController = navController
        
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    

   


}

