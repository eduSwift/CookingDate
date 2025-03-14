//
//  CreateProfileView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 12.03.25.
//

import SwiftUI
import PhotosUI
import MapKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


struct CreateProfileView: View {
    @Environment(SessionManager.self) var sessionManager
    @Binding var selection: Int
    @State private var username: String = ""
    @State private var age: String = ""
    @State private var aboutMe: String = ""
    @State private var lookingFor: String = ""
    @State private var onlineStatus: Bool = false
    @State private var status: String = ""
    @State private var canHost: Bool = false
    @State private var isMobile: Bool = false
    @State private var location: CLLocationCoordinate2D?
    
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var profileImageURL: String?
    
    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            
            
            ScrollView {
                VStack(spacing: 20) {
                    Section {
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
                        
                        Button("Select Profile Image") {
                            isImagePickerPresented = true
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                    }
                    .padding(.top, 20)
                    
                    Section {
                        
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        
                        TextField("Age", text: $age)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        
                        TextField("About Me", text: $aboutMe)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .frame(height: 150)
                            .background(Color.white.opacity(0.8))
                            .scrollContentBackground(.hidden)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        TextField("Looking For", text: $lookingFor)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                    
                    Section {
                        Button(action: {
                            self.location = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
                        }) {
                            HStack {
                                Text("Set Location")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                    }
                    
                    Section {
                        Toggle("Online Status", isOn: $onlineStatus)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        
                        TextField("Status", text: $status)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        
                        Toggle("Can Host", isOn: $canHost)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                        
                        Toggle("Is Mobile", isOn: $isMobile)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }
                    
                    Button(action: saveProfile) {
                        
                        Text("Save Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Create Profile")
    }
    
    func saveProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No user ID found")
            return
        }
        
        guard let ageInt = Int(age) else {
            print("Error: Invalid age")
            return
        }
        
        
        let geoPoint: GeoPoint?
        if let location = location {
            geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        } else {
            geoPoint = nil
        }
        
        if let selectedImage = selectedImage {
            uploadImage(image: selectedImage) { url in
                if let url = url {
                    self.profileImageURL = url.absoluteString
                    saveUserProfile(userId: userId, ageInt: ageInt, geoPoint: geoPoint)
                } else {
                    print("Error: Failed to upload image")
                }
            }
        } else {
            saveUserProfile(userId: userId, ageInt: ageInt, geoPoint: geoPoint)
        }
    }
    
    func saveUserProfile(userId: String, ageInt: Int, geoPoint: GeoPoint?) {
        let locationString: String
        if let geoPoint = geoPoint {
            locationString = String(format: "%.4f, %.4f", geoPoint.latitude, geoPoint.longitude)
        } else {
            locationString = "Not set"
        }
        
        let userProfile = UserProfile(
            id: userId,
            profileImageURL: profileImageURL ?? "",
            username: username,
            age: ageInt,
            aboutMe: aboutMe,
            lookingFor: lookingFor,
            onlineStatus: onlineStatus,
            status: status,
            canHost: canHost,
            isMobile: isMobile,
            locationString: locationString
        )
        
        let db = Firestore.firestore()
        do {
            try db.collection("userProfiles").document(userId).setData(from: userProfile)
            print("Profile saved successfully")
            
            DispatchQueue.main.async {
                sessionManager.hasProfile = true
                selection = 3
            }
        } catch {
            print("Error saving profile: \(error.localizedDescription)")
        }
    }
    
    
    func uploadImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(nil)
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("profileImages/\(UUID().uuidString).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(url)
                }
            }
        }
    }
    
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var selectedImage: UIImage?
        
        func makeUIViewController(context: Context) -> PHPickerViewController {
            var config = PHPickerConfiguration()
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
        
        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, PHPickerViewControllerDelegate {
            let parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                picker.dismiss(animated: true)
                
                guard let provider = results.first?.itemProvider else { return }
                
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, _ in
                        DispatchQueue.main.async {
                            self.parent.selectedImage = image as? UIImage
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CreateProfileView(selection: .constant(3))
        .environment(SessionManager())
}
