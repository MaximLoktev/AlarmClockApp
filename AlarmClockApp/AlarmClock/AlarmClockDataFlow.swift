//
//  AlarmClockDataFlow.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

internal enum AlarmClockDataFlow {
    
    enum Load {

        struct Request { }
        
        enum Response {
            case success(alarms: [AlarmModel])
            case failure(APIError)
        }
        
        enum ViewModel {
            case success(alarms: [AlarmModel])
            case failure(title: String, description: String)
        }
        
    }
    
    enum Delete {

        struct Request {
            let alarmId: String
        }
        
        enum Response {
            case success
            case failure(APIError)
        }
        
        enum ViewModel {
            case success
            case failure(title: String, description: String)
        }
    }
    
    enum EnabledAlarm {

        struct Request {
            let enabled: Bool
            let alarmModel: AlarmModel?
        }
        
        enum Response {
            case success([AlarmModel])
            case failure(APIError)
        }
        
        enum ViewModel {
            case success([AlarmModel])
            case failure(title: String, description: String)
        }
    }
    
}
