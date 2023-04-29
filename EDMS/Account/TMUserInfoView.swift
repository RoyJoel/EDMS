//
//  EDUserInfoView.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/3/10.
//

import Foundation
import TMComponent
import UIKit

class EDUserInfoView: TMView {
    lazy var yearsPlayTMView: TMInfoView = {
        let infoView = TMInfoView()
        return infoView
    }()

    lazy var heightView: TMInfoView = {
        let infoView = TMInfoView()
        return infoView
    }()

    lazy var widthView: TMInfoView = {
        let infoView = TMInfoView()
        return infoView
    }()

    lazy var gripView: TMInfoView = {
        let infoView = TMInfoView()
        return infoView
    }()

    lazy var backhandView: TMInfoView = {
        let infoView = TMInfoView()
        return infoView
    }()

    lazy var pointsView: TMInfoView = {
        let infoView = TMInfoView()
        return infoView
    }()

    func setupUI() {
        setCorner(radii: 20)

        addSubview(yearsPlayTMView)
        addSubview(heightView)
        addSubview(widthView)
        addSubview(gripView)
        addSubview(backhandView)
        addSubview(pointsView)

        yearsPlayTMView.backgroundColor = .white
        heightView.backgroundColor = .white
        widthView.backgroundColor = .white
        gripView.backgroundColor = .white
        backhandView.backgroundColor = .white
        pointsView.backgroundColor = .white

        yearsPlayTMView.setCorner(radii: 15)
        heightView.setCorner(radii: 15)
        widthView.setCorner(radii: 15)
        gripView.setCorner(radii: 15)
        backhandView.setCorner(radii: 15)
        pointsView.setCorner(radii: 15)

        yearsPlayTMView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(42)
            make.width.equalTo(170)
            make.height.equalTo(100)
        }

        heightView.snp.makeConstraints { make in
            make.top.equalTo(yearsPlayTMView.snp.top)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(100)
        }

        widthView.snp.makeConstraints { make in
            make.top.equalTo(yearsPlayTMView.snp.top)
            make.right.equalToSuperview().offset(-42)
            make.width.equalTo(170)
            make.height.equalTo(100)
        }

        gripView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-24)
            make.left.equalTo(yearsPlayTMView.snp.left)
            make.width.equalTo(170)
            make.height.equalTo(100)
        }

        backhandView.snp.makeConstraints { make in
            make.bottom.equalTo(gripView.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(100)
        }

        pointsView.snp.makeConstraints { make in
            make.bottom.equalTo(gripView.snp.bottom)
            make.right.equalTo(widthView.snp.right)
            make.width.equalTo(170)
            make.height.equalTo(100)
        }

        yearsPlayTMView.setupUI()
        heightView.setupUI()
        widthView.setupUI()
        gripView.setupUI()
        backhandView.setupUI()
        pointsView.setupUI()
    }

    func setupEvent() {
        let yearPlayedConfig = TMInfoViewConfig(infoContent: "\(EDUser.user.yearsPlayed)", infoContentFont: 20, infoTitle: NSLocalizedString("YearsPlayed", comment: ""), infoTitleFont: 17, inset: 24)
        let heightConfig = TMInfoViewConfig(infoContent: "\(EDUser.user.height)", infoContentFont: 20, infoTitle: NSLocalizedString("Height", comment: ""), infoTitleFont: 17, inset: 24)
        let widthConfig = TMInfoViewConfig(infoContent: "\(EDUser.user.width)", infoContentFont: 20, infoTitle: NSLocalizedString("Width", comment: ""), infoTitleFont: 17, inset: 24)
        let gripConfig = TMInfoViewConfig(infoContent: NSLocalizedString(EDUser.user.grip.rawValue, comment: ""), infoContentFont: 20, infoTitle: NSLocalizedString("Grip", comment: ""), infoTitleFont: 17, inset: 24)
        let backhandConfig = TMInfoViewConfig(infoContent: NSLocalizedString(EDUser.user.backhand.rawValue, comment: ""), infoContentFont: 17, infoTitle: NSLocalizedString("Backhand", comment: ""), infoTitleFont: 17, inset: 24)
        let pointsConfig = TMInfoViewConfig(infoContent: "\(EDUser.user.points)", infoContentFont: 20, infoTitle: NSLocalizedString("Current Points", comment: ""), infoTitleFont: 17, inset: 24)

        yearsPlayTMView.setupEvent(config: yearPlayedConfig)
        heightView.setupEvent(config: heightConfig)
        widthView.setupEvent(config: widthConfig)
        gripView.setupEvent(config: gripConfig)
        backhandView.setupEvent(config: backhandConfig)
        pointsView.setupEvent(config: pointsConfig)
    }
}
