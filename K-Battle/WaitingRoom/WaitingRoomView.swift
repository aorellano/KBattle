//
//  WaitingRoomView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import SwiftUI
import Firebase
import Introspect

struct WaitingRoomView: View {
    var users = ["mina", "jihyo", "jin", "minnie"]
    var gameServiceImpl = GameServiceImpl()
    @StateObject var viewModel: WaitingRoomViewModel
    @State var tabBarController: UITabBarController?
    @State var showAlert: Bool = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @State var scale = 1.0
    
    init(viewModel: WaitingRoomViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if viewModel.game == nil {
                Text("Waiting for Players...")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            } else {
                
                VStack {
                    
            ForEach((viewModel.game?.players.indices)!, id: \.self) { index in
                let player = viewModel.game?.players[index]
                
                ProfilePicView(profilePic: player?["profilePic"], size: 100, cornerRadius: 50)
                    
                    .animation (Animation.spring(dampingFraction: 0.6)
                                    .repeatForever()
                                    .speed (.random(in: 0.05...0.4))

                                    .delay(.random (in: 0...0.8)), value: self.scale
                    )
                    
                
                    .frame(width: .random(in: 1...100),
                           height: CGFloat.random (in:20...100),
                           alignment: .center)
                    
                    .position(CGPoint(x: .random(in: 40...325),
                                      y: .random(in: 15...700)))
                
            
                    
            }
                    Text("Waiting for Players...")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                    Spacer()
                        Text(viewModel.game?.code ?? "No Code Available")
                        .fontWeight(.bold)
                        .foregroundColor(Color.primaryColor)
                        
                }
                
            }
                
                
        }
        .alert("Oops no game available", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
        }

    
        .introspectTabBarController { (UITabBarController) in
            UITabBarController.tabBar.isHidden = true
            tabBarController = UITabBarController
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .onAppear {
            if viewModel.game == nil {
                showAlert = true
            }
            print(showAlert)
            print(viewModel.game)
            DispatchQueue.main.async {
                self.scale = 1.2
            }
        }
        
        
    }
        
}

//struct WaitingRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingRoomView()
//    }
//}
