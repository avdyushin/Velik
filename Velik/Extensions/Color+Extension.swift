//
//  Color+Extension.swift
//  Woord
//
//  Created by Grigory Avdyushin on 15/03/2018.
//  Copyright © 2018 Grigory Avdyushin. All rights reserved.
//

import UIKit

extension UIColor {

    /// Color formats
    enum ColorFormat: Int {

        case RGB = 12
        case RGBA = 16
        case RRGGBB = 24

        init?(bitsCount: Int) {
            self.init(rawValue: bitsCount)
        }
    }

    /// Returns color with given hex string
    convenience init?(string: String) {
        let string = string.replacingOccurrences(of: "#", with: "")

        guard
            let hex = Int(string, radix: 16),
            let format = ColorFormat(bitsCount: string.count * 4) else {
                return nil
        }

        self.init(hex: hex, format: format)
    }

    /// Returns color with given hex integer value and color format
    convenience init(hex: Int, format: ColorFormat = .RRGGBB) {

        let red: Int, green: Int, blue: Int, alpha: Int

        switch format {
        case .RGB:
            red   = ((hex & 0xf00) >> 8) << 4 + ((hex & 0xf00) >> 8)
            green = ((hex & 0x0f0) >> 4) << 4 + ((hex & 0x0f0) >> 4)
            blue  = ((hex & 0x00f) >> 0) << 4 + ((hex & 0x00f) >> 0)
            alpha = 255
        case .RGBA:
            red   = ((hex & 0xf000) >> 12) << 4 + ((hex & 0xf000) >> 12)
            green = ((hex & 0x0f00) >>  8) << 4 + ((hex & 0x0f00) >>  8)
            blue  = ((hex & 0x00f0) >>  4) << 4 + ((hex & 0x00f0) >>  4)
            alpha = ((hex & 0x000f) >>  0) << 4 + ((hex & 0x000f) >>  4)
        case .RRGGBB:
            red   = ((hex & 0xff0000) >> 16)
            green = ((hex & 0x00ff00) >>  8)
            blue  = ((hex & 0x0000ff) >>  0)
            alpha = 255
        }

        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }

    /// Returns integer color representation
    var asInt: Int {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (Int)(red * 255) << 16 | (Int)(green * 255) << 8  | (Int)(blue * 255)  << 0
    }

    /// Returns hex string color representation
    var asHexString: String {
        return String(format: "#%06x", asInt)
    }
}

extension UIColor {
    // green sea
    static let flatTurquoiseColor = UIColor(hex: 0x1abc9c)
    static let flatGreenSeaColor = UIColor(hex: 0x16a085)
    // green
    static let flatEmeraldColor = UIColor(hex: 0x2ecc71)
    static let flatNephritisColor = UIColor(hex: 0x27ae60)
    // blue
    static let flatPeterRiverColor = UIColor(hex: 0x3498db)
    static let flatBelizeHoleColor = UIColor(hex: 0x2980b9)
    // purple
    static let flatAmethystColor = UIColor(hex: 0x9b59b6)
    static let flatWisteriaColor = UIColor(hex: 0x8e44ad)
    // dark blue
    static let flatWetAsphaltColor = UIColor(hex: 0x34495e)
    static let flatMidnightBlueColor = UIColor(hex: 0x2c3e50)
    // yellow
    static let flatSunFlowerColor = UIColor(hex: 0xf1c40f)
    static let flatOrangeColor = UIColor(hex: 0xf39c12)
    // orange
    static let flatCarrotColor = UIColor(hex: 0xe67e22)
    static let flatPumkinColor = UIColor(hex: 0xd35400)
    // red
    static let flatAlizarinColor = UIColor(hex: 0xe74c3c)
    static let flatPomegranateColor = UIColor(hex: 0xc0392b)
    // white
    static let flatCloudsColor = UIColor(hex: 0xecf0f1)
    static let flatSilverColor = UIColor(hex: 0xbdc3c7)
    // gray
    static let flatAsbestosColor = UIColor(hex: 0x7f8c8d)
    static let flatConcerteColor = UIColor(hex: 0x95a5a6)
}

// Dutch Palette
extension UIColor {
    // Yellow / Rd
    static let fdSunflower = UIColor(hex: 0xFFC312)
    static let fdRadianYellow = UIColor(hex: 0xF79F1F)
    static let fdPuffinsBull = UIColor(hex: 0xEE5A24)
    static let fdRedPigment = UIColor(hex: 0xEA2027)

    // Green
    static let fdEnergos = UIColor(hex: 0xC4E538)
    static let fdAndroidGreen = UIColor(hex: 0xA3CB38)
    static let fdPixelatedGrass = UIColor(hex: 0x009432)
    static let fdTurkishAqua = UIColor(hex: 0x006266)

    // Blue
    static let fdBlueMartina = UIColor(hex: 0x12CBC4)
    static let fdMediterraneanSea = UIColor(hex: 0x1289A7)
    static let fdMerchantMarineBlue = UIColor(hex: 0x0652DD)
    static let fd20000LeaguasUnderTheSea = UIColor(hex: 0x1B1464)

    // Rose / Purpule
    static let fdLavenderRose = UIColor(hex: 0xFDA7DF)
    static let fdLavenderTea = UIColor(hex: 0xD980FA)
    static let fdForgottenPurple = UIColor(hex: 0x9980FA)
    static let fdCircumorbitalRing = UIColor(hex: 0x5758BB)

    // Rose / Red
    static let fdBaraRed = UIColor(hex: 0xED4C67)
    static let fdVeryBerry = UIColor(hex: 0xB53471)
    static let fdHollyhock = UIColor(hex: 0x833471)
    static let fdMargentaPurple = UIColor(hex: 0x6F1E51)
}

extension UIColor {
    static let tnDarkPurple = UIColor(hex: 0x372F57)
    static let tnYellow = UIColor(hex: 0xF5C86A)
    static let tnGray = UIColor(hex: 0x6B7778)
}
