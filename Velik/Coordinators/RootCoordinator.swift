//
//  RootCoordinator.swift
//  Velik
//
//  Created by Grigory Avdyushin on 11/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import SwiftUI
import Injected

class RootCoordinator: Coordinator, ViewRunner {

    @Injected var storage: StorageService

    private weak var window: UIWindow?
    private let sharedMapView = MKMapView()

    init(window: UIWindow?) {
        self.window = window
    }

    func start() -> some View {
        let contentView = RootViewFactory.make(with: self)
            .environment(\.mkMapView, sharedMapView)
            .environment(\.managedObjectContext, storage.storage.mainContext)

        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()
        return EmptyView()
    }

    func presentHistory(isPresented: Binding<Bool>) -> some View {
        route(to: HistoryCoordinator(isPresented: isPresented))
    }
}
