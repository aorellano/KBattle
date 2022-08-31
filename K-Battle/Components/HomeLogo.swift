//
//  HomeLogo.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/31/22.
//

import SwiftUI

struct HomeLogo: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 225, height: 225)
                .foregroundColor(Color.primaryColor)
            Image(uiImage: UIImage(named: "BattleIcon")!)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .padding(.leading, 25)
        }
    }
}

struct HomeLogo_Previews: PreviewProvider {
    static var previews: some View {
        HomeLogo()
    }
}
