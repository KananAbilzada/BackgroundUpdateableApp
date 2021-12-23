//
//  MainPageCoordinator.swift
//  BackgroundUpdateableApp
//
//  Created by Kanan Abilzada on 23.12.21.
//

import UIKit

class MainPageCoordinator: Coordinator {
    unowned let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainViewController = MainViewController.instantiate(storyboard: "Main")
        
        navigationController
            .pushViewController(mainViewController, animated: true)
    }
}
