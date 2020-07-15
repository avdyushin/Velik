//
//  ActionButton.swift
//  Velik
//
//  Created by Grigory Avdyushin on 27/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct ActionButton: View {

    enum Intention {
        case startPause
        case stop
    }

    @ObservedObject var goViewModel: GoButtonViewModel
    @ObservedObject var stopViewModel: StopButtonViewModel

    var stopButtonColor: Color {
        if stopViewModel.isToggled {
            return .gray
        } else {
            return .red
        }
    }

    var goButtonColor: Color {
        if stopViewModel.isToggled {
            return .red
        } else if stopViewModel.isVisible {
            return .orange
        } else {
            return .green
        }
    }

    let handler: (Intention) -> Void

    var body: some View {
        Group {
            HStack(spacing: 0) {
                if stopViewModel.isVisible {
                    Button(action: {
                        self.stopViewModel.isToggled.toggle()
                    }, label: {
                        HStack {
                            Text(stopViewModel.title)
                        }.frame(minWidth: 0, maxWidth: .infinity)
                    })
                        .foregroundColor(stopButtonColor)
                        .buttonStyle(ActionButtonStyle())
                }
                Button(action: {
                    if self.stopViewModel.isToggled {
                        // Stop
                        self.handler(.stop)
                        self.stopViewModel.isToggled.toggle()
                    } else {
                        // Go, Pause, Resume
                        self.handler(.startPause)
                    }
                }, label: {
                    if self.stopViewModel.isToggled {
                        Image(systemName: "stop.fill")
                    } else {
                        goViewModel.state.view()
                    }
                })
                    .foregroundColor(goButtonColor)
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
