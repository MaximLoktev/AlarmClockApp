//
//  AddAlarmClockInteractor.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UserNotifications

internal protocol AddAlarmClockBusinessLogic {
    func load(request: AddAlarmClockDataFlow.Load.Request)
    func changeTitleAlarm(request: AddAlarmClockDataFlow.ChangeTitleAlarm.Request)
    func changeDateAlarm(request: AddAlarmClockDataFlow.ChangeDateAlarm.Request)
    func saveAlarmClock(request: AddAlarmClockDataFlow.SaveAlarmClock.Request)
}

internal class AddAlarmClockInteractor: AddAlarmClockBusinessLogic {

    // MARK: - Properties

    var presenter: AddAlarmClockPresentationLogic?
    
    private var alarmModel = AlarmModel()
    
    private let alarmCoreDataService: AlarmCoreDataService
    
    private let notificationService: NotificationService
    
    // MARK: - Init
    
    init(alarmCoreDataService: AlarmCoreDataService,
         notificationService: NotificationService) {
        self.alarmCoreDataService = alarmCoreDataService
        self.notificationService = notificationService
    }
    
    // MARK: - AddAlarmClockBusinessLogic

    func load(request: AddAlarmClockDataFlow.Load.Request) {
        let response = AddAlarmClockDataFlow.Load.Response()
        presenter?.presentLoad(response: response)
    }

    func changeTitleAlarm(request: AddAlarmClockDataFlow.ChangeTitleAlarm.Request) {
        alarmModel.name = request.text
        let response = AddAlarmClockDataFlow.ChangeTitleAlarm.Response()
        presenter?.presentChangeTitleAlarm(response: response)
    }
    
    func changeDateAlarm(request: AddAlarmClockDataFlow.ChangeDateAlarm.Request) {
        alarmModel.date = request.date
        let response = AddAlarmClockDataFlow.ChangeDateAlarm.Response()
        presenter?.presentChangeDateAlarm(response: response)
    }
    
    func saveAlarmClock(request: AddAlarmClockDataFlow.SaveAlarmClock.Request) {
        let alarmIdentifier: String = UUID().uuidString
        alarmModel.alarmIdentifier = alarmIdentifier
        
        alarmCoreDataService.createAlarm(model: alarmModel) { [weak self] result in
            let response: AddAlarmClockDataFlow.SaveAlarmClock.Response
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let alarm):
                response = .success(alarm: alarm)
                self.notificationService.scheduleNotification(title: alarm.alarmIdentifier,
                                                              date: alarm.date)
            case .failure(let error):
                response = .failure(error)
            }
            self.presenter?.presentSaveAlarmClock(response: response)
        }
    }
    
}
