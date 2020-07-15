//
//  ValueDescriptionView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct ValueDescriptionView: View {
    let text: String
    let details: String

    var body: some View {
        VStack {
            Text(text)
                .font(.headline)
            Text(details.localizedUppercase)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
