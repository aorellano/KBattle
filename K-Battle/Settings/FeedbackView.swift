//
//  FeedbackView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/22/22.
//

import SwiftUI

struct FeedbackView: View {
    var body: some View {
        VStack {
            Text("Under Construction 👷‍♀️")
        }
        .navigationTitle(Text("Leave Feedback"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
    }
}

struct FeedbackView_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackView()
    }
}
