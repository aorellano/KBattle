//
//  ResultsView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/10/22.
//

import SwiftUI

struct ResultsView: View {
    var body: some View {
        VStack {
            Text("The Results are in...")
            ButtonView(title: "Done") {
                print("the game has ended")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
