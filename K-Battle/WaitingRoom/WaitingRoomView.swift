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
    @EnvironmentObject var sessionService: SessionServiceImpl
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State var scale = 1.0
    
    init(viewModel: WaitingRoomViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if viewModel.game == nil {
                Text("Waiting for Players...")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            } else {
   
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
                            } else {
                                privateButtonColor = Color.gray
                            }
                            viewModel.makeGamePrivate()
                        }
                        .frame(width: 100, height: 50)
                        }
                        Spacer()
                        Text(viewModel.game?.code ?? "No Code Available")
                        .fontWeight(.bold)
                        .foregroundColor(Color.primaryColor)
                        Spacer()
                        if sessionService.userDetails?.id == viewModel.game?.host ?? "" {
                            
                        ButtonView(title: "Start", background: Color.primaryColor) {
                            print("Starting game")
                            viewModel.startGame()
                                isActive = true
                        
                                
                        
                            }
                        .frame(width: 100, height: 50)
                            
                        }
                    }
                    .padding()
                }
            ForEach((viewModel.game?.players.indices)!, id: \.self) { index in
                let player = viewModel.game?.players[index]
                
                VStack {
                ProfilePicView(profilePic: player?["profilePic"], size: 100, cornerRadius: 50)
                Text(player?["username"] ?? "No Name")
                        .font(.system(size: 10))
                        .multilineTextAlignment(.center)
                }
                    .animation (Animation.spring(dampingFraction: 0.6)
                                    .repeatForever()
                                    .speed (.random(in: 0.05...0.4))

                                    .delay(.random (in: 0...0.8)), value: self.scale
                    )
                    
                
                    .frame(width: .random(in: 1...100),
                           height: CGFloat.random (in:20...100),
                           alignment: .center)
                    
                    .position(CGPoint(x: .random(in: 40...325),
                                      y: .random(in: 15...400)))
                
                }
                }
        NavigationLink(destination: NavigationLazyView(TriviaView()), isActive: $isActive){
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                toggleScale.toggle()
                if toggleScale {
                    self.scale = 1.3
                } else {
                    self.scale = 1.2
                }
            }
            
            if viewModel.gameNotification == GameNotification.gameStarted {
                isActive = true
                print("the game has started")
            }
            
            print(viewModel.game?.players)
        }
      
        .onDisappear {
            print("User is leaving")
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
       
            print(showAlert)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
                if viewModel.game == nil {
                    showAlert = true
                } else {
                    self.scale = 1.2
                }
                
            }
        }
        
    }
        
}

//struct WaitingRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingRoomView()
//    }
//}
