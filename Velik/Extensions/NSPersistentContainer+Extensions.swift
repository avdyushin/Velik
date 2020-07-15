//
//  NSPersistentContainer+Extensions.swift
//  Velik
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData

extension NSPersistentContainer {
    convenience init(_ name: String) throws {
        self.init(
            name: name,
            managedObjectModel: try! PersistentContainer.model(name: name)
        )
    }
}
