//
//  Answer.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import Foundation

struct Answer: Identifiable {
    var id = UUID()
    var text: AttributedString
    var isCorrect: Bool
}
