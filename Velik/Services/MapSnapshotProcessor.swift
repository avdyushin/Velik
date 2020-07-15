//
//  MapSnapshotProcessor.swift
//  Velik
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapSnapshotProcessor {
    func process(_ snapshot: MKMapSnapshotter.Snapshot?) -> UIImage?
}
