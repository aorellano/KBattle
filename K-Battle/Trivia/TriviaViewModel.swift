//
//  TriviaViewModel.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import Foundation
import FirebaseFirestore

class TriviaViewModel: ObservableObject {
    @Published var songs = [Question]()
    @Published var answers: [Answer] = [Answer]()
    @Published var question: Question?
    @Published var answerSelected = false
    @Published var songIds = [String]()
    @Published var currentQuestion: Question = Question(id: "", correctAnswer: "", incorrectAnswers: [""], song: "")
    @Published var song = ""
    var service: TriviaService
    @Published var game: Game
    var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    init(game: Game, currentQuestion: Question, answers: [Answer], songIds: [String], service: TriviaService = TriviaServiceImpl()) {
        self.game = game
        self.service = service
        self.currentQuestion = currentQuestion
        self.answers = answers
        self.songIds = songIds
        print(self.game)
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
}
