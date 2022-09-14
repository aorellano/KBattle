//
//  Game.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import Foundation

struct Game: Codable, Identifiable, Hashable {
    
    let id: String
    var host: String
    var players: [[String:String]]
    var isPrivate: Bool
    var hasStarted: Bool
    let code: String
    let questions: [String]
}

enum GameStatus {
    case started
    case waiting
    case ended
}

