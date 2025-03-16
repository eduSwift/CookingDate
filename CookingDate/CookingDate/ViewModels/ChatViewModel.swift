//
//  ChatViewModel.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 15.03.25.
//

import Foundation
import Firebase
import FirebaseAuth

@Observable
class ChatViewModel {
    var messages: [Message] = []
    private var listener: ListenerRegistration?
    private var conversationId: String
    
    init(conversationId: String) {
        self.conversationId = conversationId
        listenForMessages()
    }
    
    private func listenForMessages() {
        let db = Firestore.firestore()
        
        listener = db.collection("chats")
            .document(conversationId)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching messages: \(error?.localizedDescription ?? "")")
                    return
                }
                
                self.messages = documents.compactMap { document in
                    try? document.data(as: Message.self)
                }
            }
    }
    
    func sendMessage(text: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let message = Message(
            chatId: conversationId,
            senderId: userId,
            text: text,
            timestamp: Date()
        )
        
        let db = Firestore.firestore()
        do {
            try db.collection("chats")
                .document(conversationId)
                .collection("messages")
                .addDocument(from: message)
            
            db.collection("chats").document(conversationId).updateData([
                "lastMessage": text,
                "timestamp": Date()
            ])
        } catch {
            print("Error sending message: \(error.localizedDescription)")
        }
    }
}
