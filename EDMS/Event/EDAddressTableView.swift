//
//  EDAddressTableView.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/14.
//

import Foundation
import UIKit

class EDAddressTableView: UITableViewController {
    lazy var addressList: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addAddress)), animated: true)
        tableView.register(EDAddressCell.self, forCellReuseIdentifier: "addressCell")
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        EDUser.user.addresss.count
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EDAddressCell()
        cell.setupEvent(address: EDUser.user.addresss[indexPath.row], canEdit: true)
        return cell
    }

    @objc func addAddress() {
        let vc = EDAddressEditingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
