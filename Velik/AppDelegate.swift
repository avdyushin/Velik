//
//  AppDelegate.swift
//  Velik
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import Combine
import CoreData
import Injected

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var cancellable = Set<AnyCancellable>()

    let dependencies = Dependencies {
        Dependency { LocationPermissions() }
        Dependency { StorageService() }
        Dependency { LocationService() }
        Dependency { RideService() }
        Dependency { HeartRateService() }
        Dependency { GPXImporter() }
        Dependency { GPXExporter() }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
