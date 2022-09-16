//
//  WaitingRoomView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import SwiftUI
import Firebase
import Introspect

struct WaitingRoomView: View {
    var users = ["mina", "jihyo", "jin", "minnie"]
    var gameServiceImpl = GameServiceImpl()
    @StateObject var viewModel: WaitingRoomViewModel
    @State var tabBarController: UITabBarController?
    @State var showAlert: Bool = false
    @State var isPrivate: Bool = true
    @State var privateButtonColor: Color = Color.primaryColor
    @State var toggleScale: Bool = false
    @State var isActive: Bool = false
    @State var buttonIsDisabled: Bool = true
    @EnvironmentObject var sessionService: SessionServiceImpl
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var showCountdown: Bool = false
    @State var scale = 1.0
    
    init(viewModel: WaitingRoomViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        
        print(isActive)
    }
    
    var body: some View {
        ZStack {
            if viewModel.game == nil {
                Text("Waiting for Players...")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }else if showCountdown {
                CountdownScreen()
            }else {
                Spacer()
                VStack {
                    Spacer()
                    Text("Waiting for Players...")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    Spacer()
                    HStack {
                        if sessionService.userDetails?.id == viewModel.game?.host ?? "" {
                        ButtonView(title: "Private", background: privateButtonColor) {
                            isPrivate.toggle()
                            if isPrivate == true {
                                privateButtonColor = Color.primaryColor
                                hapticFeedbackResponse(style: .light)
                            } else {
                                privateButtonColor = Color.gray
                                hapticFeedbackResponse(style: .light)
                            }
                            viewModel.makeGamePrivate()
                        }
                        .animation(.spring(response: 0.9, dampingFraction: 0.8), value: 0.6)
                        .frame(width: 100, height: 50)
                        }
                        Spacer()
                        Text(viewModel.game?.code ?? "No Code Available")
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                        .foregroundColor(Color.primaryColor)
                        Spacer()
                        if sessionService.userDetails?.id == viewModel.game?.host {
                            ButtonView(title: "Start", background: Color.primaryColor) {
                                hapticFeedbackResponse(style: .light)
                                viewModel.startGame()
                                //isActive = true
                            }.disabled(buttonIsDisabled)
                            .frame(width: 100, height: 50)
                        }
                    }
                    .padding()
                }
            ForEach((viewModel.game?.players.indices)!, id: \.self) { index in
                let player = viewModel.game?.players[index]
                
         
                    ProfilePicView(profilePic: player?["profilePic"], size: 100, cornerRadius: 50)
                
                    
                    .animation (Animation.interpolatingSpring(stiffness: 40, damping: 10, initialVelocity: 5)
                            .repeatForever()
                            .speed(.random(in: 0.08...0.3))
                                    
                            .delay(.random (in: 0...0.4)), value: self.scale
                        )
                    
                    
                        .frame(width: .random(in: 1...100),
                               height: CGFloat.random (in:20...100),
                               alignment: .center)
                    
                        .position(CGPoint(x: .random(in: 40...325),
                                          y: .random(in: 15...400)))
                        
                }
                
                }
            NavigationLink(destination: NavigationLazyView(TriviaView(viewModel: TriviaViewModel(game: viewModel.game!, currentQuestion: viewModel.currentQuestion, answers: viewModel.answers, songIds: viewModel.songIds, sessionService: sessionService))), isActive: $isActive){
            EmptyView()
        }.isDetailLink(false)
        }.introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            tabBarController = UITabBarController
        }
        .alert("Oops no game available", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        self.presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onChange(of: viewModel.game) { _ in
            print("the view has changed")
            if (viewModel.game?.players.count) ?? 0 > 1 {
                buttonIsDisabled = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                toggleScale.toggle()
                if toggleScale {
                    self.scale = 1.3
                } else {
                    self.scale = 1.2
                }
            }
            if viewModel.game?.hasStarted == true {
                print("this game is starting \(viewModel.gameNotification)")
                viewModel.getSong(with: 0)
                showCountdown = true
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    isActive = true
                }
            }
        }

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            viewModel.removePlayer()
            self.presentationMode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrow.left")
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                if viewModel.game == nil {
                    showAlert = true
                } else {
                    self.scale = 1.12
                }
            }
        }
        .onDisappear {
            viewModel.gameNotification = GameNotification.hasntStarted
        }

    }
    func hapticFeedbackResponse(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactMed = UIImpactFeedbackGenerator(style: style)
        impactMed.impactOccurred()
    }
}

//struct WaitingRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingRoomView()
//    }
//}
