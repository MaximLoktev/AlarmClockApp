//
//  RootBuilder.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import UIKit

internal protocol RootBuildable {
    func build(withModuleOutput output: RootModuleOutput?) -> UITabBarController
}

private struct Builders: RootBuilders {
    var alarmClock: AlarmClockBuildable
    var addAlarmClock: AddAlarmClockBuildable
    var editAlarmClock: EditAlarmClockBuildable
}

internal final class RootBuilder: RootBuildable {
    
    // MARK: - Properties
    
    let dependency: RootDependency
    
    // MARK: - Init
    
    init(dependency: RootDependency) {
        self.dependency = dependency
    }
    
    // MARK: - RootBuildable
    
    func build(withModuleOutput output: RootModuleOutput?) -> UITabBarController {
        let builders = Builders(
            alarmClock: AlarmClockBuilder(alarmCoreDataService: dependency.alarmCoreDataService,
                                          notificationService: dependency.notificationService),
            addAlarmClock: AddAlarmClockBuilder(alarmCoreDataService: dependency.alarmCoreDataService,
                                                notificationService: dependency.notificationService),
            editAlarmClock: EditAlarmClockBuilder(alarmCoreDataService: dependency.alarmCoreDataService,
                                                  notificationService: dependency.notificationService))
        
        
        let viewController = RootViewController(appDependency: dependency, builders: builders)
        return viewController
    }
    
}
