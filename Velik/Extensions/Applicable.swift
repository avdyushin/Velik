//
//  Applicable.swift
//  Velik
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData

protocol Applicable { }

extension Applicable where Self: AnyObject {

    @inlinable
    func apply(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
}

extension NSObject: Applicable { }
