//
//  AlarmModel.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import Foundation

struct AlarmModel {
    var date: Date = Date()
    var enabled: Bool = true
    var alarmIdentifier: String = ""
    var name: String? = "Будильник"
}
