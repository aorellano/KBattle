//
//  CreateValidator.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import Foundation
import UIKit

struct CreateValidator {
    func validate(_ user: RegistrationDetails, and pic: UIImage?) throws {
        if user.username.isEmpty {
            throw CreateValidatorError.invalidUsername
        }
        
        if user.email.isEmpty {
            throw CreateValidatorError.invalidEmail
        }
        
        if user.password.isEmpty {
            throw CreateValidatorError.invalidPassword
        }
        
        if pic == nil {
            throw CreateValidatorError.invalidProfilePic
        }
    }
}

extension CreateValidator {
    enum CreateValidatorError: LocalizedError {
        case invalidUsername
        case invalidEmail
        case invalidPassword
        case invalidProfilePic
    }
}

extension CreateValidator.CreateValidatorError {
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Email can't be empty"
        case .invalidUsername:
            return "Username can't be empty"
        case .invalidProfilePic:
            return "Picture needs to be selected"
        case .invalidPassword:
            return "Password can't be empty "
        }
    }
}
