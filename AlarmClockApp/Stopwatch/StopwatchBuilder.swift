//
//  StopwatchBuilder.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 14.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol StopwatchBuildable {
    func build(withModuleOutput output: StopwatchModuleOutput) -> UIViewController & StopwatchModuleInput
}

internal protocol StopwatchDependency {

}

internal class StopwatchBuilder: StopwatchBuildable {

    // MARK: - Properties
    
    // MARK: - Init

    // MARK: - StopwatchBuildable
    
    func build(withModuleOutput output: StopwatchModuleOutput) -> UIViewController & StopwatchModuleInput {
        let viewController = StopwatchViewController()
        viewController.moduleOutput = output
        
        return viewController
    }

}
