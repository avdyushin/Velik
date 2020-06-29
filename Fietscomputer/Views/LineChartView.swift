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

    let values: [Double]
    @State private var percentage: CGFloat = .zero
    @State private var scaleY: CGFloat = .zero

    private let lineGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(UIColor.fdAndroidGreen),
            Color.green
        ]),
        startPoint: UnitPoint(x: 0, y: 0),
        endPoint: UnitPoint(x: 0, y: 1)
    )

    private let fillGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color.white,
            Color.green
        ]),
        startPoint: UnitPoint(x: 0, y: 1),
        endPoint: UnitPoint(x: 0, y: 0)
    )

    var body: some View {
        HStack {
//            VStack {
//                Text("max \(self.maxY)")
//                Spacer()
//                Text("min \(self.midY)")
//                Spacer()
//                Text("min \(self.minY)")
//            }
//            ZStack {
            MountainShape(values: self.values, scaleY: self.scaleY, isClosed: true)
                    .fill(self.lineGradient)
//                MountainShape(values: self.values)
//                    .trim(from: .zero, to: self.percentage)
//                    .stroke(self.lineGradient, lineWidth: 1)
//                .animation(.default)
                    .animation(.easeInOut(duration: 3))
                    .onAppear(perform: {
                        //withAnimation { self.percentage = 1 }
                        withAnimation { self.scaleY = 1 }
                    })
//            }
        }
    }
}
