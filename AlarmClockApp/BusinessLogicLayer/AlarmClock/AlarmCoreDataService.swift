//
//  AlarmCoreDataService.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//

import UIKit

protocol AlarmCoreDataService {
    func createAlarm(model: AlarmModel, completion: @escaping (Result<AlarmModel, APIError>) -> Void)
    func fetchAlarms(completion: @escaping (Result<[AlarmModel], APIError>) -> Void)
    func updateAlarm(model: AlarmModel, completion: @escaping (Result<Void, APIError>) -> Void)
    func deleteAlarm(alarmIdentifier: String, completion: @escaping (Result<Void, APIError>) -> Void)
}

final class AlarmCoreDataServiceImpl: AlarmCoreDataService {
    
    // MARK: - Properties
    
    private let coreData: CoreData
    
    // MARK: - Init
    
    init(coreData: CoreData) {
        self.coreData = coreData
    }
    
    // MARK: - Actions
    
    func createAlarm(model: AlarmModel, completion: @escaping (Result<AlarmModel, APIError>) -> Void) {
        let newAlarm = Alarm(context: self.coreData.context)
        newAlarm.date = model.date
        newAlarm.alarmIdentifier = model.alarmIdentifier
        newAlarm.enabled = model.enabled
        newAlarm.name = model.name
        
        do {
            try self.coreData.context.save()
            completion(.success(model))
        } catch {
            completion(.failure(.createCoreDataObjectError(error)))
        }
    }
    
    func fetchAlarms(completion: @escaping (Result<[AlarmModel], APIError>) -> Void) {
        coreData.fetchObjects(entity: Alarm.self, context: coreData.context) { result in
            switch result {
            case .success(let alarms):
                let alarmsModel = mapAlarmsModel(entity: alarms)
                completion(.success(alarmsModel))
            case .failure(let error):
                completion(.failure(.fetchCoreDataObjectError(error)))
            }
        }
    }
    
    private func mapAlarmsModel(entity: [Alarm]) -> [AlarmModel] {
        let alarmsModel: [AlarmModel] = entity.map { alarm in
            AlarmModel(
                date: alarm.date ?? Date(),
                enabled: alarm.enabled,
                alarmIdentifier: alarm.alarmIdentifier ?? "",
                name: alarm.name
            )
        }
        return alarmsModel
    }
    
    func updateAlarm(model: AlarmModel, completion: @escaping (Result<Void, APIError>) -> Void) {
        let predicate = NSPredicate(format: "alarmIdentifier == %@", model.alarmIdentifier)
        coreData.fetchObject(entity: Alarm.self, predicate: predicate, context: coreData.context) { result in
            switch result {
            case .success(let alarm):
                alarm.date = model.date
                alarm.alarmIdentifier = model.alarmIdentifier
                alarm.enabled = model.enabled
                alarm.name = model.name
                
                do {
                    try self.coreData.context.save()
                    completion(.success(()))
                } catch {
                    completion(.failure(.createCoreDataObjectError(error)))
                }
                
            case .failure(let error):
                completion(.failure(.updateCoreDataObjectError(error)))
            }
        }
    }
    
    func deleteAlarm(alarmIdentifier: String, completion: @escaping (Result<Void, APIError>) -> Void) {
        let predicate = NSPredicate(format: "alarmIdentifier == %@", alarmIdentifier)
        coreData.fetchObject(entity: Alarm.self, predicate: predicate, context: coreData.context) { result in
            switch result {
            case .success(let alarm):
                coreData.delete([alarm], in: coreData.context) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(.deleteCoreDataObjectsError(error)))
                    }
                }
            case .failure(let error):
                completion(.failure(.fetchCoreDataObjectError(error)))
            }
        }
    }
}
