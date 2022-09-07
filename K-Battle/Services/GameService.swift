//
//  GameService.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

protocol GameService {
    func createNewGame(with user: SessionUserDetails)
    func joinGame(with user: SessionUserDetails)
    func joinGame(with user: SessionUserDetails, and code: String) -> Bool
}

class GameServiceImpl: ObservableObject, GameService {
    static let shared = GameServiceImpl()
    @Published var game: Game!
    
    init() { }
    func createNewGame(with user: SessionUserDetails) {
        print("Creating game for \(user.id)")
        let userInfo = ["id": user.id, "profilePic": user.profilePic, "username": user.username]
        let gameCode = UUID().uuidString.prefix(6)
        self.game = Game(id: UUID().uuidString, host: user.id, players: [["id": userInfo["id"]!, "profilePic": userInfo["profilePic"]!, "username": userInfo["username"]!]], isPrivate: true, hasStarted: false, code: String(gameCode))
        self.updateGame(self.game)
        self.createOnlineGame()
        self.listenForGameChanges(self.game)
    }
    
    func createOnlineGame() {
        do {
            try FirebaseReference(.game).document(self.game.id).setData(from: self.game)
        } catch {
            print("Error creating online game: \(error.localizedDescription)")
        }
    }
    
    func updateGame(_ game: Game) {
        do {
            try FirebaseReference(.game).document(game.id).setData(from: game)
        } catch {
            print("Error creating online game \(error.localizedDescription)")
        }
    }
    
    func listenForGameChanges(_ game: Game) {
        FirebaseReference(.game).document(game.id).addSnapshotListener { [self] documentSnapshot, error in
            if error != nil {
                print("Error listening to changes \(String(describing: error?.localizedDescription))")
            }

            if let snapshot = documentSnapshot {
                self.game = try? snapshot.data(as: Game.self)
            }
        }
    }
    
 
    func joinGame(with user: SessionUserDetails) {
        let userInfo = ["id": user.id, "profilePic": user.profilePic, "username": user.username]
        FirebaseReference(.game).whereField("hasStarted", isEqualTo: false).whereField("isPrivate", isEqualTo: false).getDocuments { [self] querySnapshot, error in
            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                self.updateGame(self.game)
                self.listenForGameChanges(self.game)
                addPlayer(userInfo, to: game)
                print("The game has been found")
            } else {
                self.game = nil
            }
            
        }
    }
    
    func joinGame(with user: SessionUserDetails, and code: String) -> Bool {
        let userInfo = ["id": user.id, "profilePic": user.profilePic, "username": user.username]
        var gameAvailable = true
        FirebaseReference(.game).whereField("code", isEqualTo: code).getDocuments { [self] querySnapshot, error in
            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                self.updateGame(self.game)
                self.listenForGameChanges(self.game)
                addPlayer(userInfo, to: self.game)
            } else {
                self.game = nil
            }
        }
        return gameAvailable
    }
    
    func addPlayer(_ info: [String:String], to game: Game) {
        let gameRef = FirebaseReference(.game).document(game.id)
        gameRef.updateData(["players": FieldValue.arrayUnion([["id":info["id"], "profilePic":info["profilePic"], "username":info["username"]]])])
    }
    

    func removePlayer(with info: SessionUserDetails, for game: String) {
        let userInfo = ["id": info.id, "profilePic": info.profilePic, "username": info.username]
        
        let gameRef = FirebaseReference(.game).document(game)
        gameRef.updateData(["players": FieldValue.arrayRemove([["id":userInfo["id"], "profilePic":userInfo["profilePic"], "username":userInfo["username"]]])])
        
    }
    
    func removePlayer(with id: String, for game: String) {
       // let userInfo = ["id": info.id, "profilePic": info.profilePic, "username": info.username]
        
        let gameRef = FirebaseReference(.game).document(game)
        gameRef.updateData(["players": FieldValue.arrayRemove([["id":id]])])
        
    }
}

//when the host leaves the game a new host should be assigned
