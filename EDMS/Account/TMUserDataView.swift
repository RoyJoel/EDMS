//
//  EDUserDataView.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/3/10.
//

import Foundation
import JXSegmentedView
import TMComponent

class EDUserDataView: TMView {
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentTMView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    lazy var gameStatsView: EDUserActivityView = {
        let view = EDUserActivityView()
        return view
    }()

    lazy var careerStatsView: EDUserStatsView = {
        let view = EDUserStatsView()
        return view
    }()

    func setupUI() {
        setCorner(radii: 20)
        let titles = [NSLocalizedString("ACTIVITY", comment: ""), NSLocalizedString("STATS", comment: "")]

        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titleNormalColor = UIColor(named: "ContentBackground") ?? .black
        dataSource.titleSelectedColor = .black
        dataSource.titles = titles
        segmentedDataSource = dataSource
        // 配置指示器
        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 30
        indicator.indicatorColor = UIColor(named: "TennisBlur") ?? .blue
        segmentTMView.indicators = [indicator]

        segmentTMView.dataSource = segmentedDataSource
        segmentTMView.delegate = self
        segmentTMView.listContainer = listContainerView
        addSubview(segmentTMView)
        addSubview(listContainerView)
        gameStatsView.setupUI()
        careerStatsView.setupUI()

        segmentTMView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentTMView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    func setupEventForGameStatsView(games: [Game]) {
        gameStatsView.setupEvent(games: games)
    }

    func setupEventForCareerStatsView() {
        careerStatsView.setupEvent(stats: EDUser.user.careerStats)
    }
}

extension EDUserDataView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentTMView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt: Int) -> JXSegmentedListContainerViewListDelegate {
        if initListAt == 0 {
            return gameStatsView
        }
        return careerStatsView
    }
}

extension EDUserDataView: JXSegmentedViewDelegate {
    func segmentedView(_ segmentTMView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            // 先更新数据源的数据

            dotDataSource.dotStates[index] = false
            // 再调用reloadItem(at: index)
            segmentTMView.reloadItem(at: index)
        }
    }
}
