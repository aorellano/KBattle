//
//  CountdownScreen.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/9/22.
//

import SwiftUI
import AVFoundation

struct CountdownScreen: View {
    @State var timeRemaining = 3
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var scale = 1.0
    let systemSoundID: SystemSoundID = 1113
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("\(timeRemaining)")
                .font(.system(size: 150))
                .fontWeight(.black)
                .foregroundColor(Color.primaryColor)
                .onReceive(timer) { _ in
                    
                    if timeRemaining > 0 {
                        AudioServicesPlaySystemSoundWithCompletion(systemSoundID) {
                            print("hi")
                            timeRemaining -= 1
                            self.scale = 2
                        }
                        //AudioServicesPlayAlertSound(systemSoundID)
                        //timeRemaining -= 1
                        
                    }
                    
                }
                .scaleEffect(self.scale)
                .animation(Animation.easeInOut(duration: 0.55).repeatForever(autoreverses: true), value: self.scale)
            Spacer()
        }
        .onAppear {
            self.scale = 2
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
    }
}

struct CountdownScreen_Previews: PreviewProvider {
    static var previews: some View {
        CountdownScreen()
    }
}
