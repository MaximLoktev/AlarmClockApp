//
//  StopwatchCoordinator.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import UIKit

internal class StopwatchCoordinator: NSObject {
    
    // MARK: - Properties
    
    private let navigationController: UINavigationController
    
    private let stopwatchBuilder: StopwatchBuildable = StopwatchBuilder()
    
    // MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        navigationController.setNavigationBarHidden(false, animated: false)
        
        super.init()
        
    }
    
    func start() {
        let viewController = stopwatchBuilder.build(withModuleOutput: self)
        navigationController.setViewControllers([viewController], animated: true)
    }
}

extension StopwatchCoordinator: StopwatchModuleOutput {
    
}
