//
//  WaitingRoomViewModel.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import Foundation


class WaitingRoomViewModel: ObservableObject {
    var gameType: GameType
    
    init(with gameType: GameType) {
        self.gameType = gameType
        setupGame(with: gameType)
    }
    
    func setupGame(with gameType: GameType) {
        switch gameType {
        case .NewGame:
            GameServiceImpl.shared.createNewGame()
            print("Starting New Game")
        case .JoinRandomGame:
            print("Joining Random Game")
        case .JoinGame(let code):
            print("Joining game with \(code)")
        }
    }
}
