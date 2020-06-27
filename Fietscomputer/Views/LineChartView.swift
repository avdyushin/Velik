//
//  LineChartView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LineChartView: View {

    struct Scale {
        let x: Double
        let y: Double
    }

    private let height = 100.0
    private let width = 200.0

    private let values: [Double]

    private let minY: CGFloat
    private let maxY: CGFloat
    private let midY: CGFloat

    init(values: [Double]) {
        self.values = values
        minY = CGFloat(values.min() ?? .zero)
        maxY = CGFloat(values.max() ?? .zero)
        midY = CGFloat((maxY - minY) / 2)
    }

    private func scale(geometry: GeometryProxy) -> CGPoint {
        CGPoint(
            x: geometry.size.width / max(1, CGFloat(values.count)),
            y: geometry.size.height / max(1, maxY - minY)
        )
    }

    private func points(geometry: GeometryProxy) -> [CGPoint] {
        let scale = self.scale(geometry: geometry)
        return values.enumerated().map { index, value in
            CGPoint(x: CGFloat(index) * scale.x, y: (CGFloat(value) - minY) * scale.y)
        }
    }

    private func drawGraph(path: inout Path, geometry: GeometryProxy) {
        path.addLines(points(geometry: geometry))
    }

    private func drawGrid(path: inout Path, geometry: GeometryProxy) {
        let scale = self.scale(geometry: geometry)
        path.move(to: CGPoint(x: 0, y: midY * scale.y))
        path.addLine(to: CGPoint(x: geometry.size.width, y: midY * scale.y))
    }

    @State private var percentage: CGFloat = .zero

    var body: some View {
        HStack {
//            VStack {
//                Text("max \(self.maxY)")
//                Spacer()
//                Text("min \(self.midY)")
//                Spacer()
//                Text("min \(self.minY)")
//            }
            GeometryReader { geometry in
                ZStack {
                    Path { path in
                        self.drawGrid(path: &path, geometry: geometry)
                    }
                    .stroke(Color.gray)
                    Path { path in
                        self.drawGraph(path: &path, geometry: geometry)
                    }
                    .trim(from: .zero, to: self.percentage)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(UIColor.fdAndroidGreen),
                                Color.green
                            ]),
                            startPoint: UnitPoint(x: 0, y: 0),
                            endPoint: UnitPoint(x: 0, y: 1)
                        )
                    )
                    .animation(.easeOut(duration: 5))
                    .onAppear(perform: { self.percentage = 1 })
                }
            }
        }
    }
}
