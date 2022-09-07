//
//  GameNotification.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import Foundation

enum GameState {
    case gameStarted
    case gameEnded
    case hasntStarted
}

struct GameNotification {
    static let gameStarted = "The game has started"
    static let gameEnded = "The game has ended"
    static let hasntStarted = "The game has not started yet"
}
