//
//  K_BattleApp.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/29/22.
//

import SwiftUI
import Firebase

@main
struct K_BattleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var sessionService = SessionServiceImpl()
    
    var body: some Scene {
        WindowGroup {
            switch sessionService.state {
                case .loggedIn:
                TabView {
                    HomeView()
                        .environmentObject(sessionService)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    SettingsView()
                        .environmentObject(sessionService)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                        
                }
                case .loggedOut:
                    LoginView()
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                        UIApplication.shared.applicationIconBadgeNumber = 0
                        DataTimer.shared.check()
                        if Date().timeIntervalSince(DataTimer.shared.endDate) < 0 {
                            print("end date ahead")
                        } else {
                            print("add lives to player")
                        }
                    }
            }
                
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
 
//    func applicationWillTerminate(_ application: UIApplication) {
//        print("Terminating")
//        //remove player from the game
//
////        guard let game = GameServiceImpl.shared.game else { return }
////        guard let user = Auth.auth().currentUser?.uid else { return }
////
////        GameServiceImpl.shared.removePlayer(with: user, for: game.id)
////        GameServiceImpl.shared.updateGame(GameServiceImpl.shared.game)
////        print("Game Id: \(game)")
////        print("User: \(user)")
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        print("entering foreground")
//    }
//
//
//
//    func applicationWillResignActive(_ application: UIApplication) {
//        print("will resign active")
//    }
//
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        print("entered background")
//    }
//
    
    
}
