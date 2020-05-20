//
//  ActionButtonStyle.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.title))
            .foregroundColor(Color.white)
            .padding(12)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                Rectangle()
                    .fill()
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
        )
    }
}
