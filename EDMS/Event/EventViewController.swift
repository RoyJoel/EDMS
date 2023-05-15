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
        let view = EDShoppingCollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()

    lazy var cartBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view = EDEventView()
        view.addSubview(titleView)
        view.addSubview(filter)
        view.addSubview(shoppingCollectionView)
        view.addSubview(cartBtn)
        view.bringSubviewToFront(filter)

        titleView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(48)
            make.width.equalTo(208)
            make.height.equalTo(44)
        }

        cartBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(48)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        cartBtn.setImage(UIImage(systemName: "cart"), for: .normal)
        cartBtn.setCorner(radii: 22)
        cartBtn.tintColor = UIColor(named: "ContentBackground")
        cartBtn.backgroundColor = UIColor(named: "ComponentBackground")
        cartBtn.addTarget(self, action: #selector(enterBillView), for: .touchDown)
        titleView.font = UIFont.systemFont(ofSize: 24)

        filter.frame = CGRect(x: UIStandard.shared.screenWidth - 158, y: 48, width: 90, height: 44)

        filter.setup(filter.bounds, filter.layer.position, CGRect(x: 0, y: 0, width: 270, height: filter.bounds.height), CGPoint(x: filter.layer.position.x - 40, y: filter.layer.position.y), 0.3)

        shoppingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.left.equalTo(titleView.snp.left)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-98)
        }

        filter.setupUI()
        filter.clipsToBounds = false

        titleView.text = "积分商城"
        filter.completionHandler = { coms in
            self.shoppingCollectionView.applyFilter(coms: coms)
        }
    }

    @objc func enterBillView() {
        let vc = EDBillTableViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.openCartMode()
    }
}
