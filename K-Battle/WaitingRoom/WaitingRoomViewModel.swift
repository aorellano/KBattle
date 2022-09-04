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
    @Published var game: Game?
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
}
