//
//  ChatView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import SwiftUI
import FirebaseFirestore

struct ChatView: View {
    @State private var chats: [Chat] = []
    @Environment(SessionManager.self) var sessionManager
    @AppStorage("lastChatCheck") var lastChatCheck: Double = 0
    @State private var userProfiles: [String: UserProfile] = [:]
    @State private var unreadCount = 0

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient.appBackground
                    .ignoresSafeArea()

                if chats.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "message")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.4))
                        Text("No conversations yet")
                            .font(.title3)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(chats) { chat in
                        NavigationLink {
                            ChatDetailView(chat: chat)
                        } label: {
                            HStack(spacing: 12) {
                                if let profile = otherUserProfile(for: chat),
                                   let url = URL(string: profile.profileImageURL) {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    } placeholder: {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .overlay(Image(systemName: "person.fill").foregroundColor(.white))
                                    }
                                    .frame(width: 44, height: 44)
                                    .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(width: 44, height: 44)
                                        .overlay(ProgressView())
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(otherUserProfile(for: chat)?.username ?? "Chat")
                                        .font(.headline)

                                    Text(chat.lastMessage)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }

                                Spacer()

                                Text(chat.timestamp, style: .time)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 8)
                        }
                        .listRowBackground(Color.clear)
                        .onAppear {
                            loadOtherUserProfile(for: chat)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Messages")
        }
        .onAppear {
            listenForChats()
        }
    }


    func listenForChats() {
        guard let userId = sessionManager.currentUser?.id else { return }

        Firestore.firestore().collection("chats")
            .whereField("userIds", arrayContains: userId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let docs = snapshot?.documents else { return }

                let chats = docs.compactMap { try? $0.data(as: Chat.self) }
                self.chats = chats

                let lastCheckDate = Date(timeIntervalSince1970: lastChatCheck)
                let newUnread = chats.filter { $0.timestamp > lastCheckDate }
                self.unreadCount = newUnread.count


                chats.forEach { loadOtherUserProfile(for: $0) }
            }
    }

    func loadOtherUserProfile(for chat: Chat) {
        guard let currentUserId = sessionManager.currentUser?.id else { return }

        let otherUserId = chat.userIds.first { $0 != currentUserId } ?? ""

        if userProfiles[otherUserId] != nil { return }

        Firestore.firestore().collection("userProfiles")
            .document(otherUserId)
            .getDocument { snapshot, error in
                guard let doc = snapshot else { return }
                if let profile = try? doc.data(as: UserProfile.self) {
                    DispatchQueue.main.async {
                        userProfiles[otherUserId] = profile
                    }
                }
            }
    }


    func otherUserProfile(for chat: Chat) -> UserProfile? {
        guard let currentUserId = sessionManager.currentUser?.id else { return nil }
        let otherUserId = chat.userIds.first { $0 != currentUserId } ?? ""
        return userProfiles[otherUserId]
    }
}

#Preview {
    ChatView()
}
