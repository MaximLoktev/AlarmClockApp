//
//  AddAlarmClockPresenter.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

internal protocol AddAlarmClockPresentationLogic {
    func presentLoad(response: AddAlarmClockDataFlow.Load.Response)
    func presentChangeTitleAlarm(response: AddAlarmClockDataFlow.ChangeTitleAlarm.Response)
    func presentChangeDateAlarm(response: AddAlarmClockDataFlow.ChangeDateAlarm.Response)
    func presentSaveAlarmClock(response: AddAlarmClockDataFlow.SaveAlarmClock.Response)
}

internal class AddAlarmClockPresenter: AddAlarmClockPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: AddAlarmClockControllerLogic?

    // MARK: - AddAlarmClockPresentationLogic

    func presentLoad(response: AddAlarmClockDataFlow.Load.Response) {
        let viewModel = AddAlarmClockDataFlow.Load.ViewModel()
        viewController?.displayLoad(viewModel: viewModel)
    }

    func presentChangeTitleAlarm(response: AddAlarmClockDataFlow.ChangeTitleAlarm.Response) {
        let viewModel = AddAlarmClockDataFlow.ChangeTitleAlarm.ViewModel()
        viewController?.displayChangeTitleAlarm(viewModel: viewModel)
    }
    
    func presentChangeDateAlarm(response: AddAlarmClockDataFlow.ChangeDateAlarm.Response) {
        let viewModel = AddAlarmClockDataFlow.ChangeDateAlarm.ViewModel()
        viewController?.displayChangeDateAlarm(viewModel: viewModel)
    }
    
    func presentSaveAlarmClock(response: AddAlarmClockDataFlow.SaveAlarmClock.Response) {
        let viewModel: AddAlarmClockDataFlow.SaveAlarmClock.ViewModel
        
        switch response {
        case .success(let alarm):
            viewModel = .success(alarm: alarm)
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось сохранить данные")
        }
        viewController?.displaySaveAlarmClock(viewModel: viewModel)
    }
    
}
