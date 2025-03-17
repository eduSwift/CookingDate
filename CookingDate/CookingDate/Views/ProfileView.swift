//
//  ProfileView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.


import SwiftUI
import MapKit
import FirebaseFirestore


struct ProfileView: View {
    @State private var userProfiles: [UserProfile] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            if isLoading && !isRefreshing {
                ProgressView("Loading Profiles...")
                    .scaleEffect(1.5)
                    .tint(.white)
            }
            
            if let errorMessage = errorMessage {
                VStack {
                    Text("⚠️ Error")
                        .font(.title)
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(15)
                .shadow(radius: 10)
                .transition(.scale)
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    if userProfiles.isEmpty && !isLoading {
                        EmptyStateView()
                    } else {
                        ForEach(userProfiles) { profile in
                            ProfileCardView(profile: profile)
                        }
                    }
                }
                .padding()
            }
            .opacity(isLoading ? 0.5 : 1)
            .refreshable {
                await refreshProfiles()
            }
        }
        .animation(.easeInOut, value: userProfiles)
        .onAppear {
            if userProfiles.isEmpty {
                fetchUserProfiles()
            }
        }
    }
    
    private func refreshProfiles() async {
        isRefreshing = true
        fetchUserProfiles()
        isRefreshing = false
    }
    
    func fetchUserProfiles() {
        isLoading = true
        errorMessage = nil
        
        let db = Firestore.firestore()
        db.collection("userProfiles").getDocuments { snapshot, error in
            isLoading = false
            
            if let error = error {
                errorMessage = "Failed to load profiles: \(error.localizedDescription)"
                return
            }
            
            guard let documents = snapshot?.documents else {
                errorMessage = "No profiles found"
                return
            }
            
            do {
                userProfiles = try documents.compactMap { document in
                    try document.data(as: UserProfile.self)
                }
            } catch {
                errorMessage = "Error decoding profiles: \(error.localizedDescription)"
            }
        }
    }
}

struct ProfileCardView: View {
    let profile: UserProfile
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: profile.profileImageURL)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else if phase.error != nil {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text("Age: \(profile.age)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            StatusIndicator(status: profile.status)
                            HostingIndicator(canHost: profile.canHost)
                        }
                    }
                    .padding(.leading, 8)
                }
                
                InfoSection(title: "About Me", content: profile.aboutMe)
                
                InfoSection(title: "Looking For", content: profile.lookingFor)
                

                HStack {
                    AttributeBadge(icon: "mappin.and.ellipse",
                                   text: profile.isMobile ? "Mobile" : "Stationary")
                    AttributeBadge(icon: "house.fill",
                                   text: profile.canHost ? "Can Host" : "Can't Host")
                }
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
}

// MARK: - Subviews

private struct InfoSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.accentColor)
            Text(content)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

private struct StatusIndicator: View {
    let status: String
    
    var color: Color {
        switch status.lowercased() {
        case "available": return .green
        case "busy": return .orange
        case "away": return .gray
        default: return .blue
        }
    }
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(color)
            Text(status.capitalized)
                .font(.caption.bold())
        }
        .padding(6)
        .background(color.opacity(0.2))
        .cornerRadius(5)
    }
}

private struct HostingIndicator: View {
    let canHost: Bool
    
    var body: some View {
        HStack {
            Image(systemName: canHost ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(canHost ? .green : .red)
            Text(canHost ? "Can Host" : "Can't Host")
                .font(.caption.bold())
        }
        .padding(6)
        .background(canHost ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
        .cornerRadius(5)
    }
}

private struct AttributeBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption)
        .padding(8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.4))
            
            Text("No Profiles Found")
                .font(.title2.bold())
                .foregroundColor(.gray)
            
            Text("It seems like there are no profiles to display right now. Check back later!")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .padding(.vertical, 40)
    }
}

#Preview {
    ProfileView()
      
}

