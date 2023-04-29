//
//  EDAddressView.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/24.
//

import Foundation
import UIKit

class EDAddressView: UIView {
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var nameAmdSexLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var provinceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var cityLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var areaLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var detailedAddressLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func setupUI() {
        backgroundColor = UIColor(named: "ComponentBackground")
        setCorner(radii: 15)
        addSubview(addressLabel)
        addSubview(nameAmdSexLabel)
        addSubview(phoneNumberLabel)
        addSubview(provinceLabel)
        addSubview(cityLabel)
        addSubview(areaLabel)
        addSubview(detailedAddressLabel)

        addressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
            make.width.equalTo(158)
            make.height.equalTo(50)
        }

        nameAmdSexLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.left.equalTo(addressLabel).offset(12)
            make.top.equalToSuperview().offset(14)
            make.height.equalToSuperview().dividedBy(6).offset(-4)
        }

        phoneNumberLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.left.equalTo(addressLabel).offset(12)
            make.top.equalTo(nameAmdSexLabel.snp.bottom)
            make.height.equalToSuperview().dividedBy(6).offset(-4)
        }
        provinceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.left.equalTo(addressLabel).offset(12)
            make.top.equalTo(phoneNumberLabel.snp.bottom)
            make.height.equalToSuperview().dividedBy(6).offset(-4)
        }
        cityLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.left.equalTo(addressLabel).offset(12)
            make.top.equalTo(provinceLabel.snp.bottom)
            make.height.equalToSuperview().dividedBy(6).offset(-4)
        }
        areaLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.left.equalTo(addressLabel).offset(12)
            make.top.equalTo(cityLabel.snp.bottom)
            make.height.equalToSuperview().dividedBy(6).offset(-4)
        }
        detailedAddressLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.left.equalTo(addressLabel).offset(12)
            make.top.equalTo(areaLabel.snp.bottom)
            make.height.equalToSuperview().dividedBy(6).offset(-4)
        }

        addressLabel.text = "Delivery Address"
        nameAmdSexLabel.textAlignment = .right
        phoneNumberLabel.textAlignment = .right
        provinceLabel.textAlignment = .right
        cityLabel.textAlignment = .right
        areaLabel.textAlignment = .right
        detailedAddressLabel.textAlignment = .right
        addTapGesture(self, #selector(editAddress))
    }

    func setupEvent(address: Address) {
        nameAmdSexLabel.text = "\(address.name) \(address.sex == .Man ? "先生" : "女士")"
        phoneNumberLabel.text = "\(address.phoneNumber)"
        provinceLabel.text = "\(address.province)"
        cityLabel.text = "\(address.city)"
        areaLabel.text = "\(address.area)"
        detailedAddressLabel.text = "\(address.detailedAddress)"
    }

    @objc func editAddress() {
        let vc = EDAddressManagementViewController()
        if let parentVC = getParentViewController() {
            vc.selectedCompletionHandler = { address in
                self.setupEvent(address: address)
            }
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
