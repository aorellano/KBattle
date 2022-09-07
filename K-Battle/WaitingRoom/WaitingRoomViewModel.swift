//
//  WaitingRoomViewModel.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class WaitingRoomViewModel: ObservableObject {
    var gameType: GameType
    var sessionService: SessionServiceImpl
    var playerCount = 0
    @Published var gameNotification = GameNotification.hasntStarted
    @Published var game: Game? {
        didSet {
            updateGameNotificationForGame(game)
        }
    }
    private var cancellables: Set<AnyCancellable> = []
    
    init(with gameType: GameType, sessionService: SessionServiceImpl) {
        game = nil
        self.gameType = gameType
        self.sessionService = sessionService
        
        setupGame(with: gameType)
    }
    
    func setupGame(with gameType: GameType) {
        switch gameType {
        case .NewGame:
            GameServiceImpl.shared.createNewGame(with: sessionService.userDetails ?? SessionUserDetails(id: "", username: "", profilePic: ""))
            GameServiceImpl.shared.$game
                .assign(to: \.game, on: self)
                .store(in: &cancellables)
            print("Starting New Game")
            guard let players = self.game?.players.count else { return }
            playerCount = players
        case .JoinRandomGame:
            GameServiceImpl.shared.joinGame(with: sessionService.userDetails ?? SessionUserDetails(id: "", username: "", profilePic: ""))
            GameServiceImpl.shared.$game
                .assign(to: \.game, on: self)
                .store(in: &cancellables)
            print("Joining Random Game")
        case .JoinGame(let code):
            GameServiceImpl.shared.joinGame(with: sessionService.userDetails ?? SessionUserDetails(id: "", username: "", profilePic: ""), and: code)
                GameServiceImpl.shared.$game
                    .assign(to: \.game, on: self)
                    .store(in: &cancellables)
            
            print("Joining game with \(code)")
        }
    }
    
    func updateGameNotificationForGame(_ state: Game?) {
        if game?.hasStarted == true {
            gameNotification = GameNotification.gameStarted
        }
    }
    
    func makeGamePrivate() {
        game?.isPrivate.toggle()
        GameServiceImpl.shared.updateGame(self.game!)
    }
    
    func removePlayer() {
        guard let details = sessionService.userDetails else { return }
        GameServiceImpl.shared.removePlayer(with: details, for: self.game!.id)
    }
    
    func startGame() {
        GameServiceImpl.shared.game.hasStarted = true
        GameServiceImpl.shared.updateGame(self.game!)
    }
}
