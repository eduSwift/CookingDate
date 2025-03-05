//
//  ChatView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import SwiftUI

struct ChatView: View {
    
    @Binding var selection: Int
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            VStack {
                Text("Under Construction")
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}

#Preview {
    ChatView(selection: .constant(2))
}
