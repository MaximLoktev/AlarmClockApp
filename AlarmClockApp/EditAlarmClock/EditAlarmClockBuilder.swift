//
//  EditAlarmClockBuilder.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 07.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol EditAlarmClockBuildable {
    func build(alarmModel: AlarmModel, withModuleOutput output: EditAlarmClockModuleOutput) -> UIViewController & EditAlarmClockModuleInput
}

internal protocol EditAlarmClockDependency {

}

internal class EditAlarmClockBuilder: EditAlarmClockBuildable {

    // MARK: - Properties

    private let alarmCoreDataService: AlarmCoreDataService
    
    private let notificationService: NotificationService

    // MARK: - Init

    init(alarmCoreDataService: AlarmCoreDataService, notificationService: NotificationService) {
        self.alarmCoreDataService = alarmCoreDataService
        self.notificationService = notificationService
    }

    // MARK: - EditAlarmClockBuildable
    
    func build(alarmModel: AlarmModel, withModuleOutput output: EditAlarmClockModuleOutput) -> UIViewController & EditAlarmClockModuleInput {
        let viewController = EditAlarmClockViewController()
        let interactor = EditAlarmClockInteractor(alarmCoreDataService: alarmCoreDataService,
                                                  notificationService: notificationService,
                                                  alarmModel: alarmModel)
        let presenter = EditAlarmClockPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
