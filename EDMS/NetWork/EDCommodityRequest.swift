//
//  EDCommodityRequest.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/15.
//

import Foundation

class EDCommodityRequest {
    static func getAll(completionHandler: @escaping ([Commodity]) -> Void) {
        EDNetWork.get("/commodity/getAll") { json, _ in
            guard let json = json else {
                return
            }
            EDUser.commodities = json.arrayValue.compactMap { Commodity(json: $0) }
            completionHandler(json.arrayValue.compactMap { Commodity(json: $0) })
        }
    }
}
