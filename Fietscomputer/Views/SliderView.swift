//
//  PullView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

class SliderPosition: ObservableObject {
    @Published var value: CGFloat = 0
    @Published var previous: CGFloat = 0
}

struct SliderView<Content: View>: View {

    @ObservedObject var position: SliderPosition
    var geometry: GeometryProxy
    var range: ClosedRange<CGFloat>

    let content: () -> Content

    var body: some View {
        Group {
            content()
        }
        .offset(y: position.value)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged(gesture:))
                .onEnded(onDragEnded(gesture:))
        )
    }

    fileprivate func onDragChanged(gesture: DragGesture.Value) {
        let height = position.previous + gesture.translation.height
        let high = geometry.size.height * (0.5 - range.lowerBound)
        let low = geometry.size.height * (0.5 - range.upperBound)
        position.value = max(low, min(high, height))
    }

    fileprivate func onDragEnded(gesture: DragGesture.Value) {
        position.previous = position.value
    }
}
