//
//  UIColor+Extensions.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//

import UIKit

extension UIColor {
    
    static let sexyBlack: UIColor = UIColor(red: 51.0 / 255.0,
                                            green: 51.0 / 255.0,
                                            blue: 51.0 / 255.0,
                                            alpha: 1.0)
    static let darkGrey50: UIColor = UIColor(red: 44.0 / 255.0,
                                             green: 44.0 / 255.0,
                                             blue: 46.0 / 255.0,
                                             alpha: 0.5)
}

extension UIColor {
    
    class var customGreen: UIColor {
        return UIColor(named: "GreenColor")!
    }
    
    class var customYellow: UIColor {
        return UIColor(named: "YellowColor")!
    }
    
    class var customRed: UIColor {
        return UIColor(named: "RedColor")!
    }
}
