//
//  FirebaseReference.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case users
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
