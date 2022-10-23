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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        let viewModel = PokemonTableModelView(networkingService: NetworkingApi())
        let viewController = PokemonTableViewController(viewModel: viewModel)
                                                        
        window.rootViewController = UINavigationController(rootViewController: viewController)
        
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    

   


}

