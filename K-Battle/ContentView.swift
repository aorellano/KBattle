//
//  ContentView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/29/22.
//

import SwiftUI

struct ContentView: View {
    var users = ["mina", "jihyo", "jin", "minnie"]
    @State var scale = 1.0
    var body: some View {
        ZStack {
            Text("Waiting for Players...")
                .font(.system(size: 20))
                .foregroundColor(.gray)
            ForEach(users, id: \.self) { bubble in
                ProfilePicView(profilePic: bubble)
                    .foregroundColor(.blue)
                  
                    
                    .animation (Animation.spring(dampingFraction: 0.6)
                                    .repeatForever()
                                    .speed (.random(in: 0.05...0.4))

                                    .delay(.random (in: 0...0.8)), value: self.scale
                    )
                
                    .frame(width: 100,
                           height: 100,
                           alignment: .center)
                    
                    .position(CGPoint(x: .random(in: 40...350),
                                      y: .random(in: 15...750)))
            }
            
        }
        .onAppear {
                    self.scale = 1.2 // default circle scale
                }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
