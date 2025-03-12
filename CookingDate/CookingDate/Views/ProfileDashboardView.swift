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
    @Environment(SessionManager.self) var sessionManager
    @State private var userProfile: UserProfile?
    @State private var showingEditProfile = false
    @State private var showingSettings = false
    @Binding var selection: Int
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            ScrollView {
                if let profile = userProfile {
                    // Profile Header Section
                    Section {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(profile.username) // Replace with username if available
                                    .font(.title2.bold())
                                Text(profile.onlineStatus ? "Online" : "Offline")
                                    .font(.subheadline)
                                    .foregroundColor(profile.onlineStatus ? .green : .red)
                            }
                            Spacer()
                            if let url = URL(string: profile.profileImageURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.gray)
                            }

                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Profile Details Section
                    Section(header: Text("My Profile")) {
                        DetailRow(title: "My location", value: profile.locationString)
                        DetailRow(title: "Status", value: profile.status)
                        DetailRow(title: "Age", value: "\(profile.age) years old")
                        DetailRow(title: "About me", value: profile.aboutMe)
                        DetailRow(title: "Looking for", value: profile.lookingFor)
                        DetailRow(title: "Can Host", value: profile.canHost ? "Yes" : "No")
                        DetailRow(title: "Is Mobile", value: profile.isMobile ? "Yes" : "No")
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
                        Button("Sign Out", role: .destructive) {
                            sessionManager.sessionState = .loggedOut
                        }
                    }
                } else {
                    ProgressView("Loading Profile...")
                        .onAppear(perform: loadProfile)
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
                if let profile = userProfile {
                    EditProfileView(profile: profile)
                }
            }
        }
    }
    
    private func loadProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("userProfiles").document(userId).getDocument { snapshot, error in
            if let error = error {
                print("Error loading profile: \(error.localizedDescription)")
                return
            }
            
            if let data = snapshot?.data() {
                do {
                    let profile = try Firestore.Decoder().decode(UserProfile.self, from: data)
                    DispatchQueue.main.async {
                        self.userProfile = profile
                    }
                } catch {
                    print("Error decoding profile: \(error.localizedDescription)")
                }
            }
        }
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
            Text(value.isEmpty ? "Not set" : value)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    ProfileDashboardView(selection: .constant(4))
        .environment(SessionManager())
}

