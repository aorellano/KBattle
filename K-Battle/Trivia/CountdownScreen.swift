//
//  CountdownScreen.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/9/22.
//

import SwiftUI

struct CountdownScreen: View {
    @State var timeRemaining = 10
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Text("\(timeRemaining)")
            .onReceive(timer) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
    }
}

struct CountdownScreen_Previews: PreviewProvider {
    static var previews: some View {
        CountdownScreen()
    }
}
