//
//  InputTextField.swift
//  AlarmClockApp
//
//  Created by Максим Локтев on 08.02.2021.
//

import UIKit

class InputTextField: InsetTextField {
    
    // MARK: - Properties
    
    private let containerView: InputView = InputView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        font = .systemFont(ofSize: 20.0)
        textColor = .darkGray
        clearButtonMode = .always
        autocorrectionType = .no
        
        containerView.isUserInteractionEnabled = false
        insertSubview(containerView, at: 0)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func makeConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
