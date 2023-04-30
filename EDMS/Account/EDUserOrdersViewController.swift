//
//  EDUserOrdersViewController.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/29.
//
import Foundation
import JXSegmentedView
import TMComponent

class EDUserOrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var orders: [[Order]] = [ordersa, ordersa]
    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentTMView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    lazy var orderTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        let titles = [NSLocalizedString("All Order", comment: ""), NSLocalizedString("STATS", comment: "")]

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

        view.addSubview(segmentTMView)
        view.addSubview(listContainerView)

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

        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "userOrder")
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        orders[segmentTMView.selectedIndex].count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: "userOrder", for: indexPath) as? EDUserOrderCell
        cell?.setupEvent(order: orders[segmentTMView.selectedIndex][indexPath.row])
        return cell ?? UITableViewCell()
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        188
    }
}

extension EDUserOrdersViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentTMView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt: Int) -> JXSegmentedListContainerViewListDelegate {
        if initListAt == 0 {
            orderTableView.reloadData()
            return orderTableView
        } else {
            orderTableView.reloadData()
            return orderTableView
        }
        
    }
}

extension EDUserOrdersViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentTMView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            // 先更新数据源的数据

            dotDataSource.dotStates[index] = false
            // 再调用reloadItem(at: index)
            segmentTMView.reloadItem(at: index)
        }
    }

    func segmentedView(_ segmentTMView: JXSegmentedView, didScrollSelectedItemAt initListAt: Int) {
        
    }
}
