//
//  ChatDetailView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 15.03.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MessageBubble: View {
    let message: Message
    @Environment(SessionManager.self) var sessionManager

    var isCurrentUser: Bool {
        message.senderId == Auth.auth().currentUser?.uid
    }

    var body: some View {
        HStack {
            if isCurrentUser { Spacer() }
            Text(message.text)
                .padding()
                .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isCurrentUser ? .white : .black)
                .cornerRadius(12)
            if !isCurrentUser { Spacer() }
        }
        .padding(.horizontal)
    }
}


struct ChatDetailView: View {
    let chat: Chat
    @State private var newMessageText = ""
    @Environment(SessionManager.self) var sessionManager
    @Bindable var viewModel: ChatViewModel
    
    init(chat: Chat) {
        self.chat = chat
        self.viewModel = ChatViewModel(conversationId: chat.id ?? "")
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.messages) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .padding(.leading, 5)
            }
            .padding()
        }
        .background(LinearGradient.appBackground.ignoresSafeArea())
    }


    private func sendMessage() {
        guard !newMessageText.isEmpty else { return }
        viewModel.sendMessage(text: newMessageText)
        newMessageText = ""
    }

    }



#Preview {
    ChatDetailView(chat: Chat(id: "123", userIds: ["user1", "user2"], sortedUserIds: ["user1", "user2"], lastMessage: "", timestamp: Date()))
}
