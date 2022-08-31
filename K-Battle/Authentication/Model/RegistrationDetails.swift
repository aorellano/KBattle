//
//  RegistrationDetails.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import Foundation

struct RegistrationDetails {
    var email: String
    var password: String
    var username: String
    var profilePicUrl: String
}

extension RegistrationDetails {
    static var new: RegistrationDetails {
        RegistrationDetails(email: "", password: "", username: "", profilePicUrl: "")
    }
}
