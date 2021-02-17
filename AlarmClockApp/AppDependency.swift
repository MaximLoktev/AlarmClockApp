//
//  AppDependency.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import Foundation

protocol RootDependency {
    var coreData: CoreData { get }
    var alarmCoreDataService: AlarmCoreDataService { get }
    var notificationService: NotificationService { get }
    var authenticationService: AuthenticationService { get }
}

class AppDependency: RootDependency {
    
    private(set) lazy var coreData = CoreData()
    
    private(set) lazy var alarmCoreDataService: AlarmCoreDataService = AlarmCoreDataServiceImpl(
        coreData: coreData)
    
    private(set) lazy var notificationService: NotificationService = NotificationServiceImpl()
    
    private(set) lazy var authenticationService: AuthenticationService = AuthenticationServiceImpl()
}
