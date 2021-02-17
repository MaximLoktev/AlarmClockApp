//
//  RootViewController.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import UIKit

protocol RootModuleOutput: class {
    
}

protocol RootModuleInput: class {
    
}

protocol RootBuilders {
    var alarmClock: AlarmClockBuildable { get }
    var addAlarmClock: AddAlarmClockBuildable { get }
    var editAlarmClock: EditAlarmClockBuildable { get }
}

struct BuildersContainer: RootBuilders, AlarmClockBuilders {
    
    let builders: RootBuilders
    
    init(builders: RootBuilders) {
        self.builders = builders
    }

    var alarmClock: AlarmClockBuildable {
        builders.alarmClock
    }
    
    var addAlarmClock: AddAlarmClockBuildable {
        builders.addAlarmClock
    }
    
    var editAlarmClock: EditAlarmClockBuildable {
        builders.editAlarmClock
    }
}

class RootViewController: UITabBarController {
    
    // MARK: - Properties
    
    private let appDependency: RootDependency
    
    private var alarmClockCoordinator: AlarmClockCoordinator?
    
    private var stopwatchCoordinator: StopwatchCoordinator?
    
    private let builders: RootBuilders
    
    // MARK: - Init
    
    init(appDependency: RootDependency, builders: RootBuilders) {
        self.appDependency = appDependency
        self.builders = builders
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLoading()
    }
    
    // MARK: - RootControllerLogic
    
    private func startLoading() {
        let alarmClockViewController = startAlarmClockCoordinator()
        alarmClockViewController.tabBarItem = UITabBarItem.simpleIconItem(title: "Будильник", image:  UIImage(systemName: "clock") ?? UIImage(), tag: 0)
        
        let stopwatchViewController = startStopwatchCoordinator()
        stopwatchViewController.tabBarItem = UITabBarItem.simpleIconItem(title: "Секундомер", image: UIImage(systemName: "stopwatch") ?? UIImage(), tag: 1)
        
        setViewControllers([alarmClockViewController, stopwatchViewController], animated: true)
    }
    
    private func startAlarmClockCoordinator() -> UINavigationController {
        let navigationController = UINavigationController()
        
        alarmClockCoordinator = AlarmClockCoordinator(navigationController: navigationController,
                                                      alarmCoreDataService: appDependency.alarmCoreDataService,
                                                      notificationService: appDependency.notificationService,
                                                      builders: BuildersContainer(builders: builders))
        alarmClockCoordinator?.start()
        
        return navigationController
    }
    
    private func startStopwatchCoordinator() -> UINavigationController {
        let navigationController = UINavigationController()
        
        stopwatchCoordinator = StopwatchCoordinator(navigationController: navigationController)
        stopwatchCoordinator?.start()
        
        return navigationController
    }
    
}
