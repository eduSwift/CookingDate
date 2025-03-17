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

    // Make sure these names match your asset catalog exactly (no file extensions)
    let images = ["HT", "GY", "LB"]

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
                    Text("It's never too latte, to have a Cooking Date")
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
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
