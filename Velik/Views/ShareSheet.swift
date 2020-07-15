//
//  ShareSheet.swift
//  Velik
//
//  Created by Grigory Avdyushin on 03/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {

    typealias Callback = (
        _ activityType: UIActivity.ActivityType?,
        _ completed: Bool,
        _ returnedItems: [Any]?,
        _ error: Error?
    ) -> Void

    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
