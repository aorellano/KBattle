//
//  WaitingRoomView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import SwiftUI
import Firebase

struct WaitingRoomView: View {
    var users = ["mina", "jihyo", "jin", "minnie"]
    var gameServiceImpl = GameServiceImpl()
    @StateObject var viewModel: WaitingRoomViewModel
    
    @State var scale = 1.0
    
    init(viewModel: WaitingRoomViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Text("Waiting for Players...")
                .font(.system(size: 20))
                .foregroundColor(.gray)
//            ForEach(users, id: \.self) { bubble in
//                ProfilePicView(profilePic: bubble, size: 100, cornerRadius: 50)
//                    .foregroundColor(.blue)
//                  
//                    
//                    .animation (Animation.spring(dampingFraction: 0.6)
//                                    .repeatForever()
//                                    .speed (.random(in: 0.05...0.4))
//
//                                    .delay(.random (in: 0...0.8)), value: self.scale
//                    )
//                
//                    .frame(width: 100,
//                           height: 100,
//                           alignment: .center)
//                    
//                    .position(CGPoint(x: .random(in: 40...350),
//                                      y: .random(in: 15...750)))
//            }
            
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .onAppear {
                    self.scale = 1.2 // default circle scale
                    
                    
        }
    }
}

//struct WaitingRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingRoomView()
//    }
//}
