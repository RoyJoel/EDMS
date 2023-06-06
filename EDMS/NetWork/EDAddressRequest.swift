//
//  EDAddressRequest.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/14.
//

import Foundation

class EDAddressRequest {
    static func addAddress(address: AddressRequest, completionHandler: @escaping (Address) -> Void) {
        EDNetWork.post("/address/add", dataParameters: address) { json in
            guard let json = json else {
                return
            }
            let address = Address(json: json)
            EDUser.user.addresss.append(address.id)
            if address.isDefault {
                EDUser.user.defaultAddress = address
            }
            completionHandler(address)
        }
    }

    static func UpdateAddress(address: AddressRequest, completionHandler: @escaping (Address) -> Void) {
        EDNetWork.post("/address/update", dataParameters: address) { json in
            guard let json = json else {
                return
            }
            if address.isDefault {
                EDUser.user.defaultAddress = Address(json: json)
            }
            completionHandler(Address(json: json))
        }
    }

    static func deleteAddress(id: Int, completionHandler: @escaping (Bool) -> Void) {
        EDNetWork.post("/address/delete", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func getAddressInfos(ids: [Int], completionHandler: @escaping ([Address]) -> Void) {
        EDNetWork.post("/address/getInfos", dataParameters: ["ids": ids]) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Address(json: $0) })
        }
    }
}
