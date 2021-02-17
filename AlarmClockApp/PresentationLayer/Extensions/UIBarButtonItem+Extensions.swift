//
//  UIBarButtonItem+Extensions.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 07.02.2021.
//

import UIKit

extension UIBarButtonItem {
    
    static func backBarButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: target, action: action)
        return barButton
    }
    
    static func saveBarButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: target, action: action)
        return barButton
    }
    
    static func editBarButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(barButtonSystemItem: .edit, target: target, action: action)
        return barButton
    }
    
    static func addBarButton(target: Any?, action: Selector) -> UIBarButtonItem {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: target, action: action)
        return barButton
    }
    
    private static func makeBarButton(target: Any?, image: UIImage?, action: Selector) -> UIBarButtonItem {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)

        let barButton = UIBarButtonItem(customView: button)
        let currWidth = barButton.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = barButton.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        
        return barButton
    }
}
