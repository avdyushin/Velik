//
//  Location+Extension.swift
//  Fietscomputer
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

extension Collection where Element == CLLocation {

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

        let latitudinalMeters = southWest.distance(from: southEast)
        let longitudinalMeters = northEast.distance(from: northWest)

        let centerLatitude = (minLatitude + maxLatitude) / 2
        let centerLongitude = (minLongitude + maxLongitude) / 2

        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)

        return MKCoordinateRegion(
            center: center,
            latitudinalMeters: latitudinalMeters,
            longitudinalMeters: longitudinalMeters
        )
    }

    // TODO: Check calculations
    func accumulateDistance() -> AnyIterator<CLLocationDistance> {
        guard var current = self.first else {
            return AnyIterator { nil }
        }
        var distance: CLLocationDistance = 0.0
        var offset = 1

        return AnyIterator {
            guard self.index(self.startIndex, offsetBy: offset) != self.endIndex else {
                return nil
            }
            defer {
                let location = self[self.index(self.startIndex, offsetBy: offset)]
                distance += current.distance(from: location)
                offset += 1
                current = location
            }
            return distance
        }
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
