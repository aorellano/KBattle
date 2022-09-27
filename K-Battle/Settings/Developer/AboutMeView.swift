//
//  AboutMeView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/22/22.
//

import SwiftUI

struct AboutMeView: View {
    var biases = ["LisaCat", "JinRj", "MinaPenguin", "KaiPumpkin","MinnieHat" ,"INCat", "YunjinFrog"]
   
    var body: some View {
        VStack {
            Image("Minnie2")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                
                Text("Hi my name is Alexis. I made this app for my fellow kpop fans to have some fun.")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    //.fontWeight(.medium)
                
                Text("I spent the last few months working on this app on my own so please support by playing giving feedback and suggestions.")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    //.fontWeight(.medium)
                Text("Enjoy!")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .fontWeight(.medium)
                
                Spacer()
                Text("My Biases:")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(biases, id: \.self) { bias in
                            
                            ZStack {
                                Image(bias)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 88, height: 88)
                                    .clipShape(Circle())
                                
                            }
                        }
                        
                        
                        
                    }
                }
                Text("Follow for Updates!")
                HStack {
                    Spacer()
                    Link(destination: URL(string: "https://www.instagram.com/AlexisCodes/")!) // <- Add your link here
                           {
                               Image("instagram") // <- Change icon to your preferred one
                                   .resizable()
                                   .frame(width: 40, height: 40)
                           }
                    Link(destination: URL(string: "https://www.twitter.com/AlexisCodes/")!) // <- Add your link here
                           {
                               Image("twitter") // <- Change icon to your preferred one
                                   .resizable()
                                   .frame(width: 40, height: 40)
                           }
                    
                    Spacer()
                }
            }
            .padding(.top, -100)

            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .navigationTitle(Text("About Developer"))
    }
}

struct AboutMeView_Previews: PreviewProvider {
    static var previews: some View {
        AboutMeView()
    }
}
