//
//  EDBillTableViewController.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/24.
//

import Foundation
import UIKit

class EDBillTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var bills: [Bill] = []

    lazy var orderBackgroundView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var totalLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var totalNumLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    lazy var billTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(billTableView)
        billTableView.backgroundColor = UIColor(named: "BackgroundGray")
        view.insertSubview(orderBackgroundView, aboveSubview: billTableView)
        orderBackgroundView.addSubview(totalLabel)
        orderBackgroundView.addSubview(totalNumLabel)
        orderBackgroundView.addSubview(confirmBtn)

        billTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        orderBackgroundView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(208)
        }

        totalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(50)
        }

        totalNumLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(50)
        }

        confirmBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-24)
            make.width.equalTo(108)
            make.height.equalTo(50)
        }

        billTableView.register(EDComBillingCell.self, forCellReuseIdentifier: "billing")
        billTableView.showsHorizontalScrollIndicator = false
        billTableView.showsVerticalScrollIndicator = false
        billTableView.dataSource = self
        billTableView.delegate = self

        orderBackgroundView.isHidden = true
    }

    func openCartMode() {
        EDUser.getCartInfo { cart in
            self.bills = cart.bills
            self.billTableView.reloadData()
            self.totalLabel.text = "Total"
            self.totalLabel.font = UIFont.systemFont(ofSize: 26)

            let totalNum = EDDataConvert.getTotalPrice(cart.bills)
            self.totalNumLabel.text = "¥" + String(format: "%.2f", totalNum)
            self.totalNumLabel.font = UIFont.systemFont(ofSize: 22)

            self.confirmBtn.setTitle("Pay", for: .normal)
            self.confirmBtn.backgroundColor = UIColor(named: "TennisBlur")
            self.confirmBtn.setTitleColor(.black, for: .normal)
            self.confirmBtn.addTarget(self, action: #selector(self.enterBillingViewController), for: .touchDown)
            self.confirmBtn.setCorner(radii: 15)
            self.orderBackgroundView.isHidden = false
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return bills.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 168
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDComBillingCell()
        cell.setupEvent(bill: bills[indexPath.row])
        return cell
    }

    @objc func enterBillingViewController() {
        let vc = EDBillingViewController()
        let newOrder = Order(id: 0, bills: bills, shippingAddress: address1, deliveryAddress: address2, payment: .WeChat, totalPrice: EDDataConvert.getTotalPrice(bills), createdTime: Date().timeIntervalSince1970, state: .ToPay)
        vc.order = newOrder
        navigationController?.pushViewController(vc, animated: true)
    }
}
