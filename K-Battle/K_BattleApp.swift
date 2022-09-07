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
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("Terminating")
        //when a user is terminating the app they should be kicked from the game
    }
    
    
}
