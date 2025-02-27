//
//  ChatView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import SwiftUI
import MapKit

struct ChatView: View {
    
    @Binding var selection: Int
    
    var body: some View {
        Map()
            .mapStyle(.standard)
            .mapControls {
                MapCompass()
                MapUserLocationButton()
                MapPitchToggle()
                MapScaleView()
            }
        
    }
}

#Preview {
    ChatView(selection: .constant(2))
}
