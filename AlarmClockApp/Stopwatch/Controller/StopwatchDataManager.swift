//
//  StopwatchDataManager.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 15.02.2021.
//

import UIKit

class StopwatchDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var lapsModel: [LapModel] = []
    
    private let reuseIdentifier: String = "Cell"
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lapsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        lapsModel.reverse()
        let lap = lapsModel[indexPath.row]
        lapsModel.reverse()
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = "Круг " + lap.title
        cell.detailTextLabel?.text = lap.detail
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        44.0
    }
}

