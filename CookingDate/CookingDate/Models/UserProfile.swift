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
    var username: String
    var age: Int
    var aboutMe: String
    var lookingFor: String
    var onlineStatus: Bool
    var status: String
    var canHost: Bool
    var isMobile: Bool
    var locationString: String
    var geoPoint: GeoPoint?
   
   

   
    
    static func == (lhs: UserProfile, rhs: UserProfile) -> Bool {
           lhs.id == rhs.id
       }
    
}
