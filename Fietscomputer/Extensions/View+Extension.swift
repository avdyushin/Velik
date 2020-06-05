//
//  View+Extension.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 14/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

extension View {

    func scaledFont(name: String, size: CGFloat) -> some View {
        modifier(ScaledFont(name: name, size: size))
    }

    func notify<Content: View>(isShowing: Bool, _ content: @escaping () -> Content) -> some View {
        NotificationView(isShowing: isShowing, presenting: { self }, content: content)
    }
}
