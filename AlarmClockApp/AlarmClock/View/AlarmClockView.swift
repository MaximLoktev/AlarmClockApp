//
//  AlarmClockView.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

internal protocol AlarmClockViewDelegate: class {

}

internal class AlarmClockView: UIView {

    // MARK: - Properties

    weak var delegate: AlarmClockViewDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.allowsSelectionDuringEditing = true
        tableView.tableFooterView = UIView()
        tableView.register(cellClass: AlarmClockCell.self)
        
        return tableView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    func setupLoad(viewModel: AlarmClockDataFlow.Load.ViewModel) {
    }
        
    func setupDataManager(dataManager: UITableViewDelegate & UITableViewDataSource) {
        tableView.delegate = dataManager
        tableView.dataSource = dataManager
        tableView.reloadData()
    }
    
    func setupIsEditingTable() {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
