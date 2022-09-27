//
//  SettingsView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/3/22.
//

import SwiftUI
import StoreKit
import MessageUI

struct SettingsView: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            VStack {
                ProfilePicView(profilePic: sessionService.userDetails?.profilePic, size: 100, cornerRadius: 50)
                
                    
                    Text(sessionService.userDetails?.username ?? "")
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                HStack {
                 
                    Image("Heart")
                        .resizable()
                        .frame(width: 28, height: 23)
                       
                    Text("x")
                    .font(.system(size: 18))
                    .fontWeight(.bold)
                    Text("\(Int(sessionService.userDetails?.lives ?? 0))")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                    Spacer()
                    Image("Coin")
                        .resizable()
                        .frame(width: 26, height: 26)
                    Text("\(Int(sessionService.userDetails?.totalScore ?? 0) )")
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                }
                .padding()

                    List {
//                       // first section
//                       Section(header: Text("Account")) {
//                           NavigationLink(destination: RankingView(sessionService: sessionService), label: {
//                              Text("Ranking")
//                           })
//                       }

    
                       Section(header: Text("Add Ons")) {
                           NavigationLink(destination: NavigationLazyView(StoreView()), label: {
                               Text("Store")
                            })

                       }
                        
                        Section(header: Text("Developer")) {
                            NavigationLink(destination: NavigationLazyView(AboutMeView()), label: {
                                Text("About Me")
                             })
                            
//                            NavigationLink(destination: NavigationLazyView(ReviewView()), label: {
//                                Text("Leave a Review")
//                            })
//                            NavigationLink(destination: NavigationLazyView(FeedbackView()), label: {
//                                Text("Give Suggestions")
//                            })
                            
                            Button("Give Suggestions") {
                                self.isShowingMailView.toggle()
                            }
                            
                            Button("Leave a Review") {
                            
                                if let scene = UIApplication.shared.connectedScenes.first(where: {$0.activationState == .foregroundActive}) as? UIWindowScene {
                                    SKStoreReviewController.requestReview(in: scene)
                                }
                                
                            }
                            .disabled(!MFMailComposeViewController.canSendMail())
                            .sheet(isPresented: $isShowingMailView) {
                                MailView(result: self.$result)
                            }
                        }
                        
                        Section(header: Text("Log Out")) {
                            Button("Sign Out") {
                                sessionService.logout()
                            }

                        }

                    }
                 
                    .navigationTitle(Text("Profile"))
                }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(Color(uiColor: UIColor.secondarySystemBackground))
            .background(Color.primaryColor)
            }
    }
}

