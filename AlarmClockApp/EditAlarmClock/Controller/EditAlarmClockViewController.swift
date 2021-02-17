//
//  EditAlarmClockViewController.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 07.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol EditAlarmClockControllerLogic: class {
    func displayLoad(viewModel: EditAlarmClockDataFlow.Load.ViewModel)
    func displayChangeTitleAlarm(viewModel: EditAlarmClockDataFlow.ChangeTitleAlarm.ViewModel)
    func displayChangeDateAlarm(viewModel: EditAlarmClockDataFlow.ChangeDateAlarm.ViewModel)
    func displaySaveAlarmClock(viewModel: EditAlarmClockDataFlow.SaveAlarmClock.ViewModel)
}

internal protocol EditAlarmClockModuleOutput: class {
    func editAlarmClockModuleDidBack()
}

internal protocol EditAlarmClockModuleInput: class {

}

internal class EditAlarmClockViewController: UIViewController,
    EditAlarmClockControllerLogic, EditAlarmClockModuleInput, EditAlarmClockViewDelegate {

    // MARK: - Properties

    var interactor: EditAlarmClockBusinessLogic?

    weak var moduleOutput: EditAlarmClockModuleOutput?

    var moduleView: EditAlarmClockView!
    
    // MARK: - View life cycle
    
    override func loadView() {
        moduleView = EditAlarmClockView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        startLoading()
    }

    // MARK: - EditAlarmClockControllerLogic

    private func startLoading() {
        let request = EditAlarmClockDataFlow.Load.Request()
        interactor?.load(request: request)
    }

    func displayLoad(viewModel: EditAlarmClockDataFlow.Load.ViewModel) {
        moduleView.setupLoad(viewModel: viewModel)
    }
    
    func displayChangeTitleAlarm(viewModel: EditAlarmClockDataFlow.ChangeTitleAlarm.ViewModel) {
    
    }
    
    func displayChangeDateAlarm(viewModel: EditAlarmClockDataFlow.ChangeDateAlarm.ViewModel) {
        
    }
    
    func displaySaveAlarmClock(viewModel: EditAlarmClockDataFlow.SaveAlarmClock.ViewModel) {
        switch viewModel {
        case .success:
            moduleOutput?.editAlarmClockModuleDidBack()
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    // MARK: - AddAlarmClockViewDelegate
    
    func viewDidChangeTitle(text: String) {
        let request = EditAlarmClockDataFlow.ChangeTitleAlarm.Request(text: text)
        interactor?.changeTitleAlarm(request: request)
    }
    
    func viewDidChangeDatePicker(date: Date) {
        let request = EditAlarmClockDataFlow.ChangeDateAlarm.Request(date: date)
        interactor?.changeDateAlarm(request: request)
    }
    
    // MARK: - SettingsNavigation
    
    private func setupNavigationController() {
        navigationItem.title = "Редактирование"
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
        let request = EditAlarmClockDataFlow.SaveAlarmClock.Request()
        interactor?.saveAlarmClock(request: request)
    }
    
    @objc
    private func backButtonAction () {
        moduleOutput?.editAlarmClockModuleDidBack()
    }
}
