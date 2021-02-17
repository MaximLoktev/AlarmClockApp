//
//  AlarmClockCell.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 06.02.2021.
//

import UIKit

class AlarmClockCell: UITableViewCell {
    
    // MARK: - Properties
    
    var onSwichDidTapped: ((Bool, AlarmModel?) -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 44.0, weight: .regular)
        label.textColor = .black
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .darkGray
        
        return label
    }()
    
     private let alarmSwitch: UISwitch = {
        let alarmSwitch = UISwitch()
        alarmSwitch.isOn = false
        alarmSwitch.preferredStyle = .sliding
        alarmSwitch.onTintColor = .green
        
        return alarmSwitch
    }()
    
    private var alarmModel: AlarmModel?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        accessoryView = alarmSwitch

        alarmSwitch.addTarget(self, action: #selector(switchTapped(_:)), for: .valueChanged)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    func setupCell(alarm: AlarmModel) {
        alarmModel = alarm
        let text = dateFormatter(date: alarm.date)
        titleLabel.text = text
        descriptionLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
        
        isEnabledCell(enabled: alarmSwitch.isOn)
    }
    
    private func isEnabledCell(enabled: Bool) {
        if enabled {
            backgroundColor = .clear
            titleLabel.alpha = 1.0
            descriptionLabel.alpha = 1.0
        } else {
            backgroundColor = .groupTableViewBackground
            titleLabel.alpha = 0.5
            descriptionLabel.alpha = 0.5
        }
    }
    
    private func dateFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.string(from: date)
    }
    
    // MARK: - Actions
    
    @objc
    private func switchTapped(_ sender: UISwitch) {
        isEnabledCell(enabled: sender.isOn)
        onSwichDidTapped?(sender.isOn, alarmModel)
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-8.0)
            make.left.equalToSuperview().offset(16.0)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(0.0)
            make.left.right.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().offset(-4.0)
        }
    }
}
