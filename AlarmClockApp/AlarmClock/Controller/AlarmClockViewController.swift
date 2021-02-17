//
//  AlarmClockViewController.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol AlarmClockControllerLogic: class {
    func displayLoad(viewModel: AlarmClockDataFlow.Load.ViewModel)
    func displayDelete(viewModel: AlarmClockDataFlow.Delete.ViewModel)
    func displayEnabledAlarm(viewModel: AlarmClockDataFlow.EnabledAlarm.ViewModel)
}

internal protocol AlarmClockModuleOutput: class {
    func alarmClockDidShowEditAlarm(alarm: AlarmModel)
    func alarmClockDidShowAddAlarm()
}

internal protocol AlarmClockModuleInput: class {

}

internal class AlarmClockViewController: UIViewController,
    AlarmClockControllerLogic, AlarmClockModuleInput, AlarmClockViewDelegate {

    // MARK: - Properties

    var interactor: AlarmClockBusinessLogic?

    weak var moduleOutput: AlarmClockModuleOutput?

    var moduleView: AlarmClockView!
    
    private let dataManager = AlarmClockDataManager()

    // MARK: - View life cycle

    override func loadView() {
        moduleView = AlarmClockView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupDataManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isEditing {
            isEditing.toggle()
            dataManager.isEditing = isEditing
            moduleView.setupIsEditingTable()
        }
        
        startLoading()
    }
    
    // MARK: - Data manager
    
    private func setupDataManager() {
        dataManager.leftBarButtonIsHidden = { [weak self] isHidden in
            self?.setupEditBarButtonItem(isHidden: isHidden)
        }
        
        dataManager.onEditAlarmDidTapped = { [weak self] alarm in
            self?.moduleOutput?.alarmClockDidShowEditAlarm(alarm: alarm)
        }
        
        dataManager.onDeleteAlarmDidTapped = { [weak self] alarmId in
            let request = AlarmClockDataFlow.Delete.Request(alarmId: alarmId)
            self?.interactor?.delete(request: request)
        }
        
        dataManager.onSwichDidTapped = { [weak self] enabled, alarmModel in
            let request = AlarmClockDataFlow.EnabledAlarm.Request(enabled: enabled,
                                                                  alarmModel: alarmModel)
            self?.interactor?.enableAlarm(request: request)
        }
    }
    
    // MARK: - AlarmClockControllerLogic
    
    private func startLoading() {
        let request = AlarmClockDataFlow.Load.Request()
        interactor?.load(request: request)
    }
    
    func displayLoad(viewModel: AlarmClockDataFlow.Load.ViewModel) {
        switch viewModel {
        case .success(let alarms):
            dataManager.alarms = alarms
            moduleView.setupDataManager(dataManager: dataManager)
            moduleView.setupLoad(viewModel: viewModel)
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    func displayDelete(viewModel: AlarmClockDataFlow.Delete.ViewModel) {
        if case let .failure(title, description) = viewModel {
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    func displayEnabledAlarm(viewModel: AlarmClockDataFlow.EnabledAlarm.ViewModel) {
        switch viewModel {
        case .success(let alarms):
            dataManager.alarms = alarms
        case let .failure(title, description):
            let alert = AlertWindowController.alert(title: title, message: description, cancel: "Ok")
            alert.show()
        }
    }
    
    // MARK: - SettingsNavigation
    
    private func setupEditBarButtonItem(isHidden: Bool) {
        if isHidden {
            navigationItem.leftBarButtonItem = nil
        } else {
            let editDoneBarButtonItem = editButtonItem
            editDoneBarButtonItem.action = #selector(editDoneButtonAction)
            navigationItem.leftBarButtonItem = editDoneBarButtonItem
        }
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Будильники"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        createdBarButton()
    }
    
    private func createdBarButton() {
        setupEditBarButtonItem(isHidden: false)
        
        let addBarButtonItem = UIBarButtonItem.addBarButton(target: self, action: #selector(addButtonAction))
        navigationItem.rightBarButtonItem = addBarButtonItem
    }
    
    // MARK: - Actions
    
    @objc
    private func editDoneButtonAction() {
        isEditing.toggle()
        dataManager.isEditing = isEditing
        moduleView.setupIsEditingTable()
    }
    
    @objc
    private func addButtonAction() {
        moduleOutput?.alarmClockDidShowAddAlarm()
    }

}
