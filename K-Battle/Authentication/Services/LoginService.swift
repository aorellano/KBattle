//
//  LoginService.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import Foundation
import FirebaseAuth

protocol LoginService {
    func login(with credentials: LoginCredentials) async throws -> AuthDataResult
}

final class LoginServiceImpl: LoginService {
    func login(with credentials: LoginCredentials) async throws -> AuthDataResult {
        let result = try await Auth.auth().signIn(withEmail: credentials.email, password: credentials.password)
        return result
    }
}
