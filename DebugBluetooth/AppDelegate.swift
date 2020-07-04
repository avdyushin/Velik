//
//  AppDelegate.swift
//  DebugBluetooth
//
//  Created by Grigory Avdyushin on 05/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Cocoa
import Combine
import SwiftUI
import CoreBluetooth

struct Device {
    let peripheral: CBPeripheral

//
//    var services: Future<[CBService], Error> {
//        let _ = Future<[CBService], Error> { promise in
//
//        }
//    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    let scanner = HeartRateService()
    var cancellable = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        scanner.start()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
