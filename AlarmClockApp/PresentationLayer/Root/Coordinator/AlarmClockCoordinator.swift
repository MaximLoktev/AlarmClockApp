//
//  AlarmClockCoordinator.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import UIKit

protocol AlarmClockBuilders {
    var alarmClock: AlarmClockBuildable { get }
    var addAlarmClock: AddAlarmClockBuildable { get }
    var editAlarmClock: EditAlarmClockBuildable { get }
}

internal class AlarmClockCoordinator: NSObject {
    
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    
    private let alarmCoreDataService: AlarmCoreDataService
    
    private let notificationService: NotificationService
    
    private let builders: AlarmClockBuilders
    
    // MARK: - Init
    
    init(navigationController: UINavigationController,
         alarmCoreDataService: AlarmCoreDataService,
         notificationService: NotificationService,
         builders: AlarmClockBuilders) {
        self.navigationController = navigationController
        self.alarmCoreDataService = alarmCoreDataService
        self.notificationService = notificationService
        self.builders = builders
        
        navigationController.setNavigationBarHidden(false, animated: false)
        
        super.init()
    }
    
    func start() {
        let viewController = builders.alarmClock.build(withModuleOutput: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension AlarmClockCoordinator: AlarmClockModuleOutput {
    
    func alarmClockDidShowAddAlarm() {
        let viewController = builders.addAlarmClock.build(withModuleOutput: self)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func alarmClockDidShowEditAlarm(alarm: AlarmModel) {
        let viewController = builders.editAlarmClock.build(alarmModel: alarm, withModuleOutput: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AlarmClockCoordinator: EditAlarmClockModuleOutput {
    func editAlarmClockModuleDidBack() {
        navigationController.popViewController(animated: true)
    }
}

extension AlarmClockCoordinator: AddAlarmClockModuleOutput {
    
    func addAlarmClockModuleDidBack() {
        navigationController.popViewController(animated: true)
    }
}
