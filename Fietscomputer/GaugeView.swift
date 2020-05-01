//
//  GaugeView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat

    func body(content: Content) -> some View {
        let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}

extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        self.modifier(ScaledFont(name: name, size: size))
    }
}

struct GaugeView<ViewModel: GaugeViewModel>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Text(viewModel.value)
            .scaledFont(name: "DIN Alternate", size: CGFloat(viewModel.fontSize))
    }
}
