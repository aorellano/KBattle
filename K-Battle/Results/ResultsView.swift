//
//  ResultsView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/10/22.
//

import SwiftUI
import Introspect

struct ResultsView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    @StateObject var viewModel: TriviaViewModel
    @State var players = [[String:String]]()
    @State var lastPlayers = [[String:String]]()
    @State var rankings = 1
    init(viewModel: TriviaViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        players = viewModel.game!.players
    }
    var body: some View {
        VStack {
            HStack {
                VStack {
                    if players.count > 1 {
                        ProfilePicView(profilePic: players[1]["profilePic"], size: 80, cornerRadius: 40)
                        Text(players[1]["username"] ?? "")
                            .font(.system(size: 12))
                        Text("Second Place")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color.primaryColor)
                        HStack {
                            Image("Coin")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(players[1]["score"] ?? "0")
                                .fontWeight(.bold)
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding()
                VStack {
                    if players.first != nil {
                        ProfilePicView(profilePic: players[0]["profilePic"], size: 120, cornerRadius: 60)
                        Text(players[0]["username"] ?? "")
                            .font(.system(size: 12))
                        Text("First Place")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color.primaryColor)
                        HStack {
                            Image("Coin")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(players[0]["score"] ?? "0")
                                .fontWeight(.bold)
                                .font(.system(size: 16))
                        }
                        
                    }
                }
                .padding(.top, -120)
                if players.count > 2 {
                    VStack {
                        ProfilePicView(profilePic: players[2]["profilePic"], size: 80, cornerRadius: 40)
                        Text(players[2]["username"] ?? "")
                            .font(.system(size: 12))
                        Text("Third Place")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color.primaryColor)
                        HStack {
                            Image("Coin")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(players[2]["score"] ?? "0")
                                .fontWeight(.bold)
                                .font(.system(size: 16))
                        }
                    }
                    .padding()
                } else {
                    VStack {
                        ProfilePicView(profilePic: "", size: 80, cornerRadius: 40)
                        Text("")
                            .font(.system(size: 12))
                        Text("Third Place")
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundColor(Color.primaryColor)
                        HStack {
                            Image("Coin")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("")
                                .fontWeight(.bold)
                                .font(.system(size: 12))
                        }
                    }
                    .padding()
                }
            }
            .padding(.top, 120)
            
           if players.count > 3 {
                Spacer()
                ForEach(lastPlayers.indices, id: \.self) { index in
                    HStack {
                        Text("\(index+4)th")
                            .foregroundColor(Color.primaryColor)
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding()
                        ProfilePicView(profilePic: lastPlayers[index]["profilePic"], size: 64, cornerRadius: 32)
                            .padding([.leading], 6)
                        Text(lastPlayers[index]["username"] ?? "")
                            .font(.system(size: 12))
                        Spacer()
                        Image("Coin")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(lastPlayers[index]["score"] ?? "")
                            .fontWeight(.bold)
                            .font(.system(size: 16))
                            .padding(.trailing, 6)
                        
                        
                        }
                    .foregroundColor(.black)
                    .frame(height: 80)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 5, x: 2, y: 2)
                    .padding()
                       
                    }
                        
                }
                    //rankings += 1
                
                
            
            Spacer()
            
            ButtonView(title: "Done", background: Color.primaryColor) {
                self.rootPresentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        
        .onAppear {
            players = (viewModel.game?.players.sorted(by: {Int($0["score"]!)! > Int($1["score"]!)!}))!
            if players.count > 3 {
                let lastPlayersCount = 6 - players.count
                lastPlayers = players.suffix(3 - lastPlayersCount)
            }
            
                
        }
        .navigationTitle(Text("Leaderboard"))
        .navigationBarBackButtonHidden(true)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
    }
}


