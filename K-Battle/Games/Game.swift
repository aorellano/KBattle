//
//  Game.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import Foundation

struct Game {
    let id: String
    let players: [[String:String]]
}

enum GameStatus {
    case started
    case waiting
    case ended
}
