//
//  MKMapSnapshotterSubsription.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import class UIKit.UIImage
import MapKit
import Combine

class MKMapSnapshotterSubscription<S: Subscriber>: Subscription where S.Input == UIImage?, S.Failure == Error {

    private var subscriber: S?
    private let snapshotter: MKMapSnapshotter
    private let queue = DispatchQueue(label: "MapSnapshotter")

    init(subscriber: S, snapshotter: MKMapSnapshotter) {
        self.subscriber = subscriber
        self.snapshotter = snapshotter
        start()
    }

    func request(_ demand: Subscribers.Demand) {
    }

    func cancel() {
        snapshotter.cancel()
        subscriber = nil
    }

    private func start() {
        snapshotter.start(with: queue) { [subscriber] snapshot, error in
            if let error = error {
                _ = subscriber?.receive(completion: .failure(error))
            } else {
                _ = subscriber?.receive(snapshot?.image)
            }
        }
    }
}

struct MKMapSnapshotterPublisher: Publisher {

    typealias Output = UIImage?
    typealias Failure = Error

    private let snapshotter: MKMapSnapshotter

    init(snapshotter: MKMapSnapshotter) {
        self.snapshotter = snapshotter
    }

    func receive<S: Subscriber>(subscriber: S) where Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = MKMapSnapshotterSubscription(subscriber: subscriber, snapshotter: snapshotter)
        subscriber.receive(subscription: subscription)
    }
}

extension MKMapSnapshotter {

    func publisher() -> MKMapSnapshotterPublisher {
        MKMapSnapshotterPublisher(snapshotter: self)
    }
}
