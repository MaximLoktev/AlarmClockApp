//
//  AddAlarmClockDataFlow.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

internal enum AddAlarmClockDataFlow {
    
    enum Load {

        struct Request { }

        struct Response { }

        struct ViewModel { }
        
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
            case success(alarm: AlarmModel)
            case failure(APIError)
        }
        
        enum ViewModel {
            case success(alarm: AlarmModel)
            case failure(title: String, description: String)
        }
        
    }
}
