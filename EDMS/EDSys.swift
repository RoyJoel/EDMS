//
//  EDSys.swift
//  TennisMoment
//
//  Created by Jason Zhang on 2023/3/6.
//

import Foundation
import Reachability
import TABAnimated

class EDSys {
    var reachability: Reachability?
    static let shard = EDSys()
    private init() {}

    func initWindow() -> UIWindow {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = initStyle()
        window.rootViewController = initRootViewController()
        window.makeKeyAndVisible()
        return window
    }

    func observeNetState() {
        if reachability == nil {
            do {
                reachability = try Reachability()
            } catch {
                print("Unable to create Reachability")
                return
            }
        }
        try? reachability?.startNotifier()
    }

    func initRootViewController() -> UIViewController {
        let isNotFirstDownload = UserDefaults.standard.bool(forKey: EDUDKeys.isNotFirstDownload.rawValue)
        if !isNotFirstDownload {
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: EDUDKeys.isNotFirstDownload.rawValue)
            }
            return EDSignInViewController()
        } else {
            return EDSignInViewController()
        }
    }

    func initStyle() -> UIUserInterfaceStyle {
        guard let appearance = UserDefaults.standard.string(forKey: "AppleAppearance") else {
            // 如果没有设置外观，则默认使用浅色模式。
            return .unspecified
        }
        let appearanceType = AppearanceSetting(userDisplayName: appearance)
        // 根据用户设置的外观来设置应用程序的外观。
        if appearanceType == .Dark {
            return .dark
        } else if appearanceType == .Light {
            return .light
        } else {
            return .unspecified
        }
    }
}
