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
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "MySession")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()
        
        registerBackgroundTasks()
//        UserDefaults.standard.removeObject(forKey: "backgroundTask")
        
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
                
                task.setTaskCompleted(success: response)
            }
        }

    }
    
    func submitBackgroundTasks() {
        let timeDelay = 10.0
        
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
//        let queryItem = URLQueryItem(name: "time", value: "27-06-2001")
//        var urlComponent = URLComponents(string: "https://alvrdtech.com/api/v1/kanan-test")
//        urlComponent?.queryItems = [queryItem]
//
//        if let url = URL(string: "https://google.com") {
//            let request = URLRequest(url: url)
//
//            let session = URLSession(configuration: .background(withIdentifier: "com.example.fooBackgroundAppRefreshIdentifier"))
//            session.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else {
//                    if let data = data {
//                        print(String(data: data, encoding: .utf8))
//                    }
//                }
//            }.resume()
//        }
        
        let backgroundTask = urlSession.dataTask(with: URL(string: "https://google.com")!) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let data = data {
                    print(String(data: data, encoding: .utf8))
                }
            }
        }
        backgroundTask.resume()
        
        
    }
    
    func application(_ application: UIApplication,
                     handleEventsForBackgroundURLSession identifier: String,
                     completionHandler: @escaping () -> Void) {
            
    }
    

}

