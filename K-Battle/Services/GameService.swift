//
//  GameService.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import Foundation
import Firebase

protocol GameService {
    func createNewGame()
    func joinGame()
    func getGame() async throws -> [Game]
}
class GameServiceImpl: ObservableObject, GameService {
    func createNewGame() {
        //add players in a array
    }
    
    func joinGame() {
        //
    }
    
    func getGame() async throws -> [Game] {
        let snapshot = try await FirebaseReference(.games).whereField("id", isEqualTo: "gHuPUC7S1Fhv3ShnFSQy").getDocuments()
        
        return snapshot.documents.compactMap { document in
            let data = document.data()
            let id = data["id"] as? String ?? ""
            let players = data["players"] as? [[String:String]] ?? [["":""]]
            return Game(id: id, players: players)
            
        }
        
            
    }
}

//create a new game
//join a game with a code
//join random game
