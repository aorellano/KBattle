//
//  HomeView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State var isActive: Bool = false
    @State var gameType: GameType? = nil
  
    
    var body: some View {

        NavigationView {
            
            VStack {
                HStack {
                    Spacer()
                    ProfilePicView(profilePic: sessionService.userDetails?.profilePic, size: 50, cornerRadius: 25)
                }
                HStack {
                    WelcomeHeader()
                        .environmentObject(sessionService)
                    Spacer()
                }
                Spacer()
                HomeLogo()
                Spacer()
                HStack {
                    InputTextFieldView(text: .constant(""), placeholder: "Join Game: Enter Code", keyboardType: .default, sfSymbol: nil)
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.primaryColor)
                        .onTapGesture {
                            gameType = .JoinGame(with: "code")
                            isActive = true
                        }
                }

                ButtonView(title: "Random Game", background: Color.primaryColor) {
                    gameType = .JoinRandomGame
                    isActive = true
                }
               
          
                ButtonView(title: "Create Game", background: Color.primaryColor) {
                    gameType = .NewGame
                    isActive = true
                }
                if gameType != nil {
                NavigationLink(destination: NavigationLazyView(WaitingRoomView(viewModel: WaitingRoomViewModel(with: gameType ?? .JoinRandomGame))), isActive: $isActive){
                    EmptyView()
                }.isDetailLink(false)
            }
            }.onAppear { print("Hi") }
            .padding()
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .navigationBarHidden(true)
        }
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

enum GameType {
    case NewGame
    case JoinGame(with: String)
    case JoinRandomGame
}
