//
//  GradientPolylineRenderer.swift
//  Velik
//
//  Created by Grigory Avdyushin on 10/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

class GradientPolylineRenderer: MKPolylineRenderer {

    var colors: [UIColor] = []
    let pathDrawer = GradientPathDrawer()

    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        super.draw(mapRect, zoomScale: zoomScale, in: context)
        pathDrawer.draw(context: context, size: path.boundingBoxOfPath.size, path: path, colors: colors)
    }
}
