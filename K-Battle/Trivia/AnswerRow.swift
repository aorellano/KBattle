//
//  AnswerRow.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import SwiftUI

struct AnswerRow: View {
    @StateObject var viewModel: WaitingRoomViewModel
    @State private var isSelected = false
    @State var backgroundColor: Color = .white
    var answer: Answer
    
    init(_ answer: Answer, _ viewModel: WaitingRoomViewModel) {
        self.answer = answer
        _viewModel = StateObject(wrappedValue: viewModel)
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
        }
    }
    func hapticFeedbackResponse(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactMed = UIImpactFeedbackGenerator(style: style)
        impactMed.impactOccurred()
    }
}
