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
import FirebaseAuth

class WaitingRoomViewModel: ObservableObject {
    var gameType: GameType
    var sessionService: SessionServiceImpl
    var playerCount = 0
    var songs = [Question]()
    @Published var song = ""
    @Published var songIds = [String]()
    @Published var currentQuestion: Question = Question(id: "", correctAnswer: "", incorrectAnswers: [""], song: "")
    @Published var answers: [Answer] = [Answer]()
    @Published var gameNotification = GameNotification.hasntStarted
    @Published var game: Game? {
        didSet {
            updateGameNotificationForGame(game)
            print("didSet \(game)")
            print("didSet \(gameNotification)")
            songIds = self.game?.questions ?? [""]
        }
    }
    private var cancellables: Set<AnyCancellable> = []
    
    init(with gameType: GameType, sessionService: SessionServiceImpl) {
        game = nil
        
        self.gameType = gameType
        self.sessionService = sessionService
        print("init")
        self.gameNotification = GameNotification.hasntStarted
        print(gameNotification)
        //setupGame(with: gameType)
    }
    
    func setupGame(with gameType: GameType) {
        switch gameType {
        case .NewGame:
            GameServiceImpl.shared.createNewGame(with: sessionService.userDetails ?? SessionUserDetails(id: "", username: "", profilePic: "", totalScore: 0))
            GameServiceImpl.shared.$game
                .assign(to: \.game, on: self)
                .store(in: &cancellables)
            print("Starting New Game")
            print(self.game)
            guard let players = self.game?.players.count else { return }
            playerCount = players
            songIds = self.game?.questions ?? [""]
        case .JoinRandomGame:
            GameServiceImpl.shared.joinGame(with: sessionService.userDetails ?? SessionUserDetails(id: "", username: "", profilePic: "", totalScore: 0))
            GameServiceImpl.shared.$game
                .assign(to: \.game, on: self)
                .store(in: &cancellables)
            print("Joining Random Game")
            songIds = self.game?.questions ?? [""]
        case .JoinGame(let code):
            GameServiceImpl.shared.joinGame(with: sessionService.userDetails ?? SessionUserDetails(id: "", username: "", profilePic: "", totalScore: 0), and: code)
            GameServiceImpl.shared.$game
                .assign(to: \.game, on: self)
                .store(in: &cancellables)
            print("Joining game with \(code)")
        }
    }
    
    func updateGameNotificationForGame(_ state: Game?) {
        print("update")
        if game?.hasStarted == true {
            gameNotification = GameNotification.gameStarted
            print(gameType)
        }
    }
    
    func makeGamePrivate() {
        game?.isPrivate.toggle()
        GameServiceImpl.shared.updateGame(self.game!)
    }
    
    func removePlayer() {
        guard let playerInfo = sessionService.userDetails else { return }
        GameServiceImpl.shared.removePlayer(playerInfo, to: game!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.90) {
            self.changeHost(from: playerInfo.id)
        }
        
    }
    
    func changeHost(from id: String) {
        let newHost = game?.players.first(where: {$0["id"] != id})
        if let newHost = newHost {
            GameServiceImpl.shared.game.host = newHost["id"]!
            GameServiceImpl.shared.updateGame(self.game!)
        } else {
            GameServiceImpl.shared.deleteGame(with: game!.id)
        }
    }

    func startGame() {
        GameServiceImpl.shared.game.hasStarted = true
        GameServiceImpl.shared.updateGame(self.game!)
    }
    
    @MainActor
    func getSong(with index: Int) {
        Task.init {
            self.currentQuestion = try await GameServiceImpl.shared.getSong(with: songIds[index]).first ??  Question(id: "", correctAnswer: "", incorrectAnswers: [""], song: "")
            self.answers = currentQuestion.answers
            self.song = currentQuestion.song
            AudioManager.shared.startPlayer(with: self.song)
            print("Audio should start")
        }
    }
}
