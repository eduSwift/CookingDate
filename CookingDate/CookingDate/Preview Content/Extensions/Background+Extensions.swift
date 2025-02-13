//
//  Background+Extensions.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 13.02.25.
//

import Foundation
import SwiftUI

extension LinearGradient {
    static let appBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "#0097b2"),
            Color(hex: "#7ed957")
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

