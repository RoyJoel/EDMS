//
//  AccountViewController.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2022/12/26.
//

import Foundation
import SwiftyJSON
import TMComponent
import UIKit

class AccountViewController: EDViewController {
    lazy var settingView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gearshape")
        return imageView
    }()

    lazy var clockInBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    lazy var iconView: TMIconView = {
        let iconView = TMIconView()
        return iconView
    }()

    lazy var userOrderView: TMButton = {
        let view = TMButton()
        return view
    }()

    lazy var userExpressOrderView: TMButton = {
        let view = TMButton()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(settingView)
        view.addSubview(clockInBtn)
        view.addSubview(iconView)
        view.addSubview(userOrderView)
        view.addSubview(userExpressOrderView)

        iconView.setupUI()
        let iconConfig = TMIconViewConfig(icon: EDUser.user.icon.toPng(), name: EDUser.user.name)
        iconView.setupEvent(config: iconConfig)
        settingView.tintColor = UIColor(named: "ContentBackground")
        settingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(58)
            make.left.equalToSuperview().offset(44)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        clockInBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(58)
            make.width.equalTo(108)
            make.height.equalTo(40)
        }
        userOrderView.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(24)
            make.height.equalTo(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(138)
        }
        userExpressOrderView.snp.makeConstraints { make in
            make.top.equalTo(userOrderView.snp.bottom).offset(24)
            make.height.equalTo(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(138)
        }
        iconView.snp.makeConstraints { make in
            make.top.equalTo(settingView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(164)
            make.height.equalTo(240)
        }
        settingView.isUserInteractionEnabled = true
        settingView.addTapGesture(self, #selector(settingViewUp))
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(ToastNotification.DataFreshToast.rawValue), object: nil)
        let userOrderConfig = TMButtonConfig(title: "View All Orders", action: #selector(viewAllOrders), actionTarget: self)
        userOrderView.setUp(with: userOrderConfig)

        let userEOrderConfig = TMButtonConfig(title: "View All Expresses", action: #selector(viewAllExpresses), actionTarget: self)
        userExpressOrderView.setUp(with: userEOrderConfig)

        clockInBtn.setTitle("打卡", for: .normal)
        clockInBtn.setTitleColor(UIColor(named: "ContentBackground"), for: .normal)
        clockInBtn.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        clockInBtn.tintColor = UIColor(named: "ContentBackground")
        clockInBtn.setCorner(radii: 10)
        clockInBtn.backgroundColor = UIColor(named: "ComponentBackground")
    }

    @objc func settingViewUp() {
        let vc = EDSettingViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navigationController?.present(navVC, animated: true)
    }

    @objc func refreshData() {
        let iconConfig = TMIconViewConfig(icon: EDUser.user.icon.toPng(), name: EDUser.user.name)
        iconView.setupEvent(config: iconConfig)
    }

    @objc func viewAllGames() {
        let vc = EDUserAllHistoryGamesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func viewAllExpresses() {
        let vc = EDUserOrdersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func viewAllOrders() {
        let vc = EDUserOrdersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
