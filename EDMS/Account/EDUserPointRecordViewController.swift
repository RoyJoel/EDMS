//
//  EDUserPointRecordViewController.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/6/3.
//

import Foundation
import UIKit

class EDUserPointRecordViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var viewUpCompletionHandler: () -> Void = {}
    var viewDownCompletionHandler: () -> Void = {}

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

    lazy var scheduleList: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    // 无比赛时提示窗口
    lazy var alartView: UILabel = {
        let view = UILabel()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(dateLabel)
        view.addSubview(resultLabel)
        view.addSubview(alartView)
        view.addSubview(placeLabel)
        view.addSubview(scheduleList)

        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(103)
            make.left.equalToSuperview().offset(12)
            make.width.equalTo(144)
            make.height.equalTo(44)
        }
        placeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(103)
            make.left.equalTo(dateLabel.snp.right)
            make.right.equalTo(resultLabel.snp.left)
            make.height.equalTo(44)
        }
        resultLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(103)
            make.width.equalTo(108)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(44)
        }
        scheduleList.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.equalTo(dateLabel.snp.left)
            make.right.equalTo(resultLabel.snp.right)
        }
        alartView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
        }

        dateLabel.text = NSLocalizedString("日期", comment: "")
        resultLabel.text = NSLocalizedString("积分数量", comment: "")
        placeLabel.text = NSLocalizedString("记录类型", comment: "")
        dateLabel.font = UIFont.systemFont(ofSize: 21)
        resultLabel.font = UIFont.systemFont(ofSize: 21)
        placeLabel.font = UIFont.systemFont(ofSize: 21)
        dateLabel.textAlignment = .center
        resultLabel.textAlignment = .center
        placeLabel.textAlignment = .center
        scheduleList.delegate = self
        scheduleList.dataSource = self
        scheduleList.register(EDHistoryGameCell.self, forCellReuseIdentifier: "EDHistoryGameCell")
        scheduleList.separatorStyle = .none
        scheduleList.showsVerticalScrollIndicator = false
        scheduleList.showsHorizontalScrollIndicator = false
        scheduleList.allowsSelectionDuringEditing = true
        scheduleList.backgroundColor = UIColor(named: "BackgroundGray")

        if records.count == 0 {
            setupAlart()
        } else {
            dateLabel.isHidden = false
            resultLabel.isHidden = false
            scheduleList.isHidden = false
            alartView.isHidden = true
        }
    }

    func setupAlart() {
        dateLabel.isHidden = true
        resultLabel.isHidden = true
        scheduleList.isHidden = true
        alartView.isHidden = false

        alartView.text = NSLocalizedString("You don't have any point record", comment: "")
        alartView.font = UIFont.systemFont(ofSize: 22)
        alartView.textAlignment = .center
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        42
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        records.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDHistoryGameCell()
        cell.selectionStyle = .none
        cell.showsReorderControl = true // 显示移动编辑样式
        cell.editingAccessoryType = .disclosureIndicator // 显示向右箭头的编辑样式
        cell.setupEvent(pointRecord: records[indexPath.row])
        return cell
    }
}
