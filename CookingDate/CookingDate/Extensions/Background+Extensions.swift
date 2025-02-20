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
            Color.blueBack,
            Color.greenBack
            
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )
}

