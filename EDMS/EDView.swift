//
//  EDView.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/4/27.
//

import Foundation
import TMComponent
import UIKit

class EDEventView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "BackgroundGray")
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in subviews {
            if view is EDFilterView {
                for subview in view.subviews {
                    if subview is TMPopUpView, subview.isHidden == false, CGRectContainsPoint(subview.frame, CGPoint(x: point.x - view.frame.minX, y: point.y - view.frame.minY)) {
                        return subview
                    }
                }
            }
        }
        return super.hitTest(point, with: event)
    }
}
