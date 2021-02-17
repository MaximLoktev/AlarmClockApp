//
//  Locale+Extension.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//

import Foundation

extension Locale {
    
    static var firstPreferredLocale: Locale {
        let languageId = Locale.preferredLanguages.first ?? ""
        return Locale(identifier: languageId)
    }
}
