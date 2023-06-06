//
//  EDOrderRequest.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/16.
//

import Foundation

class EDOrderRequest {
    static func getInfos(id: Int, completionHandler: @escaping ([Order]) -> Void) {
        EDNetWork.post("/order/getInfos", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Order(json: $0) })
        }
    }

    static func addOrder(order: OrderRequest, completionHandler: @escaping (Int) -> Void) {
        EDNetWork.post("/order/add", dataParameters: order) { json in
            guard let json = json else {
                return
            }
            EDUser.user.allOrders.append(json.intValue)
            completionHandler(json.intValue)
        }
    }

    static func updateOrder(order: OrderRequest, completionHandler: @escaping (Int) -> Void) {
        EDNetWork.post("/order/update", dataParameters: order) { json in
            guard let json = json else {
                return
            }
            EDUser.user.allOrders.append(json.intValue)
            completionHandler(json.intValue)
        }
    }

    static func deleteOrder(id: Int, completionHandler: @escaping (Int) -> Void) {
        EDNetWork.post("/order/update", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            EDUser.user.allOrders.removeAll(where: { $0 == id })
            completionHandler(json.intValue)
        }
    }
}
