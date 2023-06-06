//
//  EDHistoryGameCell.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/6/3.
//

import Foundation
import UIKit

class EDHistoryGameCell: UITableViewCell {
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var placeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var resultLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(placeLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(resultLabel)
        contentView.backgroundColor = UIColor(named: "BackgroundGray")
        layoutSubviews()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(144)
        }
        placeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(dateLabel.snp.right)
            make.right.equalTo(resultLabel.snp.left).offset(6)
        }
        resultLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(108)
            make.right.equalToSuperview()
        }
        dateLabel.textAlignment = .center
        placeLabel.textAlignment = .center
        resultLabel.textAlignment = .center
    }

    func setupEvent(pointRecord: pointRecord) {
        dateLabel.text = pointRecord.date.convertToString(formatterString: "MM-dd HH:mm")
        placeLabel.text = pointRecord.type.rawValue
        resultLabel.text = "\(pointRecord.num)"
        resultLabel.sizeToFit()
    }
}
