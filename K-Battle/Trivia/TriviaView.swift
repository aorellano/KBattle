//
//  TriviaView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/6/22.
//

import SwiftUI
import AVFoundation

struct TriviaView: View {
    @State var timeRemaining = 10.0
    @StateObject var viewModel: TriviaViewModel
    @State var outerMaxHeight = 0
    @State var outerMinHeight = 0
    @State var animate = false
    @State var player = AVPlayer()
    @State var showCountdown: Bool = false
    @State var questionCtr = 1
    @State var isActive: Bool = false
    @State var scale = 1.0
    
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: NavigationLazyView(ResultsView(viewModel: viewModel)), isActive: $isActive){
                EmptyView()
            }.isDetailLink(false)
            VStack {
                if showCountdown {
                    CountdownScreen()
                } else {
                    HStack {
                        UsersRow(viewModel: viewModel)
                        Spacer()
                        Text("\(String(Int (timeRemaining)))")
                            .fontWeight(.bold)
                            .font(.system(size: 28))
                            .foregroundColor(Color.primaryColor)
                    }
                    .padding([.top, .leading, .trailing], 20)
                    ProgressBar(progress: CGFloat((timeRemaining)*32))
                        .padding(.bottom, 40)
                    
                    Text("Guess the Song")
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                    
                    Spacer()
                    
                    ZStack {
                        Image("PandaBody")
                            .resizable()
                            .frame(width: 215, height: 175)
                            .padding(.top, 74)
                            .padding(.leading, 75)
                        Image("PandaHead2")
                            .resizable()
                            .frame(width: 155, height: 155)
                            //.scaleEffect(animate ? 0.9 : 0.8)
                            .scaleEffect(self.scale)
                            .animation(Animation.easeInOut(duration: 1).speed(.random(in: 3...4)).repeatForever(autoreverses: true), value: self.scale)
                            .padding(.top, -100)
                            .padding(.trailing,5)
                            
                            
                        
                    }.padding()
                    Spacer()
                    ForEach(viewModel.answers) { answer in
                        AnswerRow(answer, viewModel, timeRemaining: timeRemaining)
                            .disabled(viewModel.answerSelected)
                    }
                    .padding([.leading, .trailing], 15)
                }
            }
        }.onChange(of: viewModel.currentQuestion) { _ in
            print("new question has been set")
            
        }
     
        .onReceive(viewModel.timer) { time in
            let roundedValue = round(timeRemaining * 10) / 10.0
            if timeRemaining > 0.1 {
                timeRemaining -= 0.1
                self.scale = 0.94
            } else if roundedValue == 0.0 {
                if questionCtr == 5 {
                    viewModel.timer.upstream.connect().cancel()
                    viewModel.updatePlayerTotalScore()
                    isActive = true
                } else {
                    self.scale = 1.0
                    viewModel.timer.upstream.connect().cancel()
                    viewModel.setNextQuestion(with: questionCtr)
                    questionCtr += 1
                   // DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showCountdown = true
                        viewModel.answerSelected = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3) + 0.60) {
                            timeRemaining = 10.0
                            showCountdown = false
                            AudioManager.shared.player?.playImmediately(atRate: 1.0)
                           
                            viewModel.timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
                        }
                    
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                AudioManager.shared.player?.playImmediately(atRate: 1.0)
                animate = true
                
            }
        }
        .navigationBarHidden(true)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
    }
}



