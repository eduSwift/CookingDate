//
//  ProgressComponentView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 12.03.25.
//

import SwiftUI

struct ProgressComponentView: View {
    
    @Binding var value: Float
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            ProgressView("Uploading..", value: 0.5, total: 1)
                .padding(.horizontal)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ProgressComponentView(value: .constant(0.5))
}
