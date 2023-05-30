//
//  EDUserOrdersViewController.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/29.
//
import Foundation
import JXSegmentedView
import TMComponent

class EDUserOrdersViewController: UIViewController {
    let allOrdersDS = ordersDataSource()
    let ordersToPayDS = ordersDataSource()
    let ordersToDeliveryDS = ordersDataSource()
    let ordersToConfirmDS = ordersDataSource()
    let ordersCompletedDS = ordersDataSource()
    let ordersToRefundDS = ordersDataSource()
    let ordersOnReturningDS = ordersDataSource()
    let ordersReturnedDS = ordersDataSource()

    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentTMView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()

    lazy var allOrderTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersToPayTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersToDeliveryTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersToConfirmTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersCompletedTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersToRefundTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersOnReturningTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    lazy var ordersReturnedTableView: EDUserOrderTableView = {
        let tableView = EDUserOrderTableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单中心"
        view.backgroundColor = UIColor(named: "BackgroundGray")
        let titles = ["全部订单"] + OrderState.allCases.compactMap { $0.displayName }

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
            make.top.equalToSuperview().offset(103)
        }
        listContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentTMView.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        allOrderTableView.delegate = allOrdersDS
        allOrderTableView.dataSource = allOrdersDS
        allOrderTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "allOrders")
        EDOrderRequest.getInfos(id: EDUser.user.id) { orders in
            let filterOrders = orders.filter { $0.id != EDUser.user.cart }
            self.allOrdersDS.orders = filterOrders
            self.allOrderTableView.reloadData()

            self.ordersToPayTableView.delegate = self.ordersToPayDS
            self.ordersToPayDS.orders = filterOrders.filter { $0.state == .ToPay }
            self.ordersToPayTableView.dataSource = self.ordersToPayDS
            self.ordersToPayTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToPay")

            self.ordersToDeliveryTableView.delegate = self.ordersToDeliveryDS
            self.ordersToDeliveryDS.orders = filterOrders.filter { $0.state == .ToSend }
            self.ordersToDeliveryTableView.dataSource = self.ordersToDeliveryDS
            self.ordersToDeliveryTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToDelivery")
            self.ordersToConfirmTableView.delegate = self.ordersToConfirmDS
            self.ordersToConfirmDS.orders = filterOrders.filter { $0.state == .ToDelivery }
            self.ordersToConfirmTableView.dataSource = self.ordersToConfirmDS
            self.ordersToConfirmTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToConfirm")
            self.ordersCompletedTableView.delegate = self.ordersCompletedDS
            self.ordersCompletedDS.orders = filterOrders.filter { $0.state == .Done }
            self.ordersCompletedTableView.dataSource = self.ordersCompletedDS
            self.ordersCompletedTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersCompleted")
            self.ordersToRefundTableView.delegate = self.ordersToRefundDS
            self.ordersToRefundDS.orders = filterOrders.filter { $0.state == .ToRefund }
            self.ordersToRefundTableView.dataSource = self.ordersToRefundDS
            self.ordersToRefundTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersToRefund")
            self.ordersOnReturningTableView.delegate = self.ordersOnReturningDS
            self.ordersOnReturningDS.orders = filterOrders.filter { $0.state == .ToReturn }
            self.ordersOnReturningTableView.dataSource = self.ordersOnReturningDS
            self.ordersOnReturningTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersOnReturning")
            self.ordersReturnedTableView.delegate = self.ordersReturnedDS
            self.ordersReturnedDS.orders = filterOrders.filter { $0.state == .Refunded }
            self.ordersReturnedTableView.dataSource = self.ordersReturnedDS
            self.ordersReturnedTableView.register(EDUserOrderCell.self, forCellReuseIdentifier: "ordersReturned")
        }
    }
}

class ordersDataSource: NSObject, UITableViewDelegate, UITableViewDataSource {
    var orders: [Order] = []
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        orders.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDUserOrderCell()
        cell.setupEvent(order: orders[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EDOrderDetailViewController()
        vc.order = orders[indexPath.row]
        if let parentVC = tableView.getParentViewController() {
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
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
        switch initListAt {
        case 0:
            allOrderTableView.reloadData()
            return allOrderTableView
        case 1:
            ordersToPayTableView.reloadData()
            return ordersToPayTableView
        case 2:
            ordersToDeliveryTableView.reloadData()
            return ordersToDeliveryTableView
        case 3:
            ordersToConfirmTableView.reloadData()
            return ordersToConfirmTableView
        case 4:
            ordersCompletedTableView.reloadData()
            return ordersCompletedTableView
        case 5:
            ordersToRefundTableView.reloadData()
            return ordersToRefundTableView
        case 6:
            ordersOnReturningTableView.reloadData()
            return ordersOnReturningTableView
        default:
            ordersReturnedTableView.reloadData()
            return ordersReturnedTableView
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

    func segmentedView(_: JXSegmentedView, didScrollSelectedItemAt _: Int) {}
}
