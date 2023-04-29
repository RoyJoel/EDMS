//
//  EDAddressCell.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/25.
//

import Foundation
import UIKit

class EDAddressCell: UITableViewCell {
    var address = Address()
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

    lazy var addressEdittingNavigationBar: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var editView: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "BackgroundGray")
        contentView.addSubview(nameAmdSexLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(provinceLabel)
        contentView.addSubview(cityLabel)
        contentView.addSubview(areaLabel)
        contentView.addSubview(detailedAddressLabel)
        contentView.addSubview(addressEdittingNavigationBar)
        contentView.addSubview(editView)

        layoutSubviews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameAmdSexLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(38)
        }
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAmdSexLabel.snp.top)
            make.height.equalTo(38)
            make.left.equalTo(nameAmdSexLabel.snp.right).offset(6)
        }

        provinceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAmdSexLabel.snp.bottom).offset(6)
            make.left.equalTo(nameAmdSexLabel.snp.left)
            make.height.equalTo(38)
        }
        cityLabel.snp.makeConstraints { make in
            make.left.equalTo(provinceLabel.snp.right).offset(6)
            make.top.equalTo(provinceLabel.snp.top)
            make.height.equalTo(38)
        }
        areaLabel.snp.makeConstraints { make in
            make.left.equalTo(cityLabel.snp.right).offset(6)
            make.top.equalTo(provinceLabel.snp.top)
            make.height.equalTo(38)
        }
        detailedAddressLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(provinceLabel.snp.bottom).offset(6)
            make.height.equalTo(38)
        }
        editView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview()
            make.width.equalTo(108)
            make.height.equalTo(58)
        }

        editView.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editView.tintColor = UIColor(named: "ContentBackground")
        editView.setTitle("编辑", for: .normal)
        editView.addTarget(self, action: #selector(enterEditingView), for: .touchDown)
    }

    func setupEvent(address: Address) {
        self.address = address
        nameAmdSexLabel.text = "\(address.name) \(address.sex == .Man ? "先生" : "女士")"
        phoneNumberLabel.text = "\(address.phoneNumber)"
        provinceLabel.text = "\(address.province)"
        cityLabel.text = "\(address.city)"
        areaLabel.text = "\(address.area)"
        detailedAddressLabel.text = "\(address.detailedAddress)"
    }

    @objc func enterEditingView() {
        if let parentVC = getParentViewController() {
            let vc = EDAddressEditingViewController()
            vc.setupEvent(address: address1)
            vc.saveCompletionHandler = { address in
                self.setupEvent(address: address)
            }
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
