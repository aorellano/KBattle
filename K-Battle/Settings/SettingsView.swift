//
//  SettingsView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/3/22.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    var body: some View {
        NavigationView {
            VStack {
                ProfilePicView(profilePic: sessionService.userDetails?.profilePic, size: 100, cornerRadius: 50)

                    Text(sessionService.userDetails?.username ?? "")
                        .fontWeight(.bold)
                        .padding(.bottom, 20)

                    List {
                       // first section
                       Section(header: Text("Account")) {
                        NavigationLink(destination: EmptyView(), label: {
                              Text("Leaderboard")
                           })
                       }

    
                       Section(header: Text("Question Factory")) {
                           NavigationLink(destination: NavigationLazyView(EmptyView()), label: {
                               Text("Submit Questions")
                            })

                           NavigationLink(destination: EmptyView(), label: {
                                Text("Review Questions")
                            })

                       }


                       
                    }
                    .cornerRadius(20)
                    .padding()
                    


                    ButtonView(title: "Sign Out", background: Color.primaryColor) {
                            sessionService.logout()
                    }
                    .padding([.top, .bottom], 20)
                    .padding()
                    .navigationTitle(Text("Profile"))
                }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: UIColor.secondarySystemBackground))
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
