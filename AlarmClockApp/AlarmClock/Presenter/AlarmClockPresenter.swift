//
//  AlarmClockPresenter.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

internal protocol AlarmClockPresentationLogic {
    func presentLoad(response: AlarmClockDataFlow.Load.Response)
    func presentDelete(response: AlarmClockDataFlow.Delete.Response)
    func presentEnabledAlarm(response: AlarmClockDataFlow.EnabledAlarm.Response)
}

internal class AlarmClockPresenter: AlarmClockPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: AlarmClockControllerLogic?

    // MARK: - AlarmClockPresentationLogic

    func presentLoad(response: AlarmClockDataFlow.Load.Response) {
        let viewModel: AlarmClockDataFlow.Load.ViewModel
        switch response {
        case .success(let alarms):
            viewModel = .success(alarms: alarms)
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось получить данные")
        }
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentDelete(response: AlarmClockDataFlow.Delete.Response) {
        let viewModel: AlarmClockDataFlow.Delete.ViewModel
        if case .failure = response {
            viewModel = .failure(title: "Ошибка", description: "Не удалось удалить данные")
            viewController?.displayDelete(viewModel: viewModel)
        }
    }
    
    func presentEnabledAlarm(response: AlarmClockDataFlow.EnabledAlarm.Response) {
        let viewModel: AlarmClockDataFlow.EnabledAlarm.ViewModel
        
        switch response {
        case .success(let alarms):
            viewModel = .success(alarms)
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось обновить данные")
        }
        
        viewController?.displayEnabledAlarm(viewModel: viewModel)
    }
}
