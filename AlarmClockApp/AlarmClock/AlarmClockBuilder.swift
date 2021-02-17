//
//  AlarmClockBuilder.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol AlarmClockBuildable {
    func build(withModuleOutput output: AlarmClockModuleOutput) -> UIViewController & AlarmClockModuleInput
}

internal protocol AlarmClockDependency {

}

internal class AlarmClockBuilder: AlarmClockBuildable {

    // MARK: - Properties

    private let alarmCoreDataService: AlarmCoreDataService
    
    private let notificationService: NotificationService

    // MARK: - Init

    init(alarmCoreDataService: AlarmCoreDataService, notificationService: NotificationService) {
        self.alarmCoreDataService = alarmCoreDataService
        self.notificationService = notificationService
    }

    // MARK: - AlarmClockBuildable
    
    func build(withModuleOutput output: AlarmClockModuleOutput) -> UIViewController & AlarmClockModuleInput {
        let viewController = AlarmClockViewController()
        let interactor = AlarmClockInteractor(alarmCoreDataService: alarmCoreDataService,
                                              notificationService: notificationService)
        let presenter = AlarmClockPresenter()
        viewController.interactor = interactor
        viewController.moduleOutput = output
        interactor.presenter = presenter
        presenter.viewController = viewController
        return viewController
    }

}
