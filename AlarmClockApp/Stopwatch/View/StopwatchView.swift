//
//  StopwatchView.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 14.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol StopwatchViewDelegate: class {
    func viewDidTappedStart()
    func viewDidTappedStop()
    func viewDidTappedReset()
    func viewDidTappedLap()
}

internal class StopwatchView: UIView {

    // MARK: - Properties

    enum State {
        case start
        case stop
    }
    
    weak var delegate: StopwatchViewDelegate?
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 80)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "00:00.00"
        
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 50.0
        button.setTitleColor(.sexyBlack, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        button.backgroundColor = .customYellow
        
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 50.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        button.setTitleColor(.sexyBlack, for: .normal)
        
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.allowsSelectionDuringEditing = true
        
        return tableView
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(timerLabel)
        addSubview(leftButton)
        addSubview(rightButton)
        addSubview(tableView)
        
        setupButton(state: .start)
        
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupTimerLabel(text: String) {
        timerLabel.text = text
    }
    
    func setupButton(state: State) {
        rightButton.removeTarget(nil, action: nil, for: .allEvents)
        leftButton.removeTarget(nil, action: nil, for: .allEvents)
        
        switch state {
        case .start:
            rightButton.setTitle("Старт", for: .normal)
            rightButton.backgroundColor = .customGreen
            rightButton.addTarget(self, action: #selector(startButtonAction), for: .touchUpInside)
            
            leftButton.setTitle("Сброс", for: .normal)
            leftButton.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
            
        case .stop:
            rightButton.setTitle("Стоп", for: .normal)
            rightButton.backgroundColor = .customRed
            rightButton.addTarget(self, action: #selector(stopButtonAction), for: .touchUpInside)
            
            leftButton.setTitle("Круг", for: .normal)
            leftButton.addTarget(self, action: #selector(lapButtonAction), for: .touchUpInside)
        }
    }
    
    // MARK: - SettingsTableView
    
    func setupDataManager(dataManager: UITableViewDelegate & UITableViewDataSource) {
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
        reloadTableView()
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc
    private func startButtonAction() {
        delegate?.viewDidTappedStart()
    }
    
    @objc
    private func resetButtonAction() {
        delegate?.viewDidTappedReset()
    }
    
    @objc
    private func stopButtonAction() {
        delegate?.viewDidTappedStop()
    }
    
    @objc
    private func lapButtonAction() {
        delegate?.viewDidTappedLap()
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        timerLabel.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.3)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.0)
            make.left.right.equalToSuperview()
        }
        leftButton.snp.makeConstraints { make in
            make.height.width.equalTo(100.0)
            make.top.equalTo(timerLabel.snp.bottom)
            make.left.equalToSuperview().offset(32.0)
        }
        rightButton.snp.makeConstraints { make in
            make.height.width.equalTo(100.0)
            make.top.equalTo(timerLabel.snp.bottom)
            make.right.equalToSuperview().offset(-32.0)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(leftButton.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
