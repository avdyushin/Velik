//
//  PageIndicatorView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct PageIndicatorView: View {
    var index: Int
    var action: () -> Void

    var imageName: String {
        switch index {
        case 0: return "speedometer"
        case 1: return "timer"
        case 2: return "heart.circle"
        case 3: return "location.circle"
        default: return "circle"
        }
    }
    var body: some View {
        Button(action: { withAnimation { self.action() } }, label: {
            ZStack {
//                Rectangle()
//                    .foregroundColor(.clear)
//                    .frame(width: 24, height: 24)
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 24, height: 24)
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
