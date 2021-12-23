//
//  AppCoordinator.swift
//  BackgroundUpdateableApp
//
//  Created by Kanan Abilzada on 23.12.21.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}


class AppCoordinator: Coordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let navigationController = UINavigationController()
        if #available(iOS 13.0, *) {
            navigationController.overrideUserInterfaceStyle = .light
        }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let launchCoordinator = MainPageCoordinator(navigationController: navigationController)
        coordinate(to: launchCoordinator)
    }
}
