import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct EditProfileView: View {
    @Environment(SessionManager.self) var sessionManager
    @Environment(\.dismiss) var dismiss

    @State private var username = ""
    @State private var age = ""
    @State private var gender = ""
    @State private var orientation = ""
    @State private var aboutMe = ""
    @State private var lookingFor = ""
    @State private var status = ""
    @State private var onlineStatus = false
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
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else if let url = URL(string: profileImageURL ?? "") {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image.resizable()
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                        }
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    }

                    Button("Change Profile Image") {
                        isImagePickerPresented = true
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $selectedImage)
                    }

                    Group {
                        TextField("Username", text: $username)
                        TextField("Age", text: $age)
                            .keyboardType(.numberPad)
                        TextField("Gender", text: $gender)
                        TextField("Orientation", text: $orientation)
                        TextField("About Me", text: $aboutMe)
                        TextField("Looking For", text: $lookingFor)
                        TextField("Status", text: $status)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)

                    Group {
                        Toggle("Online Status", isOn: $onlineStatus)
                        Toggle("Can Host", isOn: $canHost)
                        Toggle("Is Mobile", isOn: $isMobile)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)

                    Button("Save Changes") {
                        saveProfile()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
                }
                .padding()
                .onAppear(perform: loadUserData)
            }
        }
        .navigationTitle("Edit Profile")
    }

    func loadUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("userProfiles").document(userId).getDocument { snapshot, error in
            if let data = try? snapshot?.data(as: UserProfile.self) {
                username = data.username
                age = String(data.age)
                aboutMe = data.aboutMe
                lookingFor = data.lookingFor
                status = data.status
                onlineStatus = data.onlineStatus
                canHost = data.canHost
                isMobile = data.isMobile
                profileImageURL = data.profileImageURL
            }
        }
    }

    func saveProfile() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let ageInt = Int(age) else { return }

        let saveData = {
            let updatedProfile = UserProfile(
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

            do {
                try Firestore.firestore().collection("userProfiles").document(userId).setData(from: updatedProfile)
                dismiss()
            } catch {
                print("Error saving: \(error.localizedDescription)")
            }
        }

        if let selectedImage = selectedImage {
            uploadImage(image: selectedImage) { url, error in
                if let url = url {
                    profileImageURL = url.absoluteString
                }
                saveData()
            }
        } else {
            saveData()
        }
    }

    func uploadImage(image: UIImage, completion: @escaping (URL?, Error?) -> Void) {
        guard let data = image.jpegData(compressionQuality: 0.75) else {
            completion(nil, nil)
            return
        }

        let ref = Storage.storage().reference().child("profileImages/\(UUID().uuidString).jpg")
        ref.putData(data, metadata: nil) { _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            ref.downloadURL(completion: completion)
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

#Preview {
    EditProfileView()
        .environment(SessionManager())
}

