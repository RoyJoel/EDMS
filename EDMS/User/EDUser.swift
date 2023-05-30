//
//  User.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/2/28.
//

import Alamofire
import CoreLocation
import CryptoKit
import Foundation
import SwiftyJSON
import UIKit

class EDUser {
    // 未登录时为默认信息
    static var user = User()

    static var commodities: [Commodity] = []

    static func signIn(completionHandler: @escaping (User?, Error?) -> Void) {
        // 将要加密的字符串连接在一起
        let password = user.password

        // 计算 SHA256 哈希值
        if let data = password.data(using: .utf8) {
            let hash = SHA256.hash(data: data)
            let hashString = hash.map { String(format: "%02x", $0) }.joined()

            let para = [
                "loginName": user.loginName,
                "password": hashString,
            ]
            EDNetWork.post("/user/signIn", dataParameters: para) { json in
                guard let json = json else {
                    completionHandler(nil, EDNetWorkError.netError("账号或密码错误"))
                    return
                }
                completionHandler(User(json: json), nil)
            }
        }
    }

    static func signUp(completionHandler: @escaping (String?, Error?) -> Void) {
        EDNetWork.post("/user/signUp", dataParameters: EDUser.user, responseBindingType: UserSignUpResponse.self) { response in
            guard let res = response else {
                completionHandler(nil, EDNetWorkError.netError("账号或密码错误"))
                return
            }
            EDUser.user = res.data.user
            completionHandler(EDUser.user.token, nil)
        }
    }

    static func resetPassword(completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": user.loginName,
            "password": user.password,
        ]
        EDNetWork.post("/user/resetPassword", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func updateInfo(completionHandler: @escaping (User?) -> Void) {
        EDNetWork.post("/user/update", dataParameters: EDUser.user) { json in
            guard let json = json else {
                completionHandler(nil)
                return
            }
            EDUser.user = User(json: json)
            completionHandler(EDUser.user)
        }
    }

    static func addFriend(_ friendId: Int, completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "player1Id": user.id,
            "player2Id": friendId,
        ]
        EDNetWork.post("/friend/add", dataParameters: para) { json in
            guard let json = json else {
                completionHandler(false)
                return
            }
            EDUser.user.friends = json.arrayValue.map { Player(json: $0) }
            completionHandler(true)
        }
    }

    static func deleteFriend(_ friendId: Int, completionHandler: @escaping ([Player]) -> Void) {
        let para = [
            "player1Id": user.id,
            "player2Id": friendId,
        ]
        EDNetWork.post("/friend/delete", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Player(json: $0) })
        }
    }

    static func getAllFriends(completionHandler: @escaping ([Player]) -> Void) {
        let para = [
            "player1Id": user.id,
        ]
        EDNetWork.post("/friend/getAll", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Player(json: $0) })
        }
    }

    static func searchFriend(_ friendId: Int, completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "player1Id": user.id,
            "player2Id": friendId,
        ]
        EDNetWork.post("/friend/search", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func getLocationdescription(completionHandler: @escaping (String) -> Void) {
        EDLocationManager.shared.startPositioning { _, location in
            completionHandler(location)
        }
    }

    static func getLocationCoor(completionHandler: @escaping (CLLocation) -> Void) {
        EDLocationManager.shared.startPositioning { location, _ in
            completionHandler(location)
        }
    }

    static func addSchedule(id: Int, startDate: TimeInterval, place: String, OpponentId: Int, completionHandler: @escaping (Schedule) -> Void) {
        EDNetWork.post("/schedule/add", dataParameters: [
            "id": id,
            "startDate": startDate,
            "place": place,
            "player1Id": user.id,
            "player2Id": OpponentId,
        ]) { res in
            guard let res = res else {
                return
            }
            completionHandler(Schedule(json: res))
        }
    }

    static func auth(token: String, completionHandler: @escaping (String?, String?, Error?) -> Void) {
        let headers: HTTPHeaders = ["Authorization": token]
        EDNetWork.get("/auth", headers: headers) { json, error in
            guard error == nil else {
                completionHandler(nil, nil, error)
                return
            }
            guard let json = json else {
                completionHandler(nil, nil, nil)
                return
            }
            completionHandler(json["loginName"].stringValue, json["password"].stringValue, nil)
        }
    }

    static func getDeviceID() -> String? {
        if let uuid = UIDevice.current.identifierForVendor {
            return uuid.uuidString
        }
        return nil
    }

    static func getCartInfo(completionHandler: @escaping (Order) -> Void) {
        EDNetWork.post("/cart/getInfo", dataParameters: ["id": EDUser.user.cart]) { json in
            guard let json = json else {
                return
            }
            completionHandler(Order(json: json))
        }
    }

    static func addToCart(bill: BillRequest, completionHandler: @escaping (Order) -> Void) {
        EDNetWork.post("/cart/addBill", dataParameters: bill) { json in
            guard let json = json else {
                return
            }
            completionHandler(Order(json: json))
        }
    }

    static func deleteBillInCart(bill: BillRequest, completionHandler: @escaping (Order) -> Void) {
        EDNetWork.post("/cart/deleteBill", dataParameters: bill) { json in
            guard let json = json else {
                return
            }
            completionHandler(Order(json: json))
        }
    }

    static func assignCart(completionHandler: @escaping (Int) -> Void) {
        EDNetWork.post("/cart/assign", dataParameters: ["id": EDUser.user.id]) { json in
            guard let json = json else {
                return
            }
            EDUser.user.cart = json.intValue
            completionHandler(json.intValue)
        }
    }
}
