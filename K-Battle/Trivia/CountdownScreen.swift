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
    let systemSoundID: SystemSoundID = 1113
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Circle()
                    .frame(width: 275, height: 275)
                    .foregroundColor(Color.primaryColor)
                Text("\(timeRemaining)")
                    .font(.system(size: 125))
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .onReceive(timer) { _ in
                        
                        if timeRemaining > 0 {
                            AudioServicesPlaySystemSoundWithCompletion(systemSoundID) {
                                timeRemaining -= 1
                            }
                        }
                    }
            }
            Spacer()
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
