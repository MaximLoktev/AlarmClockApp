//
//  EditAlarmClockPresenter.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 07.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

internal protocol EditAlarmClockPresentationLogic {
    func presentLoad(response: EditAlarmClockDataFlow.Load.Response)
    func presentChangeTitleAlarm(response: EditAlarmClockDataFlow.ChangeTitleAlarm.Response)
    func presentChangeDateAlarm(response: EditAlarmClockDataFlow.ChangeDateAlarm.Response)
    func presentSaveAlarmClock(response: EditAlarmClockDataFlow.SaveAlarmClock.Response)
}

internal class EditAlarmClockPresenter: EditAlarmClockPresentationLogic {

    // MARK: - Properties
    
    weak var viewController: EditAlarmClockControllerLogic?

    // MARK: - EditAlarmClockPresentationLogic

    func presentLoad(response: EditAlarmClockDataFlow.Load.Response) {
        let viewModel = EditAlarmClockDataFlow.Load.ViewModel(alarmModel: response.alarmModel)
        viewController?.displayLoad(viewModel: viewModel)
    }
    
    func presentChangeTitleAlarm(response: EditAlarmClockDataFlow.ChangeTitleAlarm.Response) {
        let viewModel = EditAlarmClockDataFlow.ChangeTitleAlarm.ViewModel()
        viewController?.displayChangeTitleAlarm(viewModel: viewModel)
    }
    
    func presentChangeDateAlarm(response: EditAlarmClockDataFlow.ChangeDateAlarm.Response) {
        let viewModel = EditAlarmClockDataFlow.ChangeDateAlarm.ViewModel()
        viewController?.displayChangeDateAlarm(viewModel: viewModel)
    }
    
    func presentSaveAlarmClock(response: EditAlarmClockDataFlow.SaveAlarmClock.Response) {
        let viewModel: EditAlarmClockDataFlow.SaveAlarmClock.ViewModel
        
        switch response {
        case .success:
            viewModel = .success
        case .failure:
            viewModel = .failure(title: "Ошибка", description: "Не удалось сохранить данные")
        }
        viewController?.displaySaveAlarmClock(viewModel: viewModel)
    }
}
