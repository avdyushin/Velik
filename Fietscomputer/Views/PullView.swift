//
//  PullView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct PullView<Content: View>: View {

    enum DragState {
        case inactive
        case active(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive: return .zero
            case .active(let translation): return translation
            }
        }
    }

    @GestureState private var dragState = DragState.inactive {
        didSet {
            debugPrint(dragState)
        }
    }


    @Binding var height: CGFloat
    let content: () -> Content

//    init(_ content: @escaping () -> Content) {
//        self.content = content
//    }

    var body: some View {
        Group {
            content()
        }
        .offset(y: dragState.translation.height)
        .gesture(
            DragGesture()
                .updating($dragState) { gesture, state, _ in
                    state = .active(translation: gesture.translation)
                }
                .onChanged(onDragChanged(sender:))
                .onEnded(onDragEnded(sender:))
        )
    }

    func onDragChanged(sender: DragGesture.Value) {
        height = dragState.translation.height
    }

    func onDragEnded(sender: DragGesture.Value) {
        debugPrint("Ended")
    }
}
