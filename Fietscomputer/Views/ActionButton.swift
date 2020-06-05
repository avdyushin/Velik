//
//  ActionButton.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct ActionButton: View {

    enum Index {
        case left
        case right
    }

    @ObservedObject var goViewModel: GoButtonViewModel
    @ObservedObject var stopViewModel: StopButtonViewModel

    let handler: (Index) -> Void

    var body: some View {
        Group {
            HStack(spacing: 0) {
                if stopViewModel.isVisible {
                    Button(
                        action: { self.handler(.left) },
                        label: {
                            HStack {
                                Image(systemName: "xmark")
                                Text("Stop")
                            }.frame(minWidth: 0, maxWidth: .infinity)
                        }
                    )
                        .foregroundColor(.red)
                        .buttonStyle(ActionButtonStyle())
                }
                Button(
                    action: { self.handler(.right) },
                    label: { goViewModel.state.view() }
                )
                    .foregroundColor(stopViewModel.isVisible ? .orange : .green)
                    .scaleEffect(stopViewModel.isVisible ? 0.9 : 1.0)
                    .buttonStyle(RoundButtonStyle())
            }
        }.padding([.leading, .trailing], 32)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(goViewModel: GoButtonViewModel(), stopViewModel: StopButtonViewModel(), handler: { _ in })
    }
}
