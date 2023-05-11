//
//  ExpressViewController.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/10.
//

import Foundation
import UIKit

class ExpressViewController: EDViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(senderAddressView)
        view.addSubview(recipientAddressView)
        view.addSubview(payTypeView)
        view.addSubview(commodityBackgroundView)
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

        senderAddressView.setupEvent(address: address1, canEdit: true)
        recipientAddressView.setupEvent(address: address2, canEdit: true)
        payTypeView.setupEvent(title: "支付方式", info: payType.cashOnDelivery.rawValue)
        payTypeView.addTapGesture(self, #selector(enterPayTypeSelectionView))
        let textFieldConfig = EDTextFieldConfig(placeholderText: "输入你的物品类型")
        commodityTypeLabel.text = "物品类型"
        commodityTypeView.setup(with: textFieldConfig)
        commodityBackgroundView.setCorner(radii: 15)
        commodityTypeView.backgroundColor = UIColor(named: "ComponentBackground")
        commodityBackgroundView.backgroundColor = UIColor(named: "ComponentBackground")
    }

    @objc func enterPayTypeSelectionView() {
        let vc = EDSettingSelectionViewController()
        vc.title = "payType"
        vc.dataSource = payType.allCases.compactMap { $0.rawValue }
        vc.completionHandler = { selectedPayType in
            self.payTypeView.setupEvent(title: "支付方式", info: selectedPayType)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

enum payType: String, CaseIterable {
    case cashOnDelivery
    case aliPayOnline
    case weChatOnline
}
