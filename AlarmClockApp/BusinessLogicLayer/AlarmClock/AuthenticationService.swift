//
//  AuthenticationService.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 17.02.2021.
//

import Foundation
import LocalAuthentication

protocol AuthenticationService {
    func authWithTouchID()
}

final class AuthenticationServiceImpl: AuthenticationService {
    
    // MARK: - Properties
    
    private let authenticationContext = LAContext()
    
    private var error: NSError?
    
    private let localizedReason = "Приложите палец, чтобы войти в продолжить"
    
    // MARK: - Actions
    
    func authWithTouchID() {
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: localizedReason)
            { [weak self] _, error in
                guard let self = self,
                      let error = error as NSError?
                else {
                    return
                }
                let message = self.errorMessageForLAErrorCode(errorCode: error.code)
                self.showAlertViewForNoBiometrics(message: message)
            }
        } else {
            showAlertViewForNoBiometrics(message: "Девайс не поддерживает Touch ID")
        }
    }
    
   private func errorMessageForLAErrorCode(errorCode: Int) -> String {
        var message = ""
        
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = "Аутентификация была отменена приложением"
        case LAError.authenticationFailed.rawValue:
            message = "Пользователь не смог предоставить действительные учётные данные"
        case LAError.invalidContext.rawValue:
            message = "Недействительный контекст"
        case LAError.passcodeNotSet.rawValue:
            message = "На устройстве не установлен пароль"
        case LAError.systemCancel.rawValue:
            message = "Аутентификация была отменена системой"
        case LAError.biometryLockout.rawValue:
            message = "Много неудачных попыток"
        case LAError.biometryNotAvailable.rawValue:
            message = "Биометрический вход не доступен на устройстве"
        case LAError.userCancel.rawValue:
            message = "Аутентификация была отменена пользователем"
        case LAError.userFallback.rawValue:
            message = "Пользователь выбрал резервный вариант"
        default:
            message = "Неизвестная ошибка"
        }
        
        return message
    }
    
    private func showAlertViewForNoBiometrics(message: String) {
        DispatchQueue.main.async {
            let alert = AlertWindowController(title: "Ошибка",
                                              message: message,
                                              preferredStyle: .alert)
            alert.show()
        }
    }
}
