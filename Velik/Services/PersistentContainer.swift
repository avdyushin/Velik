//
//  PersistentContainer.swift
//  Velik
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData

class PersistentContainer {

    enum Errors: Error {
        case resourceNotFound
        case modelNotFound
    }

    private static var cached: NSManagedObjectModel!

    static func model(name: String, bundle: Bundle = .main) throws -> NSManagedObjectModel {
        if cached == nil {
            cached = try load(name: name, bundle: bundle)
        }
        return cached
    }

    private static func load(name: String, bundle: Bundle) throws -> NSManagedObjectModel {
        guard let url = bundle.url(forResource: name, withExtension: "momd") else {
            throw Errors.resourceNotFound
        }
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            throw Errors.modelNotFound
        }
        return model
    }
}
