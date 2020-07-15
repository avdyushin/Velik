//
//  Location+Extension.swift
//  Velik
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import CoreLocation

extension Double {
    func asRadians() -> Double {
        Measurement(value: self, unit: UnitAngle.degrees).converted(to: .radians).value
    }
    func asDegrees() -> Double {
        Measurement(value: self, unit: UnitAngle.radians).converted(to: .degrees).value
    }
}

typealias LocationWithDistance = (location: CLLocation, distance: Measurement<UnitLength>)

extension Collection where Element == CLLocation, Index == Int {

    /// See: http://www.geomidpoint.com/calculation.html
    func center() -> Element? {
        guard !isEmpty else {
            return nil
        }
        guard count > 1 else {
            return self.first!
        }

        var x = Double.zero
        var y = Double.zero
        var z = Double.zero

        forEach {
            let lat = $0.coordinate.latitude.asRadians()
            let lon = $0.coordinate.longitude.asRadians()
            x += cos(lat) * cos(lon)
            y += cos(lat) * sin(lon)
            z += sin(lat)
        }

        x /= Double(count)
        y /= Double(count)
        z /= Double(count)

        let lon = atan2(y, x)
        let hyp = sqrt(x * x + y * y)
        let lat = atan2(z, hyp)

        return CLLocation(latitude: lat.asDegrees(), longitude: lon.asDegrees())
    }

    func region() -> MKCoordinateRegion? {
        guard count > 1 else {
            return nil
        }

        let minLatitude = self.min(by: \.coordinate.latitude)!.coordinate.latitude
        let minLongitude = self.min(by: \.coordinate.longitude)!.coordinate.longitude
        let maxLatitude = self.max(by: \.coordinate.latitude)!.coordinate.latitude
        let maxLongitude = self.max(by: \.coordinate.longitude)!.coordinate.longitude

        let southWest = CLLocation(latitude: minLatitude, longitude: minLongitude)
        let southEast = CLLocation(latitude: minLatitude, longitude: maxLongitude)
        let northEast = CLLocation(latitude: maxLatitude, longitude: maxLongitude)
        let northWest = CLLocation(latitude: maxLatitude, longitude: minLongitude)

        let latitudinalMeters = Swift.max(southWest.distance(from: northWest), southEast.distance(from: northEast))
        let longitudinalMeters = Swift.max(southWest.distance(from: southEast), northEast.distance(from: northWest))

        let delta = Swift.max(latitudinalMeters, longitudinalMeters)

        let centerLatitude = (minLatitude + maxLatitude) / 2
        let centerLongitude = (minLongitude + maxLongitude) / 2

        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)

        return MKCoordinateRegion(
            center: center,
            latitudinalMeters: delta,
            longitudinalMeters: delta
        )
    }

    func accumulateDistance() -> AnyIterator<CLLocationDistance> {
        guard var current = self.first else {
            return AnyIterator { nil }
        }
        var distance: CLLocationDistance = 0.0
        var index = 1

        return AnyIterator {
            guard index != self.count else { return nil }
            defer {
                current = self[index]
                index += 1
            }
            distance += current.distance(from: self[index])
            return distance
        }
    }

    func distanceLocations(_ block: (LocationWithDistance) -> Void) {
        distanceLocations().forEach(block)
    }

    func distanceLocations() -> [LocationWithDistance] {
        guard let total = accumulateDistance().max() else {
            return []
        }

        return distanceLocations(step: DistanceUtils.step(for: total))
    }

    func distanceLocations(step: Measurement<UnitLength>) -> [LocationWithDistance] {
        precondition(step.value > 0)

        var result = [LocationWithDistance]()
        var total = Measurement<UnitLength>(value: 0, unit: step.unit)
        let stepValue = step.value
        accumulateDistance().enumerated().forEach { index, distance in
            let location = self[index]
            let meters = Measurement<UnitLength>(value: distance, unit: .meters)
            if Int(meters.converted(to: step.unit).value / stepValue) > Int(total.value / stepValue) {
                total.value += stepValue
                result.append((location, total))
            }
        }
        return result
    }
}

extension CLLocationCoordinate2D {
    init(trackPoint: TrackPoint) {
        self.init(latitude: trackPoint.latitude, longitude: trackPoint.longitude)
    }
}

extension CLLocation {
    convenience init(wayPoint: GPXPoint) {
        self.init(
            coordinate: CLLocationCoordinate2D(
                latitude: wayPoint.latitude,
                longitude: wayPoint.longitude),
            altitude: wayPoint.elevation ?? 0,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            course: 0,
            speed: wayPoint.speed ?? 0,
            timestamp: wayPoint.timestamp ?? Date()
        )
    }
}

extension CLLocation {
    convenience init(trackPoint: TrackPoint) {
        self.init(
            coordinate: CLLocationCoordinate2D(
                latitude: trackPoint.latitude,
                longitude: trackPoint.longitude),
            altitude: trackPoint.elevation,
            horizontalAccuracy: 0,
            verticalAccuracy: 0,
            course: 0,
            speed: trackPoint.speed,
            timestamp: trackPoint.timestamp
        )
    }
}
