//
//  CreateProfileView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 12.03.25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct CreateProfileView: View {
    @Environment(SessionManager.self) var sessionManager
    @Binding var selection: Int

    @State private var username = ""
    @State private var age = ""
    @State private var gender = ""
    @State private var orientation = ""
    @State private var aboutMe = ""
    @State private var lookingFor = ""
    @State private var onlineStatus = false
    @State private var status = ""
    @State private var canHost = false
    @State private var isMobile = false

    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var profileImageURL: String?

    var body: some View {
        ZStack {
            LinearGradient.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Group {
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

                    Group {
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)

                        TextField("Age", text: $age)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)

                        TextField("Gender", text: $gender)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)

                        TextField("Orientation", text: $orientation)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)

                        TextField("About Me", text: $aboutMe)
                            .font(.system(size: 15, weight: .semibold))
                            .padding()
                            .frame(height: 150)
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        TextField("Looking For", text: $lookingFor)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                    }

                    Group {
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

        if let selectedImage = selectedImage {
            uploadImage(image: selectedImage) { url in
                if let url = url {
                    self.profileImageURL = url.absoluteString
                    saveUserProfile(userId: userId, ageInt: ageInt)
                } else {
                    print("Error: Failed to upload image")
                }
            }
        } else {
            saveUserProfile(userId: userId, ageInt: ageInt)
        }
    }

    func saveUserProfile(userId: String, ageInt: Int) {
        let userProfile = UserProfile(
            id: userId,
            profileImageURL: profileImageURL ?? "",
            username: username,
            age: ageInt,
            gender: gender,
            orientation: orientation,
            aboutMe: aboutMe,
            lookingFor: lookingFor,
            onlineStatus: onlineStatus,
            status: status,
            canHost: canHost,
            isMobile: isMobile,
            locationString: "Not set"
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
