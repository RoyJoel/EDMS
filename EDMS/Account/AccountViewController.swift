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

    lazy var basicInfoView: EDUserInfoView = {
        let infoView = EDUserInfoView()
        return infoView
    }()

    lazy var userOrderView: EDUserOrdersView = {
        let view = EDUserOrdersView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(settingView)
        view.addSubview(clockInBtn)
        view.addSubview(iconView)
        view.addSubview(basicInfoView)
        view.addSubview(userOrderView)

        iconView.setupUI()

        basicInfoView.setupUI()
        let iconConfig = TMIconViewConfig(icon: EDUser.user.icon.toPng(), name: EDUser.user.name)
        iconView.setupEvent(config: iconConfig)
        basicInfoView.setupEvent()
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
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-108)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        iconView.snp.makeConstraints { make in
            make.top.equalTo(settingView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(164)
            make.height.equalTo(240)
        }
        basicInfoView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-120)
        }
        settingView.isUserInteractionEnabled = true
        settingView.addTapGesture(self, #selector(settingViewUp))
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(ToastNotification.DataFreshToast.rawValue), object: nil)
        userOrderView.setupUI()

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
        basicInfoView.setupEvent()
    }

    @objc func viewAllGames() {
        let vc = EDUserAllHistoryGamesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
