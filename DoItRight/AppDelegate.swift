//
//  AppDelegate.swift
//  DoItRight
//
//  Created by Shalev Lazarof on 09/07/2019.
//  Copyright © 2019 Shalev Lazarof. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: realm Path
        // print(Realm.Configuration.defaultConfiguration.fileURL)
         
        do {
            _ = try Realm()
        } catch {
            print("error init realm \(error)")
        }
        
        return true
    }
}

