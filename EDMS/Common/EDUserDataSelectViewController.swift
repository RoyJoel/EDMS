//
//  EDUserDataSelectViewController.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/4/12.
//

import Foundation
import UIKit

class EDUserDataSelectViewController: UIViewController {
    var localUserInfo: User = User()
    var netUserInfo: User = User()

    lazy var titleView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var localDataLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var netDataLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var localDataView: EDGameView = {
        let view = EDGameView()
        return view
    }()

    lazy var netDataView: EDGameView = {
        let view = EDGameView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(named: "ContentBackground")
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(titleView)
        view.addSubview(localDataLabel)
        view.addSubview(netDataLabel)
        view.addSubview(localDataView)
        view.addSubview(netDataView)

        titleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-24)
            make.height.equalTo(48)
        }
        localDataLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.height.equalTo(40)
            make.width.equalTo(288)
        }
        localDataView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(localDataLabel.snp.bottom).offset(12)
            make.height.equalTo(288)
        }
        netDataLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalTo(netDataView.snp.top).offset(-12)
            make.height.equalTo(40)
            make.width.equalTo(288)
        }
        netDataView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(288)
        }

        titleView.text = NSLocalizedString("Choose Your Account", comment: "")
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 32)
        localDataLabel.text = NSLocalizedString("Local Recent Game", comment: "")
        netDataLabel.text = NSLocalizedString("Online Recent Game", comment: "")
        localDataLabel.font = UIFont.systemFont(ofSize: 25)
        netDataLabel.font = UIFont.systemFont(ofSize: 25)

//        localDataView.setupUI()
//        netDataView.setupUI()
//        if localUserInfo.allUnfinishedGames.count != 0 {
//            localDataView.setupEvent(game: localUserInfo.allUnfinishedGames[localUserInfo.allUnfinishedGames.count - 1])
//        } else {
//            localDataView.setupAlart()
//        }
//        if netUserInfo.allUnfinishedGames.count != 0 {
//            netDataView.setupEvent(game: netUserInfo.allUnfinishedGames[netUserInfo.allUnfinishedGames.count - 1])
//        } else {
//            netDataView.setupAlart()
//        }

        localDataView.addTapGesture(self, #selector(confirmUser(_:)))
        netDataView.addTapGesture(self, #selector(confirmUser(_:)))
    }

    @objc func confirmUser(_ sender: UIGestureRecognizer) {
        if let view = sender.view {
            if view == localDataView {
                EDUser.user = localUserInfo
            } else if view == netDataView {
                EDUser.user = netUserInfo
            }
            EDUser.updateInfo { user in
                guard let user = user else {
                    return
                }
                let userInfo = try? PropertyListEncoder().encode(user)
                UserDefaults.standard.set(userInfo, forKey: EDUDKeys.UserInfo.rawValue)
                UserDefaults.standard.set(user.token, forKey: EDUDKeys.JSONWebToken.rawValue)
                NotificationCenter.default.post(name: Notification.Name(ToastNotification.DataFreshToast.rawValue), object: nil)
                self.dismiss(animated: true)
            }
        }
    }
}
