//
//  EDcommodityCell.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/21.
//

import Foundation
import UIKit

class EDCommodityCell: UICollectionViewCell {
    lazy var comIconView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var comIntroView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var turnoverLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func setupUI() {
        backgroundColor = UIColor(named: "ComponentBackground")
        setCorner(radii: 15)
        contentView.addSubview(comIconView)
        contentView.addSubview(comIntroView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(turnoverLabel)

        comIconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview()
        }
        comIntroView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-6)
            make.top.equalTo(comIconView.snp.bottom).offset(6)
            make.height.equalTo(38)
        }
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.top.equalTo(comIntroView.snp.bottom).offset(6)
            make.width.equalTo(138)
            make.height.equalTo(38)
        }
        turnoverLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-6)
            make.top.equalTo(comIntroView.snp.bottom).offset(6)
            make.width.equalTo(88)
            make.height.equalTo(38)
        }

        priceLabel.textColor = UIColor(named: "Tennis")
        priceLabel.font = UIFont.systemFont(ofSize: 24)
        turnoverLabel.textColor = UIColor(named: "blurGray")
        comIconView.contentMode = .scaleAspectFit
    }

    func setupEvent(icon: String, intro: String, price: Double, turnOver: Int) {
        let icon = UIImage(named: icon)
        comIconView.image = icon
        comIntroView.text = intro
        priceLabel.text = String(format: "%.2f", price) + "积分"
        turnoverLabel.text = "\(turnOver)人已兑换"
        let ar = calculateAR(image: icon ?? UIImage())
        comIconView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(comIconView.snp.width).multipliedBy(ar)
        }
    }

    func calculateAR(image: UIImage) -> CGFloat {
        let width = image.size.width
        let height = image.size.height
        return height / width
    }
}
