//
//  AlarmClockInteractor.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

internal protocol AlarmClockBusinessLogic {
    func load(request: AlarmClockDataFlow.Load.Request)
    func delete(request: AlarmClockDataFlow.Delete.Request)
    func enableAlarm(request: AlarmClockDataFlow.EnabledAlarm.Request)
}

internal class AlarmClockInteractor: AlarmClockBusinessLogic {

    // MARK: - Properties

    var presenter: AlarmClockPresentationLogic?
    
    private let alarmCoreDataService: AlarmCoreDataService
    
    private let notificationService: NotificationService
    
    private var alarmsModel: [AlarmModel] = []
    
    // MARK: - Init
    
    init(alarmCoreDataService: AlarmCoreDataService, notificationService: NotificationService) {
        self.alarmCoreDataService = alarmCoreDataService
        self.notificationService = notificationService
    }
    
    // MARK: - AlarmClockBusinessLogic

    func load(request: AlarmClockDataFlow.Load.Request) {
        alarmCoreDataService.fetchAlarms { [weak self] result in
            let response: AlarmClockDataFlow.Load.Response
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let alarms):
                self.alarmsModel = alarms
                response = .success(alarms: alarms)
            case .failure(let error):
                response = .failure(error)
            }
            self.presenter?.presentLoad(response: response)
        }
    }
    
    func delete(request: AlarmClockDataFlow.Delete.Request) {
        alarmCoreDataService.deleteAlarm(alarmIdentifier: request.alarmId) { [weak self] result in
            let response: AlarmClockDataFlow.Delete.Response
            
            switch result {
            case .success:
                self?.notificationService.deleteNotifications(identifier: request.alarmId)
                response = .success
            case .failure(let error):
                response = .failure(error)
            }
            self?.presenter?.presentDelete(response: response)
        }
    }
    
    func enableAlarm(request: AlarmClockDataFlow.EnabledAlarm.Request) {
        guard var model = request.alarmModel else {
            return
        }
        
        model.enabled = request.enabled
    
        alarmCoreDataService.updateAlarm(model: model) { [weak self] result in
            var response: AlarmClockDataFlow.EnabledAlarm.Response!
            
            switch result {
            case .success:
                self?.enabledNotification(model: model)
                self?.alarmCoreDataService.fetchAlarms { result in
                    switch result {
                    case .success(let alarms):
                        response = .success(alarms)
                    case .failure(let error):
                        response = .failure(error)
                    }
                }
            case .failure(let error):
                response = .failure(error)
            }
            
            self?.presenter?.presentEnabledAlarm(response: response)
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
