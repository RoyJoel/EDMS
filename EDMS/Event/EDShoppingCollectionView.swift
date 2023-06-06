//
//  EDClubContentView.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/3/14.
//

import Foundation
import TMComponent
import UIKit

class EDShoppingCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var coms: [Commodity] = []
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor(named: "BackgroundGray")
        delegate = self
        dataSource = self
        register(EDCommodityCell.self, forCellWithReuseIdentifier: "commodityies")
        reloadData()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyFilter(coms: [Commodity]) {
        self.coms = coms
        if coms.count != 0 {
            collectionViewLayout = EDFlowLayout(commodities: coms)
        }
        reloadData()
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        coms.count
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "commodityies", for: indexPath) as! EDCommodityCell
        cell.setupUI()
        if EDDataConvert.getPriceRange(with: coms[indexPath.row].options).0 == EDDataConvert.getPriceRange(with: coms[indexPath.row].options).1 {
            cell.setupEvent(icon: coms[indexPath.row].options[0].image, intro: coms[indexPath.row].name, price: "\(EDDataConvert.getPriceRange(with: coms[indexPath.row].options).0)", turnOver: coms[indexPath.row].orders)
        } else {
            cell.setupEvent(icon: coms[indexPath.row].options[0].image, intro: coms[indexPath.row].name, price: "\(EDDataConvert.getPriceRange(with: coms[indexPath.row].options).0) - \(EDDataConvert.getPriceRange(with: coms[indexPath.row].options).1)", turnOver: coms[indexPath.row].orders)
        }
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = EDComContentViewController()
        vc.com = coms[indexPath.row]
        if let parentVC = getParentViewController() {
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
