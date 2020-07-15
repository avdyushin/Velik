//
//  GaugeViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Injected

class GaugeViewModel: ViewModel, ObservableObject {

    @Published var value = ""
    @Published var units = ""
    @Published var title = ""
    @Published var fontName = "DIN Alternate"
    @Published var fontSize = 28
}
