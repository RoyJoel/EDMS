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
            completionHandler(Address(json: json))
        }
    }

    static func UpdateAddress(address: AddressRequest, completionHandler: @escaping (Address) -> Void) {
        EDNetWork.post("/address/update", dataParameters: address) { json in
            guard let json = json else {
                return
            }
            completionHandler(Address(json: json))
        }
    }

    static func deleteAddress(id: Int, completionHandler: @escaping (Address) -> Void) {
        EDNetWork.post("/address/delete", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            completionHandler(Address(json: json))
        }
    }

    static func getAddressInfo(id: Int, completionHandler: @escaping (Address) -> Void) {
        EDNetWork.post("/address/getInfo", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            completionHandler(Address(json: json))
        }
    }
}
