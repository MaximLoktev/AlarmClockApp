//
//  AppDelegate.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import UIKit
import LocalAuthentication

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let appDependency: RootDependency = AppDependency()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController = RootBuilder(dependency: appDependency).build(withModuleOutput: nil)
        rootViewController.overrideUserInterfaceStyle = .light
        
        let window = UIWindow()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        self.window = window
        
        appDependency.authenticationService.authWithTouchID()
        appDependency.notificationService.userRequest()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

}
