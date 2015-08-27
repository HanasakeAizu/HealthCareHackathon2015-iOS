//
//  AppDelegate.swift
//  HackathonAnimationDemo
//
//  Created by Ryohei Komiya on 2015/08/26.
//  Copyright (c) 2015年 HANASAKE PICTURES Inc. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        AnimationDownloader.downloader.preloadAnimations()
        return true
    }
}

