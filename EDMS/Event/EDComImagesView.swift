//
//  EDComImagesView.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/22.
//

import Foundation
import JXSegmentedView
import TMComponent
import UIKit

class EDComImagesView: TMView {
    let segmentedView = JXSegmentedView()
    var intros: [String] = []
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
        backgroundColor = UIColor(named: "BackgroundGray")

        segmentedView.listContainer = listContainerView
        addSubview(listContainerView)
        gameStatsView.setupUI()
        careerStatsView.setupUI()

        listContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

extension EDComImagesView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        intros.count
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt: Int) -> JXSegmentedListContainerViewListDelegate {
        let containerView = EDComIntroContainerView(image: UIImage(named: intros[initListAt]))
        return containerView
    }
}

extension EDComImagesView: JXSegmentedViewDelegate {
    func segmentedView(_: JXSegmentedView, didSelectedItemAt _: Int) {}
}
