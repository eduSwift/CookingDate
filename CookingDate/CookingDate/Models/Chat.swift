//
//  Chat.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 15.03.25.
//

import Foundation
import FirebaseFirestore

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    var userIds: [String]
    var lastMessage: String
    var timestamp: Date
}
