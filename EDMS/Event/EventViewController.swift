//
//  EventViewController.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2022/12/26.
//

import Alamofire
import Foundation
import MapKit
import SwiftyJSON
import TMComponent
import UIKit

class EventViewController: EDViewController {
    let layout = EDFlowLayout(itemCount: com.count)

    lazy var titleView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var filter: EDFilterView = {
        let view = EDFilterView()
        return view
    }()

    lazy var shoppingCollectionView: EDShoppingCollectionView = {
        let view = EDShoppingCollectionView(frame: .zero, collectionViewLayout: layout, coms: com)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view = EDEventView()
        view.addSubview(titleView)
        view.addSubview(filter)
        view.addSubview(shoppingCollectionView)
        view.bringSubviewToFront(filter)

        titleView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(32)
            make.width.equalTo(208)
            make.height.equalTo(50)
        }

        titleView.font = UIFont.systemFont(ofSize: 36)

        filter.frame = CGRect(x: UIStandard.shared.screenWidth - 136, y: 32, width: 112, height: 44)

        filter.setup(filter.bounds, filter.layer.position, CGRect(x: 0, y: 0, width: 300, height: filter.bounds.height), CGPoint(x: filter.layer.position.x - 94, y: filter.layer.position.y), 0.3)

        shoppingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.left.equalTo(titleView.snp.left)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-98)
        }

        filter.setupUI()
        filter.clipsToBounds = false

        titleView.text = "积分商城"
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(ToastNotification.DataFreshToast.rawValue), object: nil)
        filter.completionHandler = { coms in
            self.shoppingCollectionView.applyFilter(coms: coms)
        }
    }

    @objc func refreshData() {}
}
