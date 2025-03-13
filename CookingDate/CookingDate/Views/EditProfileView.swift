//
//  EditProfileView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 11.03.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// EditProfileView.swift
struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var profile: UserProfile
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            NavigationStack {
                Form {
                    Section("Basic Information") {
                        TextField("Age", value: $profile.age, formatter: NumberFormatter())
                        Picker("Status", selection: $profile.status) {
                            Text("Single").tag("Single")
                            Text("In a Relationship").tag("In a Relationship")
                            Text("Married").tag("Married")
                        }
                    }
                    
                    Section("About Me") {
                        TextEditor(text: $profile.aboutMe)
                            .frame(minHeight: 100)
                    }
                    
                    Section("Location") {
                        Toggle("Show Location", isOn: $profile.isMobile)
                        TextField("Location", text: $profile.locationString)
                        
                        // Optional: Add map integration for coordinates
                        if let coordinates = profile.geoPoint {
                            Text("Lat: \(coordinates.latitude), Lon: \(coordinates.longitude)")
                                .font(.caption)
                        }
                    }
                }
                .navigationTitle("Edit Profile")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            saveProfile()
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func saveProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try Firestore.firestore().collection("userProfiles")
                .document(userId)
                .setData(from: profile)
        } catch {
            print("Error saving profile: \(error.localizedDescription)")
        }
    }
}

#Preview {
    // Provide a sample profile for previews
    EditProfileView(profile: UserProfile(
        id: "",
        profileImageURL: "",
        username: "",
        age: 20,
        aboutMe: "",
        lookingFor: "",
        onlineStatus: true,
        status: "",
        canHost: false,
        isMobile: false,
        locationString: ""
    ))
}


