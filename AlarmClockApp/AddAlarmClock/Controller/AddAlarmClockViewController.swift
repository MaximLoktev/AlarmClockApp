//
//  AddAlarmClockViewController.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol AddAlarmClockControllerLogic: class {
    func displayLoad(viewModel: AddAlarmClockDataFlow.Load.ViewModel)
    func displayChangeTitleAlarm(viewModel: AddAlarmClockDataFlow.ChangeTitleAlarm.ViewModel)
    func displayChangeDateAlarm(viewModel: AddAlarmClockDataFlow.ChangeDateAlarm.ViewModel)
    func displaySaveAlarmClock(viewModel: AddAlarmClockDataFlow.SaveAlarmClock.ViewModel)
}

internal protocol AddAlarmClockModuleOutput: class {
    func addAlarmClockModuleDidBack()
}

internal protocol AddAlarmClockModuleInput: class {

}

internal class AddAlarmClockViewController: UIViewController,
                                            AddAlarmClockControllerLogic, AddAlarmClockModuleInput, AddAlarmClockViewDelegate {

    // MARK: - Properties

    var interactor: AddAlarmClockBusinessLogic?

    weak var moduleOutput: AddAlarmClockModuleOutput?

    var moduleView: AddAlarmClockView!

    // MARK: - View life cycle

    override func loadView() {
        moduleView = AddAlarmClockView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        startLoading()
    }

    // MARK: - AddAlarmClockControllerLogic

    private func startLoading() {
        let request = AddAlarmClockDataFlow.Load.Request()
        interactor?.load(request: request)
    }

    func displayLoad(viewModel: AddAlarmClockDataFlow.Load.ViewModel) {
        moduleView.setupLoad(viewModel: viewModel)
    }
    
    func displayChangeTitleAlarm(viewModel: AddAlarmClockDataFlow.ChangeTitleAlarm.ViewModel) {
        
    }
    
    func displayChangeDateAlarm(viewModel: AddAlarmClockDataFlow.ChangeDateAlarm.ViewModel) {
        
    }
    
    func displaySaveAlarmClock(viewModel: AddAlarmClockDataFlow.SaveAlarmClock.ViewModel) {
        switch viewModel {
        case .success:
            moduleOutput?.addAlarmClockModuleDidBack()
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    // MARK: - AddAlarmClockViewDelegate
    
    func viewDidChangeTitle(text: String) {
        let request = AddAlarmClockDataFlow.ChangeTitleAlarm.Request(text: text)
        interactor?.changeTitleAlarm(request: request)
    }
    
    func viewDidChangeDatePicker(date: Date) {
        let request = AddAlarmClockDataFlow.ChangeDateAlarm.Request(date: date)
        interactor?.changeDateAlarm(request: request)
    }
    
    // MARK: - SettingsNavigation
    
    private func setupNavigationController() {
        navigationItem.title = "Создание"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        createdBarButton()
    }
    
    private func createdBarButton() {
        let saveBarButtonItem = UIBarButtonItem.saveBarButton(target: self, action: #selector(saveButtonAction))
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        let backBarButtonItem = UIBarButtonItem.backBarButton(target: self, action: #selector(backButtonAction))
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    // MARK: - Actions
    
    @objc
    private func saveButtonAction () {
        let request = AddAlarmClockDataFlow.SaveAlarmClock.Request()
        interactor?.saveAlarmClock(request: request)
    }
    
    @objc
    private func backButtonAction () {
        moduleOutput?.addAlarmClockModuleDidBack()
    }

}
