//
//  RootPresenting.swift
//  Velik
//
//  Created by Grigory Avdyushin on 11/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import SplitView

class Presenter<C: Coordinator> {
    private(set) weak var coordinator: C?

    init(coordinator: C) {
        self.coordinator = coordinator
    }

    deinit {
        self.coordinator?.stop()
    }
}

protocol RootPresenting: ObservableObject {
    associatedtype Content: View

    var viewModel: ContentViewModel { get }

    func onHistoryPressed(isPresented: Binding<Bool>) -> Content
}

class RootPresenter<C: RootCoordinator>: Presenter<C>, RootPresenting {

    @Published private(set) var viewModel: ContentViewModel

    override init(coordinator: C) {
        self.viewModel = ContentViewModel(
            mapViewModel: MapViewModel(),
            speedViewModel: SpeedViewModel(),
            avgSpeedViewModel: AvgSpeedViewModel(),
            durationViewModel: DurationViewModel(),
            distanceViewModel: DistanceViewModel(),
            notificationViewModel: NotificationViewModel(),
            sliderViewModel: SliderControlViewModel(middle: 0.5, range: 0.4...0.85)
        )
        super.init(coordinator: coordinator)
    }

    func onHistoryPressed(isPresented: Binding<Bool>) -> some View {
        coordinator?.presentHistory(isPresented: isPresented)
    }
}

enum RootViewFactory {

    static func make<C: RootCoordinator>(with coordinator: C) -> some View {
        ContentView(presenter: RootPresenter(coordinator: coordinator))
    }
}
