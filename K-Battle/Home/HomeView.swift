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
                }
             
                NavigationLink(destination: NavigationLazyView(WaitingRoomView()), isActive: $isActive){
                    ButtonView(title: "Random Game", background: Color.primaryColor) {
                        isActive = true
                    }
                }.isDetailLink(false)
                ButtonView(title: "Create Game", background: Color.primaryColor) { print("creating game") }
            }
            .padding()
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .navigationBarHidden(true)
        }
        .environment(\.rootPresentationMode, self.$isActive)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
