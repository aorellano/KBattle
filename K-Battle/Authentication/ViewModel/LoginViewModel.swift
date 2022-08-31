//
//  LoginViewModel.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import Foundation

enum LoginState {
    case successful
    case failed(error: Error)
    case na
}

protocol LoginViewModel {
    func login() async
    init(service: LoginService)
    var service: LoginService { get }
    var hasError: Bool { get }
    var credentials: LoginCredentials { get }
    var state: LoginState { get }
}

final class LoginViewModelImpl: ObservableObject, LoginViewModel {
    @Published var credentials: LoginCredentials = LoginCredentials.new
    @Published var state: LoginState = .na
    @Published var hasError: Bool = false
    
    let service: LoginService
    
    init(service: LoginService) {
        self.service = service
    }
    
    @MainActor
    func login() async {
        do {
            let result = try await service.login(with: credentials)
            let user = result.user
            print("Signed in as user \(user.uid), with email: \(user.email)")
            state = .successful
        }
        catch {
            print("There was an issue when trying to sign in: \(error)")
            hasError = true
        }
    }
}
