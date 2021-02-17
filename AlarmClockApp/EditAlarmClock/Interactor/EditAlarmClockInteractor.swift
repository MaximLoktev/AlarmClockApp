//
//  EditAlarmClockInteractor.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 07.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

internal protocol EditAlarmClockBusinessLogic {
    func load(request: EditAlarmClockDataFlow.Load.Request)
    func changeTitleAlarm(request: EditAlarmClockDataFlow.ChangeTitleAlarm.Request)
    func changeDateAlarm(request: EditAlarmClockDataFlow.ChangeDateAlarm.Request)
    func saveAlarmClock(request: EditAlarmClockDataFlow.SaveAlarmClock.Request)
}

internal class EditAlarmClockInteractor: EditAlarmClockBusinessLogic {

    // MARK: - Properties

    var presenter: EditAlarmClockPresentationLogic?
    
    private var alarmModel: AlarmModel
    
    private let alarmCoreDataService: AlarmCoreDataService
    
    private let notificationService: NotificationService
    
    // MARK: - Init
    
    init(alarmCoreDataService: AlarmCoreDataService,
         notificationService: NotificationService, alarmModel: AlarmModel) {
        self.alarmCoreDataService = alarmCoreDataService
        self.notificationService = notificationService
        self.alarmModel = alarmModel
    }
    
    // MARK: - EditAlarmClockBusinessLogic

    func load(request: EditAlarmClockDataFlow.Load.Request) {
        let response = EditAlarmClockDataFlow.Load.Response(alarmModel: alarmModel)
        presenter?.presentLoad(response: response)
    }
    
    func changeTitleAlarm(request: EditAlarmClockDataFlow.ChangeTitleAlarm.Request) {
        alarmModel.name = request.text
        let response = EditAlarmClockDataFlow.ChangeTitleAlarm.Response()
        presenter?.presentChangeTitleAlarm(response: response)
    }
    
    func changeDateAlarm(request: EditAlarmClockDataFlow.ChangeDateAlarm.Request) {
        alarmModel.date = request.date
        let response = EditAlarmClockDataFlow.ChangeDateAlarm.Response()
        presenter?.presentChangeDateAlarm(response: response)
    }
    
    func saveAlarmClock(request: EditAlarmClockDataFlow.SaveAlarmClock.Request) {
        alarmCoreDataService.updateAlarm(model: alarmModel) { [weak self] result in
            let response: EditAlarmClockDataFlow.SaveAlarmClock.Response
            guard let self = self else { return }
            
            switch result {
            case .success:
                response = .success
                self.enabledNotification(model: self.alarmModel)
            case .failure(let error):
                response = .failure(error)
            }
            self.presenter?.presentSaveAlarmClock(response: response)
        }
    }
    
    private func enabledNotification(model: AlarmModel) {
        if model.enabled {
            notificationService.scheduleNotification(title: model.alarmIdentifier,
                                                     date: model.date)
        } else {
            notificationService.deleteNotifications(identifier: model.alarmIdentifier)
        }
    }
}
