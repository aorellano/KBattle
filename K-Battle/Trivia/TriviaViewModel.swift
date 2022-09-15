//
//  TriviaViewModel.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import Combine

class TriviaViewModel: ObservableObject {
    @Published var songs = [Question]()
    @Published var answers: [Answer] = [Answer]()
    @Published var question: Question?
    @Published var answerSelected = false
    @Published var songIds = [String]()
    @Published var currentQuestion: Question = Question(id: "", correctAnswer: "", incorrectAnswers: [""], song: "")
    @Published var song = ""
    @Published var score = 0
    @Published var streakCtr = 0
    var service: TriviaService
    private var cancellables: Set<AnyCancellable> = []
    @Published var game: Game? {
        didSet {
            //GameServiceImpl.shared.updateGame(game)
        }
        
    }
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var sessionService: SessionService
    @Published var playerNumber = 1
    
    init(game: Game, currentQuestion: Question, answers: [Answer], songIds: [String], sessionService: SessionServiceImpl, service: TriviaService = TriviaServiceImpl()) {
        self.game = game
        self.service = service
        self.currentQuestion = currentQuestion
        self.answers = answers
        self.songIds = songIds
        self.sessionService = sessionService
        print(self.game)
        setupGame()
        setPlayerNumber()
    }
    func setupGame() {
        GameServiceImpl.shared.$game
            .assign(to: \.game, on: self)
            .store(in: &cancellables)
    }
    func setPlayerNumber() {
        for index in game!.players.indices {
            let player = game!.players[index]
            if player["id"] == Auth.auth().currentUser?.uid {
                playerNumber = index
                print(playerNumber)
            }
        }
    }
    
    @MainActor
    func setNextQuestion(with index: Int) {
        Task.init {
            self.currentQuestion = try await GameServiceImpl.shared.getSong(with: songIds[index]).first ??  Question(id: "", correctAnswer: "", incorrectAnswers: [""], song: "")
            self.answers = currentQuestion.answers
            self.song = currentQuestion.song
            AudioManager.shared.startPlayer(with: self.song)
            print("Audio should start")
        }
    }
    
    func selectAnswer(answer: Answer, with time: CGFloat) {
        answerSelected = true
        
        if answer.isCorrect {
            print("playerNumber \(playerNumber)")
            let roundedValue = round(time * 10) / 10.0
            let points = 10 - (round((10-roundedValue) * 10)/10.0)
            let totalPoints = Int(round(roundedValue * 10)) + (streakCtr * 10)
            score += totalPoints
            let playerId = Auth.auth().currentUser?.uid
            guard let userDetails = sessionService.userDetails else { return }
            let player = game!.players[playerNumber]
            GameServiceImpl.shared.game.players[playerNumber]["score"] = String(score)
       
            GameServiceImpl.shared.updateGame(self.game!)
            print("game: \(game)")
            streakCtr += 1
        } else {
            score += 0
            streakCtr = 0
            GameServiceImpl.shared.game.players[playerNumber]["score"] = String(score)
            GameServiceImpl.shared.updateGame(self.game!)
        }
        
        //updatePlayersScore(answer: answer)
        print("Player Score: \(self.score)")
    }
    
    func updatePlayersScore(answer: Answer) {
        
        //
    }
}
