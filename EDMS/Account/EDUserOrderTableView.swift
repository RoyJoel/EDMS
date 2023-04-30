//
//  EDUserOrderTableView.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/29.
//

import Foundation
import JXSegmentedView
import UIKit

class EDUserOrderTableView: UITableView {}

extension EDUserOrderTableView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
