//
//  ChatView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 26.02.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatView: View {
    @State private var chats: [Chat] = []
    @Environment(SessionManager.self) var sessionManager

    var body: some View {
        NavigationStack {
            VStack {
                if chats.isEmpty {
                    Text("No active chats")
                        .foregroundStyle(.gray)
                        .padding()
                } else {
                    List(chats) { chat in
                        NavigationLink(destination: ChatDetailView(chat: chat)) {
                            VStack(alignment: .leading) {
                                Text(chat.lastMessage)
                                    .font(.headline)
                                Text(chat.timestamp, style: .time)
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .background(LinearGradient.appBackground.ignoresSafeArea())
            .onAppear(perform: fetchChats)
        }
    }

    private func fetchChats() {
        guard let userId = sessionManager.currentUser else { return }
        
        let db = Firestore.firestore()
        db.collection("chats")
            .whereField("userIds", arrayContains: userId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let snapshot = snapshot {
                    chats = snapshot.documents.compactMap { try? $0.data(as: Chat.self) }
                }
            }
    }
}

#Preview {
    ChatView()
}
