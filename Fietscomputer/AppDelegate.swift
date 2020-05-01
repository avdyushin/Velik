//
//  AppDelegate.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import Combine
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var cancellables = Set<AnyCancellable>()
    var service = LocationService()
    var rideService = RideService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let p = LocationPermissions()
        p.status.flatMap { status -> AnyPublisher<LocationPermissions.Status, Never> in
            switch status {
            case .notDetermined, .restricted:
                debugPrint("will request")
                return p.request().replaceError(with: .denied).eraseToAnyPublisher()
            default:
                debugPrint("no need to request")
                return Just(status).eraseToAnyPublisher()
            }
        }
        .receive(on: DispatchQueue.main)
        .removeDuplicates()
        .sink { [service, rideService] status in

            debugPrint("has status", status.rawValue)

            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                service.start()
                rideService.start()
            default:
                debugPrint("Can't start location service")
            }
        }
        .store(in: &cancellables)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
