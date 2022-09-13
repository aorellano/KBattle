//
//  AnswerRow.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import SwiftUI

struct AnswerRow: View {
    @StateObject var viewModel: TriviaViewModel
    @State private var isSelected = false
    @State var backgroundColor: Color = .white
    @State var timeRemaining = 10.0
    var answer: Answer
    
    init(_ answer: Answer, _ viewModel: TriviaViewModel, timeRemaining: CGFloat) {
        self.answer = answer
        
        _viewModel = StateObject(wrappedValue: viewModel)
        self.timeRemaining = timeRemaining
    }
    
    var body: some View {
        ZStack {
            HStack {
                Text(answer.text)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 4, x: 0.5, y: 0.5)
            .scaleEffect(isSelected ? 0.96:1)
            .animation(.spring(response: 0.9, dampingFraction: 0.8), value: 0.6)
            .onTapGesture {
                if !viewModel.answerSelected {
                    isSelected = true
                    viewModel.selectAnswer(answer: answer, with: timeRemaining)
                }
                isSelected.toggle()
                if answer.isCorrect {
                    backgroundColor = Color(uiColor: UIColor.systemGreen)
                    hapticFeedbackResponse(style: .light)
                } else {
                    backgroundColor = Color(uiColor: UIColor.systemRed)
                    hapticFeedbackResponse(style: .heavy)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    isSelected = false
                }
            }
        }.onReceive(viewModel.timer) { time in
            if timeRemaining > 0.1 {
                timeRemaining -= 0.1
            }
        }
    }
    func hapticFeedbackResponse(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactMed = UIImpactFeedbackGenerator(style: style)
        impactMed.impactOccurred()
    }
}
