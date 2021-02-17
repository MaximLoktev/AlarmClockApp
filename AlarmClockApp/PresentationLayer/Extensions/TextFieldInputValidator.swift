//
//  TextFieldInputValidator.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//

import Foundation

protocol TextFieldInputValidator {
    func shouldChangeCharacters(of originalString: String,
                                in range: NSRange,
                                replacementText text: String) -> Bool
}

struct AlphanumericsValidator: TextFieldInputValidator {
    
    func shouldChangeCharacters(of originalString: String,
                                in range: NSRange,
                                replacementText text: String) -> Bool {
        let alphanumericsCharacterSet = CharacterSet.alphanumerics
        let whitespacesCharacterSet = CharacterSet.whitespaces
        let typedCharacterSet = CharacterSet(charactersIn: text)
        let length = originalString.count + text.count - range.length
        
        return (alphanumericsCharacterSet.isSuperset(of: typedCharacterSet)
                || whitespacesCharacterSet.isSuperset(of: typedCharacterSet)) && length <= 20
    }
}
