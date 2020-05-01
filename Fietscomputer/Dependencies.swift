//
//  Dependencies.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct Module {
    let service: Service
    let name: String
    init<T: Service>(_ resolve: @escaping () -> T) {
        self.service = resolve()
        self.name = String(describing: T.self)
    }
}

@dynamicMemberLookup
class Dependencies: Sequence {

    static private(set) var shared = Dependencies()

    fileprivate var modules = [String: Module]()

    @_functionBuilder struct ModuleBuilder {
        static func buildBlock(_ module: Module) -> Module { module }
        static func buildBlock(_ modules: Module...) -> [Module] { modules }
    }

    convenience init(@ModuleBuilder _ modules: () -> [Module]) {
        self.init()
        modules().forEach { register($0) }
    }

    func register(_ module: Module) {
        modules[module.name] = module
    }

    func build() {
        Self.shared = self
    }

    func resolve<T: Service>() -> T {
        let name = String(describing: T.self)
        guard let module = modules[name]?.service, let typed = module as? T else {
            fatalError("Can't resolve \(T.self)")
        }
        return typed
    }

    subscript(dynamicMember module: String) -> Service! {
        return modules[module.capitalized]!.service
    }

    func makeIterator() -> AnyIterator<Service> {
        var iter = modules.values.makeIterator()
        return AnyIterator { iter.next()?.service }
    }
}

@propertyWrapper
struct Injected<Dependency: Service> {

    var dependency: Dependency!

    var wrappedValue: Dependency {
        mutating get {
            if dependency == nil {
                let deps: Dependency = Dependencies.shared.resolve()
                self.dependency = deps
            }
            return dependency
        }
        mutating set {
            dependency = newValue
        }
    }
}
