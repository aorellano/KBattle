//
//  RankingView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/22/22.
//

import SwiftUI

struct RankingView: View {
    var sessionService: SessionService
    
    init(sessionService: SessionService) {
        self.sessionService = sessionService
    }
    var body: some View {
        VStack {
            ProfilePicView(profilePic: sessionService.userDetails?.profilePic, size: 140, cornerRadius: 70)
            Text(sessionService.userDetails?.username ?? "")
                .font(.system(size: 16))
                .fontWeight(.regular)
            HStack {
                    Image("Coin")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text("3452")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                Spacer()
                }
            HStack {
                    Image("Heart")
                        .resizable()
                        .frame(width: 40, height: 35)
                        .padding(.leading, 6)
                    Text("3")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    
                Spacer()
                }
            Spacer()
            
        }
        .padding()
        .navigationTitle(Text("Rankings"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        
    }
}
