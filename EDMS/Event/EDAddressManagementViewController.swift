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

        let sheetCtrl = UIAlertController(title: "是否将地址更改为", message: "\(addresss[indexPath.row].name)\(addresss[indexPath.row].sex == .Man ? "先生" : "女士")\n\(addresss[indexPath.row].phoneNumber)\n\(addresss[indexPath.row].province) \(addresss[indexPath.row].city) \(addresss[indexPath.row].area)\n\(addresss[indexPath.row].detailedAddress)", preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            if let address = (self.tableView.cellForRow(at: indexPath) as? EDAddressCell)?.address {
                self.addresss[indexPath.row] = address
                (self.selectedCompletionHandler ?? { _ in })(address)
            }
            self.navigationController?.popViewController(animated: true)
        }
        sheetCtrl.addAction(action)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            sheetCtrl.dismiss(animated: true)
        }
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = view
        sheetCtrl.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.width / 2 - 144, y: view.bounds.height / 2 - 69, width: 288, height: 138)
        present(sheetCtrl, animated: true, completion: nil)
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
