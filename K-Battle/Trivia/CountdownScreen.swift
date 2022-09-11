//
//  CountdownScreen.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/9/22.
//

import SwiftUI

struct CountdownScreen: View {
    @State var timeRemaining = 3
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var scale = 1.0
    var body: some View {
        
        VStack {
            Spacer()
            Text("\(timeRemaining)")
                .font(.system(size: 150))
                .fontWeight(.bold)
                .foregroundColor(Color.primaryColor)
                .onReceive(timer) { _ in
                    
                    if timeRemaining > 0 {
                        self.scale = 2
                        timeRemaining -= 1
                        
                    }
                }
                .scaleEffect(self.scale)
                .animation(Animation.easeInOut(duration: 0.55).repeatForever(autoreverses: true), value: self.scale)
            Spacer()
        }
        .onAppear {
            self.scale = 2
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
