//
//  AppDelegate.swift
//  Weather
//
//  Created by Timur Galimov on 08/03/16.
//  Copyright © 2016 Timur Galimov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        InitialLoader.loadInitialData()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        DataManager.sharedInstance.cacheCurrentData()
        DataManager.sharedInstance.cacheForecastData()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        DataManager.sharedInstance.cacheCurrentData()
        DataManager.sharedInstance.cacheForecastData()
    }
}

