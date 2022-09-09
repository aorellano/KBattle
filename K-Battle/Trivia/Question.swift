//
//  Question.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Question: Codable {
    var id: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    var song: String
    
    var answers: [Answer] {
        do {
            let correctAnswer = [Answer(text: try AttributedString(markdown: correctAnswer), isCorrect: true)]
            let incorrectAnswers = try incorrectAnswers.map { answer in
                Answer(text: try AttributedString(markdown: answer), isCorrect: false)
            }
            let allAnswers = correctAnswer + incorrectAnswers
            return allAnswers.shuffled()
        } catch {
            print("Error setting answers: \(error)")
            return []
        }
    }
}
