//
//  SettingsView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 11.03.25.
//

import SwiftUI

// SettingsView.swift
struct SettingsView: View {
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            List {
                Section("Preferences") {
                    Toggle("Notifications", isOn: .constant(true))
                    Toggle("Dark Mode", isOn: .constant(false))
                }
                
                Section("Account") {
                    Button("Change Password") { /* Implement password change */ }
                    Button("Delete Account") { /* Implement account deletion */ }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
