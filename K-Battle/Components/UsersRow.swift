//
//  UsersRow.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/8/22.
//

import SwiftUI

struct UsersRow: View {
    @StateObject var viewModel: TriviaViewModel
    @State var players = [[String:String]]()
    
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        players = viewModel.game!.players
    }
    
    var body: some View {
        HStack {
            ForEach(players.indices, id: \.self) { index in
                let player = players[index]
                ProfilePicView(profilePic: player["profilePic"], size: 34, cornerRadius: 16)
            }
        }
        .onChange(of: viewModel.game!.players) { game in
            players = (viewModel.game?.players.sorted(by: {Int($0["score"]!)! > Int($1["score"]!)!}))!
            print("\(viewModel.game?.players)")
        }
        .onAppear {
            players = (viewModel.game?.players.sorted(by: {Int($0["score"]!)! > Int($1["score"]!)!}))!
        }
    }
}


