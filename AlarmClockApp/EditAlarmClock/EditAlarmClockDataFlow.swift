//
//  EditAlarmClockDataFlow.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 07.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

internal enum EditAlarmClockDataFlow {
    
    enum Load {

        struct Request { }

        struct Response {
            let alarmModel: AlarmModel
        }

        struct ViewModel {
            let alarmModel: AlarmModel
        }
        
    }
    
    enum ChangeTitleAlarm {

        struct Request {
            let text: String
        }

        struct Response { }

        struct ViewModel { }
        
    }
    
    enum ChangeDateAlarm {

        struct Request {
            let date: Date
        }

        struct Response { }

        struct ViewModel { }
        
    }
    
    enum SaveAlarmClock {

        struct Request { }

        enum Response {
            case success
            case failure(APIError)
        }
        
        enum ViewModel {
            case success
            case failure(title: String, description: String)
        }
        
    }
    
}
