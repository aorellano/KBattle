//
//  UsersRow.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/8/22.
//

import SwiftUI

struct UsersRow: View {
    var players: [[String:String]]
    
    init(players: [[String:String]]) {
        self.players = players
    }
    var body: some View {
        HStack {
            ForEach(players.indices, id: \.self) { index in
                let player = players[index]
                ProfilePicView(profilePic: player["profilePic"], size: 30, cornerRadius: 15)
            }
        }
    }
}


