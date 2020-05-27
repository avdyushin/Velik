//
//  SliderControlView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct SliderControlView: View {

    var body: some View {
        Group {
            Rectangle()
                .foregroundColor(Color(UIColor.systemBackground))
                .frame(minWidth:0, maxWidth: .infinity, minHeight: 6, maxHeight: 6)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: -5)
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color(UIColor.separator))
                .frame(width: 48, height: 3)
        }
    }
}
