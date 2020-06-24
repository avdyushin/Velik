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
import Injected

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var cancellables = Set<AnyCancellable>()

    let dependencies = Dependencies {
        Dependency { StorageService() }
        Dependency { LocationService() }
        Dependency { RideService() }
        Dependency { HeartRateService() }
        Dependency { GPXImporter() }
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

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
                dependencies
                    .compactMap { $0 as? Service }
                    .filter { $0.shouldAutostart }
                    .forEach { $0.start() }
            case .restricted:
                debugPrint("Restricted, rerequest?")
            case .denied:
                debugPrint("Denied, show banner")
            default:
                debugPrint("Can't start location service")
            }
        }
        .store(in: &cancellables)
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
