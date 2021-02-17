//
//  APIError.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 09.02.2021.
//

import Foundation

internal enum APIError: Error {
    case writingDataObjectError(Error)
    case readingCoreDataObjectError(Error)
    
    case createCoreDataObjectError(Error)
    case fetchCoreDataObjectError(Error)
    case deleteCoreDataObjectsError(Error)
    case updateCoreDataObjectError(Error)
    
    case faildExtractOptionalValue
}
