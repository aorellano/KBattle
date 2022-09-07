//
//  Game.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import Foundation

struct Game: Codable, Identifiable, Hashable {
    let id: String
    let host: String
    let players: [[String:String]]
    var isPrivate: Bool
    let hasStarted: Bool
    let code: String
}

enum GameStatus {
    case started
    case waiting
    case ended
}
