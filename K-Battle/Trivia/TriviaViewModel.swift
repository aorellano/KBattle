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
    @Published var answers: [Answer] = []
    @Published var question: Question?
    @Published var answerSelected = false
    var service: TriviaService
    
    init(service: TriviaService = TriviaServiceImpl()) {
        self.service = service
    }
    
    @MainActor
    func fetchSongs() async {
        Task.init {
            self.songs = try await service.getQuestions()
            setQuestion()
        }
        
    }
    
    func setQuestion() {
        let currentQuestion = songs.randomElement()
        question = currentQuestion
        answers = question?.answers ?? [Answer(text: "", isCorrect: false)]
    }
}
