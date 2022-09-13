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
    
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: NavigationLazyView(ResultsView()), isActive: $isActive){
                EmptyView()
            }.isDetailLink(false)
        
            VStack {
                if showCountdown {
                    CountdownScreen()
                } else {
                    HStack {
                        UsersRow(players: viewModel.game.players ?? [["":""]])
                        Spacer()
                        Text("\(String(Int (timeRemaining)))")
                            .fontWeight(.bold)
                            .font(.system(size: 28))
                            .foregroundColor(Color.primaryColor)
                    }
                    .padding([.top, .leading, .trailing], 20)
                    ProgressBar(progress: CGFloat((timeRemaining)*20))
                        .padding(.bottom, 40)
                    
                    Text(viewModel.currentQuestion.id)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    
                    Spacer()
                    
                    ZStack {
                        
                        //            ForEach(0..<360) { i in
                        //                Bar(maxHeight: 25, minHeight: 1, width: 1, animate: animate)
                        //                    .offset(y: 150)
                        //                    .rotationEffect(.degrees(1 * Double(i)))
                        //            }
                        
                        
                        HStack(spacing: 4) {
                            ForEach(0..<4) { _ in
                                Bar(maxHeight: 75, minHeight: 10, width: 15, animate: animate)
                            }
                        }
                        
                    }.padding()
                    
                    
                    Spacer()
                    ForEach(viewModel.answers) { answer in
                        AnswerRow(answer, viewModel)
                    }
                    .padding([.leading, .trailing], 15)
                }
            }
        }.onChange(of: viewModel.currentQuestion) { _ in
           
//            guard let url = URL(string: viewModel.song) else { return }
//            print(url)
//            do {
//                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
//            }catch {
//                print("The audio couldnt play")
//            }
//            player = AVPlayer(playerItem: AVPlayerItem(url: url))
            //player.play()
           // AudioManager.shared.player?.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                animate = true
                print("Audio started")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(7)) {
                animate = false
 
            }
            print("new question has been set")
            
            
        }
     
        .onReceive(viewModel.timer) { time in
            if timeRemaining > 0.1 {
                timeRemaining -= 0.1
                let roundedValue = round(timeRemaining * 10) / 10.0
                print(roundedValue)
            } else if timeRemaining == 0.0 {
                if questionCtr == 5 {
                    viewModel.timer.upstream.connect().cancel()
                    isActive = true
                    print("end of game")
                } else {
                    viewModel.timer.upstream.connect().cancel()
                    viewModel.setNextQuestion(with: 1)
                    questionCtr += 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        showCountdown = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                            timeRemaining = 10
                            showCountdown = false
                            AudioManager.shared.player?.playImmediately(atRate: 1.0)
                            viewModel.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        }
                    }
                }
                
            }
        }
        
       
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                AudioManager.shared.player?.playImmediately(atRate: 1.0)
                
            }
            
            print("hello")
            print("url \(viewModel.currentQuestion)")
            print("onAppear")

        }
        
        .navigationBarHidden(true)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        print("did finish playing")
    }
}

struct Bar: View {
    @State private var height: CGFloat = 10
    let animationSpeed: Double = 0.3
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let width: CGFloat
    let animate: Bool
    
    var body: some View {
        if animate {
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
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: width/2)
                    .frame(width: width, height: height)
                    .animation(.easeInOut(duration: 0), value: 1.2)
                    .foregroundColor(.green)
                    .onAppear {
                        Timer.scheduledTimer(withTimeInterval: animationSpeed, repeats: true) {_ in
                            height = 10
                        }
                    }
            }
            .frame(width: width, alignment: .bottom)
        }
    }
}


