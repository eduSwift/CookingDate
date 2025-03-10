//
//  UserProfile.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 10.03.25.
//

import Foundation
import FirebaseFirestore


struct UserProfile: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var profileImageURL: String
    var age: Int
    var location: GeoPoint?
    var aboutMe: String
    var lookingFor: String
    var onlineStatus: Bool
    var status: String
    var canHost: Bool
    var isMobile: Bool
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
           lhs.id == rhs.id
       }
}
