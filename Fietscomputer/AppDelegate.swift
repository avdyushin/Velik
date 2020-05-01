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

    private var cancellables = Set<AnyCancellable>()

    private let dependencies = Dependencies {
        Module { LocationService() }
        Module { RideService() }
        Module { HeartRateScanner() }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        dependencies.build()

        let permissions = LocationPermissions()
        permissions.status.flatMap { status -> AnyPublisher<LocationPermissions.Status, Never> in
            switch status {
            case .notDetermined, .restricted:
                debugPrint("will request")
                return permissions.request().replaceError(with: .denied).eraseToAnyPublisher()
            default:
                debugPrint("no need to request")
                return Just(status).eraseToAnyPublisher()
            }
        }
        .receive(on: DispatchQueue.main)
        .removeDuplicates()
        .sink { [dependencies] status in
            debugPrint("has status", status.rawValue)
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                //dependencies.forEach {
                //    $0.start()
                //}
                dependencies.locationService.start()
                dependencies.heartRateScanner.start()
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
