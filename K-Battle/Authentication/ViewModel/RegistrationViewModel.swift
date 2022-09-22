//
//  RegisterViewModel.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import Foundation
import UIKit

enum RegistrationState {
    case successful
    case failed(error: Error)
    case na
}

protocol RegistrationViewModel {
    func register() async
    init(service: RegistrationService)
    var service: RegistrationService { get }
    var userDetails: RegistrationDetails { get }
    var profilePic: UIImage? { get set }
    var state: RegistrationState { get }
    var hasError: Bool { get }
    var validator: CreateValidator { get }
    var error: FormError? { get }
    
}

final class RegistrationViewModelImpl: ObservableObject, RegistrationViewModel {
    let service: RegistrationService
    @Published var userDetails: RegistrationDetails = RegistrationDetails.new
    var profilePic = UIImage(contentsOfFile: "")
    var state: RegistrationState = .na
    var hasError: Bool = false
    var validator = CreateValidator()
    @Published var error: FormError?
    
    init(service: RegistrationService) {
        self.service = service
    }
    
    @MainActor
    func register() async {
        do {
            try validator.validate(userDetails, and: profilePic)
            do {
                guard let pic = profilePic else { return }
                let result = try await service.register(with: userDetails, and: pic)
                let user = result.user
                print("User created successfully \(user.uid), with email: \(String(describing: user.email))")
                state = .successful
            }
            catch {
                print("An error ocurred trying to create the user: \(error.localizedDescription)")
                hasError = true
            }
        }catch {
            self.error = .validation(error: error as! CreateValidator.CreateValidatorError)
            hasError = true
        }
    }
}


    enum FormError: LocalizedError {
        case validation(error: LocalizedError)
    }

extension FormError {
    var errorDescription: String? {
        switch self {
        case .validation(let err):
            return err.errorDescription
        }
    }
}
    
