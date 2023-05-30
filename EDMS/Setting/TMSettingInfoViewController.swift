//
//  EDSettingInfoViewController.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/4/7.
//

import Foundation
import TMComponent
import UIKit

class EDSettingInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var titleSettingConfig = ["姓名", "头像", "性别"]
    var infoSettingConfig = [EDUser.user.name, "", EDUser.user.sex == .Man ? "男" : "女"]
    let infoVC = EDSignUpViewController()

    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(updateUserInfo)), animated: true)
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.backgroundColor = UIColor(named: "BackgroundGray")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EDsettingTableViewCell.self, forCellReuseIdentifier: "EDsettingTableViewCell")
        infoVC.setUserInfo(name: EDUser.user.name, icon: EDUser.user.icon.toPng(), sex: EDUser.user.sex)
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = EDSettingUserIconCell()
            let indexTitle = titleSettingConfig[indexPath.row]
            let pngData = Data(base64Encoded: EDUser.user.icon)
            cell.setupEvent(title: indexTitle, icon: pngData ?? Data())
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = EDsettingTableViewCell()
            let indexTitle = titleSettingConfig[indexPath.row]
            cell.setupEvent(title: indexTitle, info: infoSettingConfig[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        infoVC.showSubView(tag: indexPath.row + 200)
        infoVC.completionHandler = { result in
            (self.tableView.cellForRow(at: indexPath) as? EDsettingTableViewCell)?.setupEvent(title: self.titleSettingConfig[indexPath.row], info: result)
        }
        infoVC.iconCompletionHandler = { icon in
            (self.tableView.cellForRow(at: indexPath) as? EDSettingUserIconCell)?.setupEvent(title: self.titleSettingConfig[indexPath.row], icon: icon)
        }
        navigationController?.pushViewController(infoVC, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        98
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        titleSettingConfig.count
    }

    @objc func cancel() {
        let sheetCtrl = UIAlertController(title: "取消更改？", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "确定", style: .default) { _ in
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

    @objc func updateUserInfo() {
        let sheetCtrl = UIAlertController(title: "保存修改？", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { _ in
            self.infoVC.getUserInfo()
            let usericonData = EDUser.user.icon
            EDUser.updateInfo { user in
                guard let user = user else {
                    return
                }
                print(usericonData.count == user.icon.count)
                let userInfo = try? PropertyListEncoder().encode(EDUser.user)
                UserDefaults.standard.set(userInfo, forKey: EDUDKeys.UserInfo.rawValue)
                NotificationCenter.default.post(name: Notification.Name(ToastNotification.DataFreshToast.notificationName.rawValue), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
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
