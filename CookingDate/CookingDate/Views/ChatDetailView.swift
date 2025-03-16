//
//  ChatDetailView.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 15.03.25.
//

import SwiftUI
import FirebaseAuth

struct ChatDetailView: View {
    let chat: Chat
    @State private var text = ""
    @Bindable var viewModel: ChatViewModel

    init(chat: Chat) {
        assert(chat.id != nil, "ChatDetailView was initialized with a chat that has no id!")
        self.chat = chat
        self.viewModel = ChatViewModel(chatId: chat.id!)
    }


    var body: some View {
        ZStack {
            LinearGradient.appBackground
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.senderId == Auth.auth().currentUser?.uid {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                HStack {
                    TextField("Type a message...", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button {
                        viewModel.sendMessage(text: text)
                        text = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }
                }
                .padding()
            }
            .navigationTitle("Chat")
        }
    }
}


#Preview {
    ChatDetailView(chat: Chat(id: "123", userIds: ["user1", "user2"], lastMessage: "", timestamp: Date()))
}
