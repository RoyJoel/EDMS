//
//  Order.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/24.
//

import Foundation
import SwiftyJSON

struct Order: Codable, Equatable {
    var id: Int
    var bills: [Bill]
    var shippingAddress: Address
    var deliveryAddress: Address
    var createdTime: TimeInterval
    var payedTime: TimeInterval?
    var completedTime: TimeInterval?

    init(id: Int, bills: [Bill], shippingAddress: Address, deliveryAddress: Address, createdTime: TimeInterval, payedTime: TimeInterval? = nil, completedTime: TimeInterval? = nil) {
        self.id = id
        self.bills = bills
        self.shippingAddress = shippingAddress
        self.deliveryAddress = deliveryAddress
        self.createdTime = createdTime
        self.payedTime = payedTime
        self.completedTime = completedTime
    }

    init(json: JSON) {
        id = json["id"].intValue
        bills = json["bills"].arrayValue.map { Bill(json: $0) }
        shippingAddress = Address(json: json["shippingAddress"])
        deliveryAddress = Address(json: json["deliveryAddress"])
        createdTime = json["createdTime"].doubleValue
        payedTime = json["payedTime"].doubleValue
        completedTime = json["completedTime"].doubleValue
    }

    init() {
        self = Order(json: JSON())
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let billsArray = dictionary["bills"] as? [[String: Any]],
            let shippingAddressDict = dictionary["shippingAddress"] as? [String: Any],
            let deliveryAddressDict = dictionary["deliveryAddress"] as? [String: Any],
            let createdTime = dictionary["createdTime"] as? TimeInterval else {
            return nil
        }

        self.id = id
        bills = billsArray.compactMap { Bill(dictionary: $0) }
        shippingAddress = Address(dictionary: shippingAddressDict)!
        deliveryAddress = Address(dictionary: deliveryAddressDict)!
        self.createdTime = createdTime

        if let payedTime = dictionary["payedTime"] as? TimeInterval {
            self.payedTime = payedTime
        }

        if let completedTime = dictionary["completedTime"] as? TimeInterval {
            self.completedTime = completedTime
        }
    }

    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "bills": bills.map { $0.toDictionary() },
            "shippingAddress": shippingAddress.toDictionary(),
            "deliveryAddress": deliveryAddress.toDictionary(),
            "createdTime": createdTime,
        ]

        if let payedTime = payedTime {
            dict["payedTime"] = payedTime
        }

        if let completedTime = completedTime {
            dict["completedTime"] = completedTime
        }

        return dict
    }

    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id &&
            lhs.bills == rhs.bills &&
            lhs.shippingAddress == rhs.shippingAddress &&
            lhs.deliveryAddress == rhs.deliveryAddress &&
            lhs.createdTime == rhs.createdTime &&
            lhs.payedTime == rhs.payedTime &&
            lhs.completedTime == rhs.completedTime
    }
}
