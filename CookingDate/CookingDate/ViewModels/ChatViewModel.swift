//
//  ChatViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 15.03.25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

@Observable
class ChatViewModel {
    var messages: [Message] = []
    private var chatId: String
    private var listener: ListenerRegistration?
    
    
    init(chatId: String) {
        self.chatId = chatId
        listenForMessages()
    }
    
    private func listenForMessages() {
        let db = Firestore.firestore()
        listener = db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let documents = snapshot?.documents {
                    self.messages = documents.compactMap { try? $0.data(as: Message.self) }
                }
            }
    }
    
    func sendMessage(text: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let message = Message(
            chatId: chatId,
            senderId: userId,
            text: text,
            timestamp: Date()
        )
        
        let db = Firestore.firestore()
        do {
            try db.collection("chats")
                .document(chatId)
                .collection("messages")
                .addDocument(from: message)
            
            db.collection("chats").document(chatId).updateData([
                "lastMessage": text,
                "timestamp": Date()
            ])
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}
