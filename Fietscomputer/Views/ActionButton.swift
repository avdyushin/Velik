//
//  ActionButton.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

//struct SwitchButton<ContentA: View, ContentB: View, Result: View>: View {
//    typealias State = ActionButtonViewModel.ButtonState
//    let state: State
//    let content: Result
//    init(state: State,
//    @ViewBuilder contentA: @escaping (State) -> ContentA, @ViewBuilder contentB: @escaping (State) -> ContentB) {
//        switch state {
//        case .single:
//            content = contentA(state)
//        case .double
//            content = contentB(state)
//        }
//    }
//    var body: some View {
//        content
//    }
//}

struct ActionButton: View {

    enum Index {
        case left
        case right
    }

    @ObservedObject var viewModel: ActionButtonViewModel
    let handler: (Index) -> Void

    var body: some View {
        HStack(spacing: 0) {
            if viewModel.isMultiButton {
                Button(action: { self.handler(.left) }) {
                    Text(viewModel.leftTitle)
                }
                .foregroundColor(.red)
            }
            Button(action: { self.handler(.right) }) {
                Text(viewModel.rightTitle)
            }
            .foregroundColor(.green)
        }
        .buttonStyle(ActionButtonStyle())
    }
}
