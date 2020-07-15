//
//  ActionButtonStyle.swift
//  Velik
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            configuration.label
                .font(.system(.body))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: geometry.size.height / 2)
                        .stroke(lineWidth: 2)
                        .fill()
                        .background(Color(UIColor.systemBackground))
            )
        }
        .opacity(configuration.isPressed ? 0.5 : 1.0)
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}
