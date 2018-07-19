//
//  AppDelegate.swift
//  RealmCachingDemo
//
//  Created by Sam Watts on 19/07/2018.
//  Copyright © 2018 Curve. All rights reserved.
//

import UIKit

extension UIColor {

    class var random: UIColor {

        let hue = Double(arc4random()).truncatingRemainder(dividingBy: 256) / 256
        let saturation = Double(arc4random()).truncatingRemainder(dividingBy: 128) / 256 + 0.5
        let brightness = Double(arc4random()).truncatingRemainder(dividingBy: 128) / 256 + 0.5

        return UIColor(hue: CGFloat(hue), saturation: CGFloat(saturation), brightness: CGFloat(brightness), alpha: 1)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()

        window?.rootViewController = WalletViewController()

        window?.makeKeyAndVisible()

        return true
    }
}

