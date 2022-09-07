//
//  TriviaService.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import Foundation

protocol TriviaService {
    func getQuestions() async throws -> [Question]
}
class TriviaServiceImpl: TriviaService {
    @Published var questions = [Question]()
    
    func getQuestions() async throws -> [Question] {
        let snapshot = try await FirebaseReference(.questions).getDocuments()
        
        return snapshot.documents.compactMap { document in
            let data = document.data()
            let correctAnswer = data["correctAnswer"] as? String ?? ""
            print(correctAnswer)
            let incorrectAnswers = data["incorrectAnswers"] as? [String] ?? [""]
            print(incorrectAnswers)
            let song = data["song"] as? String ?? ""
            print(song)
            return Question(correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers, song: song)
        }.pick(4)
    }
}

extension Array {
    func pick(_ n: Int) -> [Element] {
        guard count >= n else {
            fatalError("The count has to be at least \(n)")
        }
        guard n >= 0 else {
            fatalError("The number of elements to be picked must be positive")
        }

        let shuffledIndices = indices.shuffled().prefix(upTo: n)
        return shuffledIndices.map {self[$0]}
    }
}
