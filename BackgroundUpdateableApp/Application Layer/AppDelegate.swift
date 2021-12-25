//
//  AppDelegate.swift
//  BackgroundUpdateableApp
//
//  Created by Kanan Abilzada on 22.12.21.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionDelegate {
        
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()

        /// for test
        registerBackgroundTasks()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        submitBackgroundTasks()
    }
    
    private let backgroundAppRefreshTaskSchedulerIdentifier = "com.example.fooBackgroundAppRefreshIdentifier"
    private let backgroundProcessingTaskSchedulerIdentifier = "com.example.fooBackgroundProcessingIdentifier"
    
    
//    MARK: - BackgroundTasks
    func registerBackgroundTasks () {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier,
                                        using: nil) { [weak self] task in
            print("BackgroundAppRefreshTaskScheduler is executed NOW!")
            
            task.expirationHandler = {
                task.setTaskCompleted(success: false)
            }
            
            self?.sendRequest { response in
                UserDefaults.standard.set("trigged", forKey: "backgroundTask")
                task.setTaskCompleted(success: true)
            }
        }

    }
    
    func submitBackgroundTasks() {
        /// any time as a second -- below for 1 minute
        let timeDelay = 60.0
        
        do {
            let backgroundAppRefreshTaskRequest = BGAppRefreshTaskRequest(identifier: backgroundAppRefreshTaskSchedulerIdentifier)
            backgroundAppRefreshTaskRequest.earliestBeginDate = Date(timeIntervalSinceNow: timeDelay)
            
            try BGTaskScheduler.shared.submit(backgroundAppRefreshTaskRequest)
            
            print("Submitted task request")
        } catch {
            print("Failed to submit BGTask")
        }
    }
    
    func sendRequest (completion: @escaping (Bool) -> Void) {
        if let url = URL(string: "http://185.233.35.24:8192/") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let session = URLSession(configuration: .default)
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                } else {
                    completion(true)
                }
            }.resume()
        }
    }

}

