//
//  GameNotification.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import Foundation

enum GameState{
    case waitingForPlayers
    case newPlayerAdded
}

struct GameNotification {
    static let waitingForPlayers = "Waiting for more players to enter game"
    static let newPlayerAdded = "New player has been added to the game"
}
