//
//  Commodity.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/21.
//

import Foundation
import SwiftyJSON

struct Commodity: Codable, Equatable {
    var id: Int
    var name: String
    var intro: String
    var price: Double
    var inventory: Int
    var orders: Int
    var options: [Option]
    var cag: comCag

    init(id: Int, options: [Option], name: String, intro: String, price: Double, inventory: Int, orders: Int, cag: comCag) {
        self.id = id
        self.options = options
        self.name = name
        self.intro = intro
        self.price = price
        self.inventory = inventory
        self.orders = orders
        self.cag = cag
    }

    init(json: JSON) {
        id = json["id"].intValue
        options = json["options"].arrayValue.compactMap { Option(json: $0) }
        name = json["name"].stringValue
        intro = json["intro"].stringValue
        price = json["price"].doubleValue
        inventory = json["inventory"].intValue
        orders = json["orders"].intValue
        cag = comCag(rawValue: json["cag"].intValue) ?? .Accessories
    }

    init() {
        self = Commodity(json: JSON())
    }

    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "options": options,
            "name": name,
            "intro": intro,
            "price": price,
            "inventory": inventory,
            "orders": orders,
            "cag": cag,
        ]
        return dict
    }

    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? Int, let optiondits = dict["options"] as? [[String: Any]], let name = dict["name"] as? String, let intro = dict["intro"] as? String, let price = dict["price"] as? Double, let inventory = dict["inventory"] as? Int, let orders = dict["orders"] as? Int, let cag = dict["cag"] as? Int else {
            return nil
        }

        let options = optiondits.map { Option(dict: $0) ?? Option() }
        let comcag = comCag(rawValue: cag) ?? .Accessories
        self = Commodity(id: id, options: options, name: name, intro: intro, price: price, inventory: inventory, orders: orders, cag: comcag)
    }

    static func == (lhs: Commodity, rhs: Commodity) -> Bool {
        return lhs.id == rhs.id && lhs.options == rhs.options && lhs.name == rhs.name && lhs.intro == rhs.intro && lhs.price == rhs.price && lhs.inventory == rhs.inventory && lhs.orders == rhs.orders && lhs.cag == rhs.cag
    }
}
