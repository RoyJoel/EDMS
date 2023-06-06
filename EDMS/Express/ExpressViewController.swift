//
//  ExpressViewController.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/10.
//

import Alamofire
import Foundation
import SwiftyJSON
import UIKit

class ExpressViewController: EDViewController, UITextFieldDelegate {
    var express = express1
    lazy var senderAddressView: EDAddressCell = {
        let view = EDAddressCell()
        return view
    }()

    lazy var recipientAddressView: EDAddressCell = {
        let view = EDAddressCell()
        return view
    }()

    lazy var payTypeView: EDsettingTableViewCell = {
        let view = EDsettingTableViewCell()
        return view
    }()

    lazy var commodityBackgroundView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var commodityTypeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var commodityTypeView: EDTextField = {
        let view = EDTextField()
        return view
    }()

    lazy var btn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(senderAddressView)
        view.addSubview(recipientAddressView)
        view.addSubview(payTypeView)
        view.addSubview(commodityBackgroundView)
        view.addSubview(btn)
        commodityBackgroundView.addSubview(commodityTypeView)
        commodityBackgroundView.addSubview(commodityTypeLabel)

        senderAddressView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(68)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(144)
        }

        recipientAddressView.snp.makeConstraints { make in
            make.top.equalTo(senderAddressView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(144)
        }

        payTypeView.snp.makeConstraints { make in
            make.top.equalTo(recipientAddressView.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(98)
        }
        commodityBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(payTypeView.snp.bottom).offset(24)
            make.height.equalTo(98)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
        }
        commodityTypeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
            make.height.equalTo(48)
        }

        commodityTypeView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
            make.right.equalToSuperview().offset(-24)
        }
        btn.snp.makeConstraints { make in
            make.top.equalTo(commodityBackgroundView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(88)
            make.height.equalTo(44)
        }

        senderAddressView.setCorner(radii: 15)
        recipientAddressView.setCorner(radii: 15)
        payTypeView.setCorner(radii: 15)
        senderAddressView.setupEvent(address: express1.de, canEdit: true)
        recipientAddressView.setupEvent(address: express1.sh, canEdit: true)
        payTypeView.setupEvent(title: "支付方式", info: express.payment.displayName)
        payTypeView.addTapGesture(self, #selector(enterPayTypeSelectionView))
        let textFieldConfig = EDTextFieldConfig(placeholderText: "输入你的物品类型")
        commodityTypeLabel.text = "物品类型"
        commodityTypeView.setup(with: textFieldConfig)
        commodityTypeView.textField.text = express.commoType
        commodityBackgroundView.setCorner(radii: 15)
        commodityTypeView.backgroundColor = UIColor(named: "ComponentBackground")
        commodityBackgroundView.backgroundColor = UIColor(named: "ComponentBackground")
        senderAddressView.addTapGesture(self, #selector(enterAddressManagementViewController))
        commodityTypeView.textField.delegate = self
        btn.setTitle("下单", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setCorner(radii: 15)
        btn.backgroundColor = UIColor(named: "TennisBlur")
        btn.addTarget(self, action: #selector(add), for: .touchDown)
    }

    @objc func enterPayTypeSelectionView() {
        let vc = EDSettingSelectionViewController()
        vc.title = "payType"
        vc.selectedRow = payType(displayName: payTypeView.infoView.text ?? "").index
        vc.dataSource = payType.allCases.compactMap { $0.displayName }
        vc.completionHandler = { selectedPayType in
            self.payTypeView.setupEvent(title: "支付方式", info: selectedPayType)
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func enterAddressManagementViewController() {
        let vc = EDAddressManagementViewController()
        navigationController?.present(UINavigationController(rootViewController: vc), animated: true)
    }

    @objc func add() {
        let express = Express(id: 0, de: senderAddressView.address, sh: recipientAddressView.address, payment: payType(rawValue: payTypeView.infoView.text ?? "") ?? .aliPayOnline, price: 12, state: .ToSend, commoType: commodityTypeView.textField.text ?? "", createdTime: Date().timeIntervalSince1970, trace: [])
        let toastView = UILabel()
        toastView.text = NSLocalizedString("下单成功，获得20积分", comment: "")
        toastView.numberOfLines = 2
        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
        toastView.backgroundColor = UIColor(named: "ComponentBackground")
        toastView.textAlignment = .center
        toastView.setCorner(radii: 15)
        view.showToast(toastView, duration: 1, point: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)) { _ in
        }
        expresses.append(express)
        let record = pointRecord(date: Date().timeIntervalSince1970, type: .express, num: 20)
        records.append(record)
        points += 20
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

enum payType: String, CaseIterable, Codable {
    case cashOnDelivery
    case aliPayOnline
    case weChatOnline

    var index: Int {
        switch self {
        case .cashOnDelivery:
            return 0
        case .aliPayOnline:
            return 1
        case .weChatOnline:
            return 2
        }
    }

    var displayName: String {
        switch self {
        case .cashOnDelivery:
            return "货到付款"
        case .weChatOnline:
            return "微信支付"
        case .aliPayOnline:
            return "支付宝"
        }
    }

    init(displayName: String) {
        switch displayName {
        case "支付宝":
            self = .aliPayOnline
        case "微信支付":
            self = .weChatOnline
        default:
            self = .cashOnDelivery
        }
    }
}
