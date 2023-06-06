//
//  EDResetPasswordViewController.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/4/5.
//

import LocalAuthentication
import TMComponent
import UIKit

class EDResetPasswordViewController: UIViewController, UITextFieldDelegate {
    lazy var accountLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var accountTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()

    lazy var resetLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var resetTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()

    lazy var confirmLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var confirmTextField: EDTextField = {
        let textField = EDTextField()
        return textField
    }()

    lazy var reauthBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var submitBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(named: "ContentBackground")
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(accountLabel)
        view.addSubview(accountTextField)
        view.addSubview(resetLabel)
        view.addSubview(resetTextField)
        view.addSubview(confirmLabel)
        view.addSubview(confirmTextField)
        view.addSubview(reauthBtn)
        view.addSubview(submitBtn)

        accountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.equalToSuperview().offset(48)
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        accountTextField.snp.makeConstraints { make in
            make.top.equalTo(accountLabel.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        resetLabel.snp.makeConstraints { make in
            make.top.equalTo(accountTextField.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        resetTextField.snp.makeConstraints { make in
            make.top.equalTo(resetLabel.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        confirmLabel.snp.makeConstraints { make in
            make.top.equalTo(resetTextField.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        confirmTextField.snp.makeConstraints { make in
            make.top.equalTo(confirmLabel.snp.bottom).offset(12)
            make.left.equalTo(accountLabel.snp.left)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        submitBtn.snp.makeConstraints { make in
            make.top.equalTo(confirmTextField.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(138)
            make.height.equalTo(50)
        }
        reauthBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(288)
            make.height.equalTo(50)
        }
        let reauthBtnConfig = TMButtonConfig(title: "Verification failed, tap to try again", action: #selector(authenticateUserTapped), actionTarget: self)
        reauthBtn.setUp(with: reauthBtnConfig)
        accountLabel.text = NSLocalizedString("账号", comment: "")
        let accountTFConfig = EDTextFieldConfig(placeholderText: "Enter account")
        accountTextField.setup(with: accountTFConfig)
        resetLabel.text = NSLocalizedString("新密码", comment: "")
        let resetTFConfig = EDTextFieldConfig(placeholderText: "Reset Password")
        resetTextField.setup(with: resetTFConfig)
        confirmLabel.text = NSLocalizedString("确认密码", comment: "")
        let confirmTFConfig = EDTextFieldConfig(placeholderText: "Confirm Password")
        confirmTextField.setup(with: confirmTFConfig)
        let submitBtnConfig = TMButtonConfig(title: "提交", action: #selector(submitPassword), actionTarget: self)
        submitBtn.setUp(with: submitBtnConfig)

        accountLabel.isHidden = true
        accountTextField.isHidden = true
        resetLabel.isHidden = true
        resetTextField.isHidden = true
        confirmLabel.isHidden = true
        confirmTextField.isHidden = true
        submitBtn.isHidden = true
        reauthBtn.isHidden = true

        authUser()

        accountTextField.textField.delegate = self
        resetTextField.textField.delegate = self
        confirmTextField.textField.delegate = self
    }

    @objc func submitPassword() {
        let loggedinUsers = (UserDefaults.standard.array(forKey: EDUDKeys.loggedinUser.rawValue) as? [String] ?? [])
        if let account = accountTextField.textField.text {
            if loggedinUsers.contains(where: { loginName in
                loginName == account
            }) {
                if let password = resetTextField.textField.text, password == confirmTextField.textField.text {
                    EDUser.user.loginName = account
                    EDUser.user.password = password
                    EDUser.resetPassword { _ in
                    }
                } else {
                    let toastView = UILabel()
                    toastView.text = NSLocalizedString("两次输入的密码不正确", comment: "")
                    toastView.numberOfLines = 2
                    toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                    toastView.backgroundColor = UIColor(named: "ComponentBackground")
                    toastView.textAlignment = .center
                    toastView.setCorner(radii: 15)
                    view.showToast(toastView, position: .center)
                }
            } else {
                let toastView = UILabel()
                toastView.text = NSLocalizedString("您未曾在此设备上成功登陆过该账号", comment: "")
                toastView.numberOfLines = 2
                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                toastView.textAlignment = .center
                toastView.setCorner(radii: 15)
                view.showToast(toastView, position: .center)
            }
        }
    }

    @objc func authenticateUserTapped() {
        authUser()
    }

    func authUser() {
        let context = LAContext()
        var error: NSError?

        // 判断设备是否支持Face ID
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 如果支持，调起Face ID验证
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "使用Face ID验证身份") {
                [weak self] success, _ in
                guard success else {
                    // 如果验证失败，处理错误信息
                    DispatchQueue.main.async {
                        self?.accountLabel.isHidden = true
                        self?.accountTextField.isHidden = true
                        self?.resetLabel.isHidden = true
                        self?.resetTextField.isHidden = true
                        self?.confirmLabel.isHidden = true
                        self?.confirmTextField.isHidden = true
                        self?.reauthBtn.isHidden = false
                    }
                    return
                }

                // 如果验证成功，执行其他操作
                DispatchQueue.main.async {
                    self?.accountLabel.isHidden = false
                    self?.accountTextField.isHidden = false
                    self?.resetLabel.isHidden = false
                    self?.resetTextField.isHidden = false
                    self?.confirmLabel.isHidden = false
                    self?.confirmTextField.isHidden = false
                    self?.submitBtn.isHidden = false
                    self?.reauthBtn.isHidden = true
                }
            }
        } else {
            // 判断设备是否支持Touch ID
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // 如果支持，调起Touch ID验证
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "使用Touch ID验证身份") {
                    [weak self] success, _ in
                    guard success else {
                        // 如果验证失败，处理错误信息
                        DispatchQueue.main.async {
                            self?.accountLabel.isHidden = true
                            self?.accountTextField.isHidden = true
                            self?.resetLabel.isHidden = true
                            self?.resetTextField.isHidden = true
                            self?.confirmLabel.isHidden = true
                            self?.confirmTextField.isHidden = true
                            self?.submitBtn.isHidden = true
                            self?.reauthBtn.isHidden = false
                        }
                        return
                    }

                    // 如果验证成功，执行其他操作
                    DispatchQueue.main.async {
                        self?.accountLabel.isHidden = false
                        self?.accountTextField.isHidden = false
                        self?.resetLabel.isHidden = false
                        self?.resetTextField.isHidden = false
                        self?.confirmLabel.isHidden = false
                        self?.confirmTextField.isHidden = false
                        self?.submitBtn.isHidden = false
                        self?.reauthBtn.isHidden = true
                    }
                }
            } else {
                // 如果不支持Touch ID，显示错误信息
                let ac = UIAlertController(title: "设备无法找回密码", message: error?.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "确定", style: .default))
                present(ac, animated: true)
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
