//
//  GradientPathDrawer.swift
//  Velik
//
//  Created by Grigory Avdyushin on 10/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit

struct GradientPathDrawer {
    func draw(context: CGContext, size: CGSize, path: CGPath, colors: [UIColor]) {
        // Path stroke with gradient
        context.draw { context in
            context.addPath(path)
            context.replacePathWithStrokedPath()
            context.clip()

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [colors.first!.cgColor, colors.last!.cgColor] as CFArray
            var gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)

            context.drawLinearGradient(
                gradient!,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            gradient = nil
        }
    }
}
