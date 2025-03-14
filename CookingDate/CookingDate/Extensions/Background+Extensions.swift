//
//  Background+Extensions.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 13.02.25.
//

import Foundation
import SwiftUI

extension Color {
    static let primaryText = Color("PrimaryText")
    static let secondaryText = Color("SecondaryText")
    static let cardBackground = Color("CardBackground")
}

extension LinearGradient {
    static let appBackground = LinearGradient(
        gradient: Gradient(colors: [
            Color("BlueBack"),
            Color("GreenBack")  
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
}
