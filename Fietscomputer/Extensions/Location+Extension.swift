//
//  Location+Extension.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreLocation

extension Double {
    func asRadians() -> Double {
        Measurement(value: self, unit: UnitAngle.degrees).converted(to: .radians).value
    }
    func asDegrees() -> Double {
        Measurement(value: self, unit: UnitAngle.radians).converted(to: .degrees).value
    }
}

extension Collection where Element == CLLocationCoordinate2D {

    /// See: http://www.geomidpoint.com/calculation.html
    func middle() -> Element? {
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
            let lat = $0.latitude.asRadians()
            let lon = $0.longitude.asRadians()
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

        return CLLocationCoordinate2D(latitude: lat.asDegrees(), longitude: lon.asDegrees())
    }
}
