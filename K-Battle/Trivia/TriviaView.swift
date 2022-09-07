//
//  TriviaView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import SwiftUI

struct TriviaView: View {
    @State var timeRemaining = 15
    @StateObject var viewModel: TriviaViewModel
    
    init(viewModel: TriviaViewModel = .init()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Users")
                Spacer()
                Text("Time Remaining")
            }
            .padding([.top, .leading, .trailing], 20)
            ProgressBar(progress: CGFloat(timeRemaining*20))
                .padding(.bottom, 40)
           
            Text("Guess the Song")
                .fontWeight(.bold)
                .font(.system(size: 20))
            
            Spacer()
           
            ZStack {
                
            ForEach(0..<360) { i in
                Bar(maxHeight: 25, minHeight: 1, width: 1)
                    .offset(y: 150)
                    .rotationEffect(.degrees(1 * Double(i)))
            }
       
            
            HStack(spacing: 4) {
                ForEach(0..<4) { _ in
                    Bar(maxHeight: 75, minHeight: 10, width: 15)
                }
            }
            
            }.padding()
            
                
            Spacer()
            ForEach(viewModel.answers) { answer in
                AnswerRow(answer, viewModel)
            }
            .padding([.leading, .trailing], 15)
            
        }.task {
            await viewModel.fetchSongs()
        }
       
        .navigationBarHidden(true)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
    }
}

struct Bar: View {
    @State private var height: CGFloat = 10
    let animationSpeed: Double = 0.3
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let width: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: width/2)
                .frame(width: width, height: height)
                .animation(.easeInOut(duration: animationSpeed), value: 1.2)
                .foregroundColor(.green)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: animationSpeed, repeats: true) {_ in
                        height = CGFloat.random(in: minHeight...maxHeight)
                    }
                }
        }
        .frame(width: width, alignment: .bottom)
    }
}

struct TriviaView_Previews: PreviewProvider {
    static var previews: some View {
        TriviaView()
    }
}
