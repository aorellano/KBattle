//
//  RegistrationService.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit

enum RegistrationKeys: String {
    case username
    case email
    case profilePicUrl
}

protocol RegistrationService {
    func register(with details: RegistrationDetails, and profilePic: UIImage) async throws -> AuthDataResult
}

final class RegistrationServiceImpl: ObservableObject, RegistrationService {
    func register(with details: RegistrationDetails, and profilePic: UIImage) async throws -> AuthDataResult {
        let result = try await Auth.auth().createUser(withEmail: details.email, password: details.password)
        let user = result.user
        self.storeProfilePic(of: user.uid, with: details, and: profilePic)
        return result
    }
    
    func storeProfilePic(of uid: String, with details: RegistrationDetails, and profilePic: UIImage) {
        let ref = Storage.storage().reference(withPath: uid)
        let imageData = profilePic.jpegData(compressionQuality: 0.5)!
        ref.putData(imageData, metadata: nil) { metaData, err in
            if let err = err {
                print("Failed to push image to storage \(err)")
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retreive downloadURL \(err)")
                    return
                }
                guard let profilePic = url?.absoluteString else { return }
                self.storeUser(of: uid, with: details, and: profilePic)
                print("Successfully stored image with url: \(profilePic)")
            }
        }
    }
    
    func storeUser(of uid: String, with details: RegistrationDetails, and profilePic: String) {
        let userData = ["uid": uid,
                        RegistrationKeys.username.rawValue: details.username,
                        RegistrationKeys.email.rawValue: details.email,
                        RegistrationKeys.profilePicUrl.rawValue: profilePic
                        ]
        FirebaseReference(.users).document(uid).setData(userData) { err in
            if let err = err {
                print(err)
                return
            }
        }
        print("User details saved!")
    }
}
