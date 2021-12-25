//
//  ViewController.swift
//  BackgroundUpdateableApp
//
//  Created by Kanan Abilzada on 22.12.21.
//

import UIKit

class MainViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let _ = UserDefaults.standard.value(forKey: "backgroundTask") as? String {
            infoLabel.text = "Triggered"
        } else {
            infoLabel.text = "Not run yet"
        }
        
    }

}


extension Notification.Name {
  static let requestSent = Notification.Name("requestSent")
}
