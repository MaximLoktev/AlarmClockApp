//
//  AddAlarmClockView.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

internal protocol AddAlarmClockViewDelegate: class {
    func viewDidChangeTitle(text: String)
    func viewDidChangeDatePicker(date: Date)
}

internal class AddAlarmClockView: UIView, UITextFieldDelegate {

    // MARK: - Properties

    weak var delegate: AddAlarmClockViewDelegate?
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ru_RU")
        
        return datePicker
    }()
    
    private let titleTextField = InputTextField()
    
    private let textFieldInputValidator: TextFieldInputValidator = AlphanumericsValidator()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(datePicker)
        addSubview(titleTextField)
        
        titleTextField.placeholder = "Название"
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        
        datePicker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        addGestureRecognizer(tapGesture)
        
        makeConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup

    func setupLoad(viewModel: AddAlarmClockDataFlow.Load.ViewModel) {

    }
    
    // MARK: - Actions
    
    @objc
    private func titleTextFieldDidChange(_ sender: UITextField) {
        delegate?.viewDidChangeTitle(text: sender.text ?? "Будильник")
    }
    
    @objc
    private func datePickerDidChange(_ sender: UIDatePicker) {
        delegate?.viewDidChangeDatePicker(date: sender.date)
    }
    
    @objc
    private func didTapView(gesture: UITapGestureRecognizer) {
        endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
        
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        return textFieldInputValidator.shouldChangeCharacters(of: textField.text ?? "",
                                                              in: range,
                                                              replacementText: string)
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        datePicker.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.left.right.equalToSuperview().inset(16.0)
        }
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(44.0)
            make.top.equalTo(datePicker.snp.bottom).offset(16.0)
            make.left.right.equalToSuperview().inset(16.0)
        }
    }
}
