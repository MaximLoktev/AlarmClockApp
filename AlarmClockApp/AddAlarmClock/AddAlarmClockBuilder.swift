//
//  AddAlarmClockBuilder.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol AddAlarmClockBuildable {
    func build(withModuleOutput output: AddAlarmClockModuleOutput) -> UIViewController & AddAlarmClockModuleInput
}

internal protocol AddAlarmClockDependency {

}

internal class AddAlarmClockBuilder: AddAlarmClockBuildable {

    // MARK: - Properties

    private let alarmCoreDataService: AlarmCoreDataService
    private let notificationService: NotificationService

    // MARK: - Init

    init(alarmCoreDataService: AlarmCoreDataService,
         notificationService: NotificationService) {
        self.alarmCoreDataService = alarmCoreDataService
        self.notificationService = notificationService
    }

    // MARK: - AddAlarmClockBuildable
    
    func build(withModuleOutput output: AddAlarmClockModuleOutput) -> UIViewController & AddAlarmClockModuleInput {
        let viewController = AddAlarmClockViewController()
        let interactor = AddAlarmClockInteractor(alarmCoreDataService: alarmCoreDataService,
                                                 notificationService: notificationService)
        let presenter = AddAlarmClockPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
