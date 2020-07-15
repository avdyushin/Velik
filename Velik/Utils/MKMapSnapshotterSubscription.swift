//
//  MKMapSnapshotterSubscription.swift
//  Velik
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import Combine
import Foundation
import class UIKit.UIImage

class MKMapSnapshotterSubscription<S: Subscriber>: Subscription where S.Input == UIImage?, S.Failure == Error {

    private var subscriber: S?
    private let snapshotter: MKMapSnapshotter
    private let processor: MapSnapshotProcessor
    private let queue = DispatchQueue(label: "MKMapSnapshot", qos: .background, attributes: .concurrent)

    init(subscriber: S, snapshotter: MKMapSnapshotter, processor: MapSnapshotProcessor) {
        self.subscriber = subscriber
        self.snapshotter = snapshotter
        self.processor = processor
        start()
    }

    func request(_ demand: Subscribers.Demand) {
    }

    func cancel() {
        snapshotter.cancel()
        subscriber = nil
    }

    private func start() {
        snapshotter.start(with: queue) { [subscriber, processor, queue] snapshot, error in
            dispatchPrecondition(condition: .onQueue(queue))
            if let error = error {
                _ = subscriber?.receive(completion: .failure(error))
            } else {
                _ = subscriber?.receive(processor.process(snapshot))
            }
        }
    }
}

struct MKMapSnapshotterPublisher: Publisher {

    typealias Output = UIImage?
    typealias Failure = Error

    private let snapshotter: MKMapSnapshotter
    private let processor: MapSnapshotProcessor

    init(snapshotter: MKMapSnapshotter, processor: MapSnapshotProcessor) {
        self.snapshotter = snapshotter
        self.processor = processor
    }

    func receive<S: Subscriber>(subscriber: S) where Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = MKMapSnapshotterSubscription(
            subscriber: subscriber, snapshotter: snapshotter, processor: processor
        )
        subscriber.receive(subscription: subscription)
    }
}
