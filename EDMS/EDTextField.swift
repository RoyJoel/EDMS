//
//  EDTextField.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/3/2.
//

import Foundation
import UIKit

open class EDTextField: UIView {
    public lazy var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 22)
        return textField
    }()

    public func setup(with config: EDTextFieldConfig) {
        setupUI()
        setupEvent(config: config)
    }

    private func setupUI() {
        backgroundColor = UIColor(named: "TennisBlurTextField")
        setCorner(radii: 15)

        addSubview(textField)

        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
    }

    private func setupEvent(config: EDTextFieldConfig) {
        textField.placeholder = config.placeholderText
        textField.text = config.text
    }
}
