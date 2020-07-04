//
//  LineChartView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LineChartView<S: ShapeStyle>: View {

    let values: [Double]
    let fillStyle: S

    let yLabels = [0, 10, 30, 40, 50]
    let xLabels = [10, 20, 30, 40, 50]

    @State private var scale = MountainShape.AnimatableData(1.0, 0.0)

    private let gridSize = CGSize(width: 16, height: 16)

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .trailing) {
                    ForEach(0..<yLabels.count, id: \.self) { index in
                        Group {
                            HStack {
                                Text("\(self.yLabels[index])")
                                    .foregroundColor(Color(UIColor.tertiaryLabel))
                                    .font(.caption)
                                Rectangle()
                                    .frame(width: self.gridSize.width / 2, height: 1, alignment: .leading)
                                    .foregroundColor(Color(UIColor.quaternaryLabel))
                            }
                            if index != self.yLabels.count - 1 {
                                Spacer()
                            }
                        }
                    }
                }.padding([.leading], gridSize.height / 2)
                ZStack {
                    MountainShape(values: values, scale: scale, isClosed: true)
                        .fill(fillStyle)
                        .onAppear { self.scale = MountainShape.AnimatableData(1.0, 1.0) }
                    //    .padding(.bottom, gridSize.height)
                    //    .padding(.leading, gridSize.width)
                    //GridShape(values: values, size: gridSize, position: [.leading, .bottom])
                    //    .stroke(Color.gray.opacity(0.3))
                }
            }
            HStack {
                ForEach(0..<xLabels.count, id: \.self) { index in
                    Group {
                        VStack {
                            Rectangle()
                                .frame(width: 1, height: self.gridSize.height / 2, alignment: .leading)
                                .foregroundColor(Color(UIColor.quaternaryLabel))
                            Text("\(self.xLabels[index])")
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                                .font(.caption)
                        }
                        if index != self.xLabels.count - 1 {
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}
