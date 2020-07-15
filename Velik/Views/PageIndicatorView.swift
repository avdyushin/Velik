//
//  PageIndicatorView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 27/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct PageIndicatorView: View {
    var index: Int
    var action: () -> Void

    var body: some View {
        Button(action: { withAnimation { self.action() } }, label: {
            ZStack {
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 16, height: 16)
                Circle()
                    .fill()
                    .frame(width: 8, height: 8)
            }
        })
    }
}

struct PageIndicatorModifier: ViewModifier {
    let index: Int
    @Binding var currentIndex: Int

    func body(content: Content) -> some View {
        content.opacity(index == currentIndex ? 1.0 : 0.3)
    }
}
