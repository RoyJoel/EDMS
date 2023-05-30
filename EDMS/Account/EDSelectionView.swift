//
//  EDSelectionView.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/16.
//

import Foundation
import UIKit
class EDSelectionView: UIView {
    var isLeft: Bool = true
    lazy var leftServerView: EDServerView = {
        let serveView = EDServerView()
        return serveView
    }()

    lazy var rightServerView: EDServerView = {
        let serveView = EDServerView()
        return serveView
    }()

    func setupUI() {
        addSubview(leftServerView)
        addSubview(rightServerView)
        leftServerView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        rightServerView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        leftServerView.addTapGesture(self, #selector(changeServe))
        rightServerView.addTapGesture(self, #selector(changeServe))
    }

    func setupEvent(config: EDServeViewConfig) {
        leftServerView.setup(isServing: isLeft, config: EDServeViewConfig(selectedImage: config.selectedImage, unSelectedImage: config.unSelectedImage, selectedTitle: config.selectedTitle, unselectedTitle: config.selectedTitle))
        rightServerView.setup(isServing: !isLeft, config: EDServeViewConfig(selectedImage: config.selectedImage, unSelectedImage: config.unSelectedImage, selectedTitle: config.unselectedTitle, unselectedTitle: config.unselectedTitle))
    }

    @objc func changeServe() {
        isLeft.toggle()
        leftServerView.changeStats(to: isLeft)
        rightServerView.changeStats(to: !isLeft)
    }
}
