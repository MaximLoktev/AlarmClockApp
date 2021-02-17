//
//  StopwatchViewController.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 14.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol StopwatchModuleOutput: class {

}

internal protocol StopwatchModuleInput: class {

}

internal class StopwatchViewController: UIViewController, StopwatchModuleInput, StopwatchViewDelegate {

    // MARK: - Properties

    weak var moduleOutput: StopwatchModuleOutput?

    var moduleView: StopwatchView!
    
    private let dataManager = StopwatchDataManager()
    
    private var timer: Timer?
    // Интервал времени старта таймера
    private var startTimeInterval: TimeInterval?
    // Общее время до остановки таймера
    private var saveTimeInterval: TimeInterval = 0
    // Время круга до остановки таймера
    private var saveLapTimeInterval: TimeInterval = 0
    // Интервал времени старта круга
    private var startLapTimeInterval: TimeInterval = 0
    
    private var indexLap = 0

    // MARK: - View life cycle

    override func loadView() {
        moduleView = StopwatchView(frame: UIScreen.main.bounds)
        moduleView.delegate = self
        view = moduleView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        moduleView.setupDataManager(dataManager: dataManager)
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - StopwatchViewDelegate
    
    func viewDidTappedStart() {
        moduleView.setupButton(state: .stop)
        startTimer()
    }
    
    func viewDidTappedStop() {
        moduleView.setupButton(state: .start)
        stopTimer()
    }
    
    func viewDidTappedReset() {
        resetTimer()
        moduleView.setupTimerLabel(text: timeString(from: 0))
        moduleView.setupButton(state: .start)
        
        dataManager.lapsModel.removeAll()
        moduleView.reloadTableView()
    }
    
    func viewDidTappedLap() {
        let lapTimeInterval = lapTimer()
        let text = timeString(from: lapTimeInterval)
        let lapModel = makeLapModel(indexLap: indexLap, detail: text)
        
        dataManager.lapsModel.append(lapModel)
        moduleView.reloadTableView()
    }
    
    // MARK: - StopwatchViewControllerLogic
    
    private func startTimer() {
        if startTimeInterval == nil {
            startTimeInterval = Date().timeIntervalSince1970
        }
        
        if startLapTimeInterval.isEqual(to: 0) {
            startLapTimeInterval = Date().timeIntervalSince1970
        }
        
        startLapTimeInterval -= saveLapTimeInterval
        
        timer = Timer.scheduledTimer(timeInterval: 0.01,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    private func stopTimer() {
        // Сохранение последнего интервала
        if let startTimeInterval = startTimeInterval {
            let currentTimeInterval = Date().timeIntervalSince1970
            saveTimeInterval += currentTimeInterval - startTimeInterval
            saveLapTimeInterval = currentTimeInterval - startLapTimeInterval
        }
        
        timer?.invalidate()
        timer = nil
        startTimeInterval = nil
        startLapTimeInterval = 0
    }
    
    private func resetTimer() {
        indexLap = 0
        saveTimeInterval = 0
        startLapTimeInterval = 0
        saveLapTimeInterval = 0
    }
    
    private func lapTimer() -> TimeInterval {
        let currentTimeInterval = Date().timeIntervalSince1970
        let lapTimeInterval = currentTimeInterval - startLapTimeInterval
        startLapTimeInterval = currentTimeInterval
        saveLapTimeInterval = 0
        indexLap += 1
        
        return lapTimeInterval
    }
    
    // MARK: - Actions
    
    @objc
    private func updateTimer() {
        let currentTimeInterval = Date().timeIntervalSince1970
        let start_Time_Interval = startTimeInterval ?? currentTimeInterval
        let time = saveTimeInterval + (currentTimeInterval - start_Time_Interval)
        
        moduleView.setupTimerLabel(text: timeString(from: time))
    }
    
    // MARK: - SettingsNavigation
    
    private func setupNavigationController() {
        navigationItem.title = "Секундомер"
        let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
    }
    
    private func makeLapModel(indexLap: Int, detail: String) -> LapModel {
        LapModel(title: String(indexLap), detail: detail)
    }
    
    // MARK: - StringFormatter
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let milliseconds = Int(timeInterval.truncatingRemainder(dividingBy: 1) * 100)
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        
        return String(format: "%.2d:%.2d.%.2d", minutes, seconds, milliseconds)
    }
}
