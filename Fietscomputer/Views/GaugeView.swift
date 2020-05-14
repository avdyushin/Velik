//
//  GaugeView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct GaugeView<ViewModel: GaugeViewModel>: View {

    @ObservedObject var viewModel: ViewModel
    @State var offset = CGSize.zero

    var body: some View {
        Text(viewModel.value)
            .scaledFont(name: "DIN Alternate", size: CGFloat(viewModel.fontSize))
//            .offset(self.offset)
//            .gesture(
//                DragGesture()
//                    .onChanged { gesture in
//                        self.offset = gesture.translation
//                }
//                .onEnded { gesture in
//                    self.offset = .zero
//                }
//        )
    }
}
