//
//  WelcomeHeader.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import SwiftUI

struct WelcomeHeader: View {
    @EnvironmentObject var sessionService: SessionServiceImpl
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hey \(sessionService.userDetails?.username ?? ""),")
                .font(.system(size: 20))
            Text("Ready to Play!")
                .font(.system(size: 26))
                .fontWeight(.bold)
        }
        .padding(.top, -10)
        .padding(.bottom, 10)
    }
}

struct WelcomeHeader_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeHeader()
    }
}
