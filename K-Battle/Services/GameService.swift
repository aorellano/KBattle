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
    func joinGame(with user: SessionUserDetails, and code: String)
}

class GameServiceImpl: ObservableObject, GameService {
    static let shared = GameServiceImpl()
    @Published var game: Game!
    
    init() { }
    func createNewGame(with user: SessionUserDetails) {
        print("Creating game for \(user.id)")
        let userInfo = ["id": user.id, "profilePic": user.profilePic, "username": user.username]
        let gameCode = UUID().uuidString.prefix(6)
        let songIds = Array(songIds.shuffled().prefix(5))
        self.game = Game(id: UUID().uuidString, host: user.id, players: [["id": userInfo["id"]!, "profilePic": userInfo["profilePic"]!, "username": userInfo["username"]!, "score": "0"]], isPrivate: true, hasStarted: false, code: String(gameCode), questions: songIds)
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
                if self.game.players.count == 6 {
                    self.game = nil
                } else {
                    self.updateGame(self.game)
                    self.listenForGameChanges(self.game)
                    addPlayer(userInfo, to: game)
                    print("The game has been found")
                }
            } else {
                self.game = nil
            }
        }
    }
    
    func joinGame(with user: SessionUserDetails, and code: String) {
        let userInfo = ["id": user.id, "profilePic": user.profilePic, "username": user.username]
        FirebaseReference(.game).whereField("code", isEqualTo: code).getDocuments { [self] querySnapshot, error in
            if let gameData = querySnapshot?.documents.first {
                self.game = try? gameData.data(as: Game.self)
                if self.game.players.count == 6 {
                    self.game = nil
                } else {
                    self.updateGame(self.game)
                    self.listenForGameChanges(self.game)
                    addPlayer(userInfo, to: game)
                    print("The game has been found")
                }
            } else {
                self.game = nil
            }
        }
    }
    
    func addPlayer(_ info: [String:String], to game: Game){
        let gameRef = FirebaseReference(.game).document(game.id)
        gameRef.updateData(["players": FieldValue.arrayUnion([["id":info["id"], "profilePic":info["profilePic"], "username":info["username"], "score":"0"]])])
    }
    

    func removePlayer(_ info: SessionUserDetails, to game: Game) {
        let userInfo = ["id": info.id, "profilePic": info.profilePic, "username": info.username]
        let gameRef = FirebaseReference(.game).document(game.id)
        gameRef.updateData(["players": FieldValue.arrayRemove([["id":userInfo["id"], "profilePic":userInfo["profilePic"], "username":userInfo["username"], "score":"0"]])])
    }
    

    
    
    func getSong(with id: String) async throws -> [Question] {
        let snapshot = try await FirebaseReference(.questions).whereField("id", isEqualTo: id).getDocuments()
        return snapshot.documents.compactMap { document in
            let data = document.data()
                let id = data["id"] as? String ?? ""
                let correctAnswer = data["correctAnswer"] as? String ?? ""
                let incorrectAnswers = data["incorrectAnswers"] as? [String] ?? [""]
                let song = data["song"] as? String ?? ""
                print("This is the question \(id) \(correctAnswer)")
                return Question(id: id, correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers, song: song)
        }
    }
    
    func updatePlayerScore(with score: Int, and player: SessionUserDetails) {
        let userInfo = ["id": player.id, "profilePic": player.profilePic, "username": player.username, "score": String(score)]
        let id = player.id
        FirebaseReference(.game).document(game.id).updateData([
            "\(id).score" : userInfo["score"]
        ])
    }
    
    func deleteGame(with gameId: String) {
        FirebaseReference(.game).document(gameId).delete()
    }
    
    func updatePlayerTotalScore(with id: String, and score: Int) {
        let userRef = FirebaseReference(.users).document(id)
        userRef.updateData(["totalScore": FieldValue.increment(Int64(score))]) { error in
            if let err = error {
                print(err)
                return
            }
        }
    }
}

//when the host leaves the game a new host should be assigned
