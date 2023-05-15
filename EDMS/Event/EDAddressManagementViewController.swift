//
//  EDAddressManagementViewController.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/25.
//

import Foundation
import UIKit

class EDAddressManagementViewController: UITableViewController {
    var addresss: [Address] = []
    var selectedCompletionHandler: ((Address) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addAddress)), animated: true)
        tableView.backgroundColor = UIColor(named: "BackgroundGray")
        tableView.register(EDAddressCell.self, forCellReuseIdentifier: "AddressCell")
        EDAddressRequest.getAddressInfos(ids: EDUser.user.addresss) { addresss in
            self.addresss = addresss
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        let cell = EDAddressCell()
        cell.setupEvent(address: addresss[indexPath.row], canEdit: true)
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return addresss.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        super.tableView(tableView, heightForRowAt: indexPath)
        return 143
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let address = (tableView.cellForRow(at: indexPath) as? EDAddressCell)?.address {
            addresss[indexPath.row] = address
            (selectedCompletionHandler ?? { _ in })(address)
        }
        navigationController?.popViewController(animated: true)
    }

    @objc func addAddress() {
        let vc = EDAddressEditingViewController()
        vc.openAddingMode()
        vc.addCompletionHandler = { address in
            self.addresss.append(address)
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
