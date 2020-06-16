//
//  MenuButtonStyle.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 11/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct MenuButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .fill()
                .foregroundColor(configuration.isPressed ? .green : .white)
                .frame(width: 36, height: 36)
                .shadow(radius: 2)
            configuration.label
                .foregroundColor(configuration.isPressed ? .white : .green)
        }
        //.opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}
