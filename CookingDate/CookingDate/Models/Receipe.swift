//
//  Receipe.swift
//  CookingDate
//
//  Created by Eduardo Rodrigues da Cruz on 24.02.25.
//

import Foundation

struct Receipe: Identifiable, Codable {
    let id: String
    let image: String
    let name: String
    let description: String
    let time: Int
    
    
}
