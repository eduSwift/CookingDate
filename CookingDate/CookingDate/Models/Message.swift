//
//  Message.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 15.03.25.
//

import Foundation
import FirebaseFirestore

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var chatId: String
    var senderId: String
    var text: String
    var timestamp: Date
}
