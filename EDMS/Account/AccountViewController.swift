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

    lazy var allHistoryGamesNavBtn: TMButton = {
        let btn = TMButton()
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

    lazy var userOrderView: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var userDataView: EDUserDataView = {
        let dataView = EDUserDataView()
        return dataView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(settingView)
        view.addSubview(allHistoryGamesNavBtn)
        view.addSubview(iconView)
        view.addSubview(basicInfoView)
        view.addSubview(userDataView)
        view.addSubview(userOrderView)

        iconView.setupUI()

        basicInfoView.setupUI()
        let iconConfig = TMIconViewConfig(icon: EDUser.user.icon.toPng(), name: EDUser.user.name)
        iconView.setupEvent(config: iconConfig)
        basicInfoView.setupEvent()
        userDataView.setupUI()
        userDataView.setupEventForCareerStatsView()
        if EDUser.user.allHistoryGames.count != 0 {
            userDataView.setupEventForGameStatsView(games: EDUser.user.allHistoryGames)
        } else {
            userDataView.gameStatsView.setupAlart()
        }
        settingView.tintColor = UIColor(named: "ContentBackground")
        settingView.snp.makeConstraints { make in
            make.top.equalTo(32)
            make.left.equalTo(44)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        allHistoryGamesNavBtn.snp.makeConstraints { make in
            make.left.equalTo(settingView.snp.right).offset(12)
            make.top.equalTo(settingView.snp.top)
            make.width.equalTo(108)
            make.height.equalTo(settingView.snp.height)
        }
        userOrderView.snp.makeConstraints { make in
            make.left.equalTo(allHistoryGamesNavBtn.snp.right).offset(6)
            make.top.equalTo(settingView.snp.top)
            make.height.equalTo(settingView.snp.height)
            make.width.equalTo(88)
        }
        iconView.snp.makeConstraints { make in
            make.top.equalTo(settingView.snp.bottom).offset(24)
            make.left.equalTo(settingView.snp.left).offset(40)
            make.width.equalTo(164)
            make.height.equalTo(240)
        }
        basicInfoView.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(40)
            make.top.equalTo(settingView.snp.top)
            make.right.equalToSuperview().offset(-44)
            make.bottom.equalTo(iconView.snp.bottom)
        }
        userDataView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(44)
            make.right.equalToSuperview().offset(-44)
            make.top.equalTo(iconView.snp.bottom)
            make.bottom.equalToSuperview().offset(-78)
        }
        userDataView.gameStatsView.leftActivityView.addTapGesture(self, #selector(enterLeftDetailStatsView))
        userDataView.gameStatsView.midActivityView.addTapGesture(self, #selector(enterMidDetailStatsView))
        userDataView.gameStatsView.rightActivityView.addTapGesture(self, #selector(enterRightDetailStatsView))
        settingView.isUserInteractionEnabled = true
        settingView.addTapGesture(self, #selector(settingViewUp))
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(ToastNotification.DataFreshToast.rawValue), object: nil)
        let allGamesNavBtnConfig = TMButtonConfig(title: "All Games", action: #selector(viewAllGames), actionTarget: self)
        allHistoryGamesNavBtn.setUp(with: allGamesNavBtnConfig)
        let allOrdersNavBtnConfig = TMButtonConfig(title: "All Orders", action: #selector(viewAllOrders), actionTarget: self)
        userOrderView.setUp(with: allOrdersNavBtnConfig)
    }

    @objc func enterLeftDetailStatsView() {
        let vc = EDGameStatsDetailViewController()
        vc.game = userDataView.gameStatsView.leftActivityView.game ?? Game(json: JSON())
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func enterMidDetailStatsView() {
        let vc = EDGameStatsDetailViewController()
        vc.game = userDataView.gameStatsView.midActivityView.game ?? Game(json: JSON())
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func enterRightDetailStatsView() {
        let vc = EDGameStatsDetailViewController()
        vc.game = userDataView.gameStatsView.rightActivityView.game ?? Game(json: JSON())
        navigationController?.pushViewController(vc, animated: true)
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
        userDataView.setupEventForCareerStatsView()
        userDataView.setupEventForGameStatsView(games: EDUser.user.allHistoryGames)
    }

    @objc func viewAllGames() {
        let vc = EDUserAllHistoryGamesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func viewAllOrders() {
        let vc = EDUserOrdersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
