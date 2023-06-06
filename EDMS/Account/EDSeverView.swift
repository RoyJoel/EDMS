//
//  EDSeverView.swift
//  EDMS
//
//  Created by Jason Zhang on 2023/5/16.
//

import Foundation
import TMComponent
import UIKit

class EDServerView: TMView {
    var config = EDServeViewConfig(selectedImage: "", unSelectedImage: "", selectedTitle: "", unselectedTitle: "")
    lazy var selectionView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func setup(isServing: Bool, config: EDServeViewConfig) {
        self.config = config
        addSubview(selectionView)
        addSubview(textLabel)

        selectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }

        textLabel.snp.makeConstraints { make in
            make.top.equalTo(selectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }

        textLabel.textAlignment = .center
        selectionView.isUserInteractionEnabled = true
        textLabel.isUserInteractionEnabled = true
        if isServing {
            selectionView.image = UIImage(systemName: config.selectedImage)?.withTintColor(UIColor(named: "Tennis") ?? .black, renderingMode: .alwaysOriginal)
            textLabel.text = NSLocalizedString(config.selectedTitle, comment: "")
        } else {
            selectionView.image = UIImage(systemName: config.unSelectedImage)?.withTintColor(UIColor(named: "Tennis") ?? .black, renderingMode: .alwaysOriginal)
            textLabel.text = NSLocalizedString(config.unselectedTitle, comment: "")
        }
    }

    func changeStats(to isSelected: Bool) {
        if isSelected {
            selectionView.image = UIImage(systemName: config.selectedImage)?.withTintColor(UIColor(named: "Tennis") ?? .black, renderingMode: .alwaysOriginal)
            textLabel.text = NSLocalizedString(config.selectedTitle, comment: "")
        } else {
            selectionView.image = UIImage(systemName: config.unSelectedImage)?.withTintColor(UIColor(named: "Tennis") ?? .black, renderingMode: .alwaysOriginal)
            textLabel.text = NSLocalizedString(config.unselectedTitle, comment: "")
        }
    }
}

class EDServeViewConfig {
    var selectedImage: String
    var unSelectedImage: String
    var selectedTitle: String
    var unselectedTitle: String

    init(selectedImage: String, unSelectedImage: String, selectedTitle: String, unselectedTitle: String) {
        self.selectedImage = selectedImage
        self.unSelectedImage = unSelectedImage
        self.selectedTitle = selectedTitle
        self.unselectedTitle = unselectedTitle
    }
}
