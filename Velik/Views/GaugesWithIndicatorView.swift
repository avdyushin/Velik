//
//  GaugesWithIndicatorView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 27/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct GaugesWithIndicatorView: View {

    @ObservedObject var viewModel: ContentViewModel
    @State var pageIndex: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            GaugesView(viewModel: viewModel, pageIndex: self.$pageIndex)
                .padding([.top, .bottom], 12)
            ZStack(alignment: .bottomTrailing) {
                HStack(spacing: 12) {
                    ForEach(0..<viewModel.numberOfPages, id: \.self) { index in
                        PageIndicatorView(index: index) { self.pageIndex = index }
                            .foregroundColor(Color(UIColor.label))
                            .modifier(PageIndicatorModifier(index: index, currentIndex: self.$pageIndex))
                    }
                }.frame(minWidth: 0, maxWidth: .infinity)
            }.padding(.bottom, 12)
        }
    }
}
