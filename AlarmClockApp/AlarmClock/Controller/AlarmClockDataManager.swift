//
//  AlarmClockDataManager.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import UIKit

class AlarmClockDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties

    var alarms: [AlarmModel] = []
    
    var leftBarButtonIsHidden: ((Bool) -> Void)?
    var onDeleteAlarmDidTapped: ((String) -> Void)?
    var onEditAlarmDidTapped: ((AlarmModel) -> Void)?
    var onSwichDidTapped: ((Bool, AlarmModel?) -> Void)?
    
    var isEditing: Bool = false
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if alarms.count.isMultiple(of: 0) {
            tableView.separatorStyle = .none
            leftBarButtonIsHidden?(true)
        } else {
            tableView.separatorStyle = .singleLine
            leftBarButtonIsHidden?(false)
        }
        
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let alarm = alarms[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withClass: AlarmClockCell.self, forIndexPath: indexPath)
        cell.setupCell(alarm: alarm)
        cell.onSwichDidTapped = onSwichDidTapped
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alarm = alarms[indexPath.row]
        
        if editingStyle == .delete {
            alarms.remove(at: indexPath.row)
            
            onDeleteAlarmDidTapped?(alarm.alarmIdentifier)
            
            if alarms.count.isMultiple(of: 0) {
                leftBarButtonIsHidden?(true)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alarm = alarms[indexPath.row]
        
        if isEditing {
            onEditAlarmDidTapped?(alarm)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75.0
    }
}
