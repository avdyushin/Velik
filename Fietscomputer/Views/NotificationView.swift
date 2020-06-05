//
//  NotificationView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 05/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct NotificationView<Presenting: View, Content: View>: View {

    var isShowing: Bool
    let presenting: () -> Presenting
    let content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                self.presenting()//.blur(radius: self.isShowing ? 1 : 0)
                Group {
                    self.content()
                }
                .frame(width: geometry.size.width * 0.8, height: 50)
                .padding()
                .background(Color(UIColor.systemBackground))
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)
                .shadow(radius: 10)
                .offset(y: 32)
            }
        }
    }
}
