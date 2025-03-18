//
//  LaunchAnimationView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 17.03.25.
//


import SwiftUI

struct LaunchAnimationView: View {
    @State private var currentImageIndex = 0
    @State private var fadeInText = false
    @State private var navigateToLogin = false

  
    let images = ["GY", "HT", "CookingDateLogo"]

    var body: some View {
        ZStack {
            LinearGradient.appBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                Image(images[currentImageIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .transition(.opacity)
                    .id(currentImageIndex)

                if fadeInText {
                    Text("It's never too late, to have a Cooking Date")
                        .font(.system(.title3, design: .serif).bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .padding()
                        .transition(.opacity)
                }
            }
        }
        .onAppear(perform: animateSequence)
        .fullScreenCover(isPresented: $navigateToLogin) {
            LoginView()
        }
    }

    func animateSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            switchToNextImage()
        }
    }

    func switchToNextImage() {
        withAnimation(.easeInOut(duration: 1.0)) {
            if currentImageIndex < images.count - 1 {
                currentImageIndex += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                    switchToNextImage()
                }
            } else {
                fadeInText = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    navigateToLogin = true
                }
            }
        }
    }
}

#Preview {
    LaunchAnimationView()
}
