//
//  EDSettingViewController.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/3/30.
//

import Foundation
import TMComponent
import UIKit

class EDSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var settingConfig = ["Appearance": [AppearanceSetting.Light.userDisplayName, AppearanceSetting.Dark.userDisplayName, AppearanceSetting.UnSpecified.userDisplayName], "Info": [""]]
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    lazy var signOutBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundGray")
        navigationController?.navigationBar.tintColor = UIColor(named: "ContentBackground")
        view.addSubview(tableView)
        view.addSubview(signOutBtn)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(signOutBtn.snp.top).offset(-5)
        }
        signOutBtn.snp.makeConstraints { make in
            make.width.equalTo(108)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }
        tableView.backgroundColor = UIColor(named: "BackgroundGray")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EDsettingTableViewCell.self, forCellReuseIdentifier: "EDsettingTableViewCell")
        let signOutBtnConfig = TMButtonConfig(title: "登出", action: #selector(signOut), actionTarget: self)
        signOutBtn.setupUI()
        signOutBtn.setupEvent(config: signOutBtnConfig)
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = EDSettingIconCell()
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            return cell
        } else if indexPath.row == 1 {
            let cell = EDsettingTableViewCell()
            cell.setupEvent(title: "显示模式", info: UserDefaults.standard.string(forKey: "AppleAppearance") ?? "跟随系统")
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = EDsettingTableViewCell()
            cell.setupEvent(title: "个人信息", info: "")
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! EDsettingTableViewCell
        if indexPath.row < 2 {
            let vc = EDSettingSelectionViewController()
            vc.title = cell.titleView.text
            let configs = ["Appearance"]
            vc.dataSource = settingConfig[configs[indexPath.row - 1]] ?? []
            vc.completionHandler = { result in
                if indexPath.row == 1 {
                    cell.setupEvent(title: "显示模式", info: result)
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = EDSettingInfoViewController()
            vc.isModalInPresentation = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 362
        } else {
            return 98
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        3
    }

    @objc func signOut() {
        let sheetCtrl = UIAlertController(title: "退出登录", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "确定", style: .default) { _ in
            if let window = self.signOutBtn.window {
                UserDefaults.standard.set(nil, forKey: EDUDKeys.JSONWebToken.rawValue)
                UserDefaults.standard.set(nil, forKey: EDUDKeys.UserInfo.rawValue)
                window.rootViewController = EDSignInViewController()
            }
            self.navigationController?.popViewController(animated: true)
        }
        sheetCtrl.addAction(action)

        let cancelAction = UIAlertAction(title: "取消", style: .default) { _ in
            sheetCtrl.dismiss(animated: true)
        }
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = view
        sheetCtrl.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.width / 2 - 144, y: view.bounds.height / 2 - 69, width: 288, height: 138)
        present(sheetCtrl, animated: true, completion: nil)
    }
}
