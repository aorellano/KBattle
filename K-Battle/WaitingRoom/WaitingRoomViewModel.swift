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
    var songs = [Question]()
    @Published var song = ""
    @Published var songIds = [String]()
    @Published var currentQuestion: Question = Question(id: "", correctAnswer: "", incorrectAnswers: [""], song: "")
    @Published var answers: [Answer] = [Answer]()
    @Published var gameNotification = GameNotification.hasntStarted
    @Published var game: Game? {
        didSet {
            updateGameNotificationForGame(game)
            print("updating")
            songIds = self.game?.questions ?? [""]
            print(songIds)
        }
    }
    private var cancellables: Set<AnyCancellable> = []
    
    init(with gameType: GameType, sessionService: SessionServiceImpl) {
        game = nil
        self.gameType = gameType
        self.sessionService = sessionService
        print("init")
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
            print(self.game)
            guard let players = self.game?.players.count else { return }
            playerCount = players
            songIds = self.game?.questions ?? [""]
        case .JoinRandomGame:
            GameServiceImpl.shared.joinGame(with: sessionService.userDetails ?? SessionUserDetails(id: "", username: "", profilePic: ""))
            GameServiceImpl.shared.$game
                .assign(to: \.game, on: self)
                .store(in: &cancellables)
            print("Joining Random Game")
            songIds = self.game?.questions ?? [""]
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
    
    func changeHost() {
        if let newHost = game?.players.randomElement() {
            GameServiceImpl.shared.game.host = newHost["id"]!
            GameServiceImpl.shared.updateGame(self.game!)
        } else {
            //delete the game
        }
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
