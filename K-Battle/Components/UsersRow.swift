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
                ProfilePicView(profilePic: player["profilePic"], size: 30, cornerRadius: 15)
            }
        }.onChange(of: viewModel.game!) { game in
            players = (viewModel.game?.players.sorted(by: {$0["score"]! > $1["score"]!}))!
        }
        .onAppear {
            players = (viewModel.game?.players.sorted(by: {$0["score"]! > $1["score"]!}))!
        }
    }
}


