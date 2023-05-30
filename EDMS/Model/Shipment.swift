//
//  Shipment.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/28.
//

import Foundation

struct Shipment {
    let eBusinessID: String
    let shipperCode: String
    let success: Bool
    let logisticCode: String
    let state: String
    let stateEx: String
    let location: String
    let traces: [Trace]
}
