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
    @State private var navigateToEditProfile = false
    @Binding var selection: Int

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appBackground
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        if let profile = userProfile {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(profile.username)
                                        .font(.title.bold())

                                    ProfileImage(url: profile.profileImageURL)
                                        .padding(.top)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)

                            VStack(spacing: 16) {
                                HStack(spacing: 12) {
                                    Text("Age: \(profile.age)")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(.secondary)

                                    StatusBadge(
                                        icon: "circle.fill",
                                        text: profile.onlineStatus ? "Online" : "Offline",
                                        color: profile.onlineStatus ? .green : .red
                                    )
                                }

                                InfoRow(icon: "mappin.and.ellipse", title: "My Location", value: profile.locationString)
                                InfoRow(icon: "person.fill", title: "Status", value: profile.status)
                                InfoRow(icon: "person", title: "Gender", value: profile.gender)
                                InfoRow(icon: "figure.2.arms.open", title: "Orientation", value: profile.orientation)
                                InfoRow(icon: "info.circle", title: "About Me", value: profile.aboutMe)
                                InfoRow(icon: "magnifyingglass", title: "Looking For", value: profile.lookingFor)

                                HStack(spacing: 20) {
                                    StatusBadge(
                                        icon: "house.fill",
                                        text: profile.canHost ? "Can Host" : "Can't Host",
                                        color: profile.canHost ? .green : .red
                                    )

                                    StatusBadge(
                                        icon: "car.fill",
                                        text: profile.isMobile ? "Mobile" : "Stationary",
                                        color: .blue
                                    )
                                }
                            }
                            .cardStyle()

                            VStack(spacing: 12) {
                                // ✅ NavigationLink to SettingsView
                                NavigationLink(destination: SettingsView()) {
                                    ActionButton(label: "Settings", icon: "gear")
                                }

                                ActionButton(label: "Support", icon: "questionmark.circle")
                                ActionButton(label: "Privacy Statement", icon: "lock.shield")
                                ActionButton(label: "Terms of Use", icon: "doc.text")

                                Button(action: {
                                    sessionManager.sessionState = .loggedOut
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.right.square")
                                        Text("Sign Out")
                                    }
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(10)
                                }
                            }
                            .cardStyle()
                        } else {
                            ProgressView("Loading Profile...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .padding(.bottom)
                }
                .navigationTitle("My Profile")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: EditProfileView()) {
                            Text("Edit")
                        }
                    }
                }
                .onAppear {
                    if sessionManager.hasProfile {
                        loadProfile()
                    }
                }
            }
        }
    }

    private func loadProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user found.")
            return
        }

        let docRef = Firestore.firestore().collection("userProfiles").document(userId)

        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error loading profile: \(error.localizedDescription)")
                return
            }

            guard let snapshot = snapshot, snapshot.exists else {
                print("No profile found for user: \(userId)")
                return
            }

            do {
                let profile = try snapshot.data(as: UserProfile.self)
                DispatchQueue.main.async {
                    self.userProfile = profile
                }
            } catch {
                print("Error decoding profile: \(error.localizedDescription)")
            }
        }
    }
}


struct ProfileImage: View {
    let url: String

    var body: some View {
        Group {
            if let imageUrl = URL(string: url) {
                AsyncImage(url: imageUrl) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                    }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
            }
        }
        .scaledToFill()
        .frame(width: 80, height: 80)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 2))
        .shadow(radius: 5)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(value.isEmpty ? "Not set" : value)
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
    }
}

struct StatusBadge: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption.bold())
        .foregroundColor(color)
        .padding(8)
        .background(color.opacity(0.2))
        .cornerRadius(8)
    }
}

struct ActionButton: View {
    let label: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(label)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .foregroundColor(.primary)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
}



#Preview {
    ProfileDashboardView(selection: .constant(4))
        .environment(SessionManager())
}

