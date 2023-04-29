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
    var titleSettingConfig = ["Name", "Icon", "Sex", "Age", "YearsPlayed", "Height", "Width", "Grip", "Backhand"]
    var infoSettingConfig = [EDUser.user.name, "", EDUser.user.sex.rawValue, "\(EDUser.user.age)", "\(EDUser.user.yearsPlayed)", "\(EDUser.user.height)", "\(EDUser.user.width)", EDUser.user.grip.rawValue, EDUser.user.backhand.rawValue]
    let infoVC = EDSignUpViewController()

    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(updateUserInfo)), animated: true)
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
        let pngData = Data(base64Encoded: EDUser.user.icon)
        infoVC.setUserInfo(name: EDUser.user.name, icon: pngData ?? Data(), sex: EDUser.user.sex, age: EDUser.user.age, yearsPlayed: EDUser.user.yearsPlayed, height: EDUser.user.height, width: EDUser.user.width, grip: EDUser.user.grip, backhand: EDUser.user.backhand)
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
        let sheetCtrl = UIAlertController(title: "Cancel changes", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        sheetCtrl.addAction(action)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            sheetCtrl.dismiss(animated: true)
        }
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = view
        sheetCtrl.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.width / 2 - 144, y: view.bounds.height / 2 - 69, width: 288, height: 138)
        present(sheetCtrl, animated: true, completion: nil)
    }

    @objc func updateUserInfo() {
        let sheetCtrl = UIAlertController(title: "Save changes", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
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

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            sheetCtrl.dismiss(animated: true)
        }
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = view
        sheetCtrl.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.width / 2 - 144, y: view.bounds.height / 2 - 69, width: 288, height: 138)
        present(sheetCtrl, animated: true, completion: nil)
    }
}
