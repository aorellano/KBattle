//
//  HomeView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    
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
                ButtonView(title: "Join Game", background: Color.primaryColor) { print("joining game") }
                ButtonView(title: "Create Game", background: Color.primaryColor) { print("creating game") }
            }
            .padding()
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
