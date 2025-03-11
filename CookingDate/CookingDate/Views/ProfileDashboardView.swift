//
//  ProfileDashboardView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 11.03.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ProfileDashboardView: View {
    @EnvironmentObject var sessionManager: SessionManager
    @State private var userProfile: UserProfile?
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Header Section
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("DannyBl")
                                .font(.title2.bold())
                            Text("online")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        Spacer()
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
                
                // Profile Details Section
                Section(header: Text("My Profile")) {
                    DetailRow(title: "My location", value: "Berlin")
                    DetailRow(title: "Status", value: "Single")
                    DetailRow(title: "Age", value: "27 years old")
                    DetailRow(title: "About me",
                            value: "Another Italian woman lost in Berlin, who loves cooking and meeting new people.")
                }
                
                // Settings Section
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    Button {
                        // Handle support
                    } label: {
                        Label("Support", systemImage: "questionmark.circle")
                    }
                }
                
                // Legal Section
                Section {
                    Button("Privacy Statement") { /* Open privacy */ }
                    Button("Terms of use") { /* Open terms */ }
                }
                
                // Logout Section
                Section {
                    Button(role: .destructive) {
                        logout()
                    } label: {
                        Label("Log out", systemImage: "arrow.left.square.fill")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditProfile.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(profile: userProfile ??, profile: UserProfile)
            }
            .onAppear(perform: loadProfile)
        }
    }
    
    private func loadProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("userProfiles").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Error loading profile: \(error.localizedDescription)")
                return
            }
            
            userProfile = try? snapshot?.data(as: UserProfile.self)
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            sessionManager.signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}


// SettingsView.swift
struct SettingsView: View {
    var body: some View {
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

// Supporting Components
struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .multilineTextAlignment(.trailing)
        }
    }
}


#Preview {
    ProfileDashboardView()
}
