//
//  LoginCredentials.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import Foundation

struct LoginCredentials {
    var email: String
    var password: String
}

extension LoginCredentials {
    static var new: LoginCredentials {
        LoginCredentials(email: "", password: "")
    }
}
