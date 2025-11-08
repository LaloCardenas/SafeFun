//
//  User.swift
//  SafeFun
//
//  Created by Santiago Amezcua
//

import Foundation

struct User {
    var firstName: String
    var lastName: String
    var username: String
    var team : String
    var emergencyContacts: [EmergencyContact]
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

struct EmergencyContact: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var phone: String
}
