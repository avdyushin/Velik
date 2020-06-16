//
//  RootCoordinator.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 11/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import SwiftUI

class RootCoordinator: Coordinator, ViewRunner {

    private weak var window: UIWindow?
    private let sharedMapView = MKMapView()

    init(window: UIWindow?) {
        self.window = window
    }

    func start() -> some View {
        debugPrint("\(self) started")
        let contentView = RootViewFactory.make(with: self)
            .environment(\.mkMapView, sharedMapView)
        window?.rootViewController = UIHostingController(rootView:
            contentView //NavigationView { contentView }
        )
        window?.makeKeyAndVisible()
        return EmptyView()
    }

    func presentHistory(isPresented: Binding<Bool>) -> some View {
        route(to: HistoryCoordinator(isPresented: isPresented))
    }
}
