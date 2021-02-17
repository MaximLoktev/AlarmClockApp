//
//  UITabBarItem+Extensions.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import UIKit

extension UITabBarItem {
    
    static func simpleIconItem(title: String?, image: UIImage, tag: Int) -> UITabBarItem {
        
        let tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        tabBarItem.imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -12.0, right: 0.0)
        
        return tabBarItem
    }
}
