//
//  LaunchAnimationView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 17.03.25.
//

import SwiftUI

struct LaunchAnimationView: View {
    @State private var animate = false
    @State private var navigateToLogin = false

    var body: some View {
        ZStack {
            LinearGradient.appBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                Image("CookingDateLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(animate ? 1.1 : 0.9)
                    .shadow(color: .white.opacity(animate ? 0.6 : 0.2), radius: 20, x: 0, y: 0)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)

                Text("It’s never too late to have a Cooking Date")
                    .font(.system(.title3, design: .serif))
                    .bold()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.black)
                    .opacity(animate ? 1 : 0)
                    .offset(y: animate ? 0 : 10)
                    .animation(.easeOut(duration: 1.5).delay(0.5), value: animate)
            }
        }
        .onAppear {
            animate = true

         
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                navigateToLogin = true
            }
        }
        .fullScreenCover(isPresented: $navigateToLogin) {
            LoginView()
        }
    }
}

#Preview {
    LaunchAnimationView()
}
