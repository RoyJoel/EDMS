//
//  Option.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/15.
//

import Foundation
import SwiftyJSON

struct Option: Codable, Equatable {
    var id: Int
    var image: String
    var intro: String

    init(id: Int, image: String, intro: String) {
        self.id = id
        self.image = image
        self.intro = intro
    }

    init(json: JSON) {
        id = json["id"].intValue
        image = json["image"].stringValue
        intro = json["intro"].stringValue
    }

    init() {
        self = Option(json: JSON())
    }

    init?(dict: [String: Any]) {
        guard let id = dict["id"] as? Int,
            let image = dict["image"] as? String,
            let intro = dict["intro"] as? String
        else {
            return nil
        }

        self.init(id: id, image: image, intro: intro)
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "image": image,
            "intro": intro,
        ]
    }

    static func == (lhs: Option, rhs: Option) -> Bool {
        return lhs.id == rhs.id &&
            lhs.image == rhs.image &&
            lhs.intro == rhs.intro
    }
}
