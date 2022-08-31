//
//  ButtonView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import SwiftUI

struct ButtonView: View {
    typealias ActionHandler = () -> Void
    
    let title: String
    let background: Color
    let foreground: Color
    let border: Color
    let handler: ActionHandler
    private let cornerRadius: CGFloat = 10
    
    internal init(title: String,
                  background: Color = .blue,
                  foreground: Color = .white,
                  border: Color  = .clear,
                  handler: @escaping ButtonView.ActionHandler) {
        self.title = title
        self.background = background
        self.foreground = foreground
        self.border = border
        self.handler = handler
    }
    
    var body: some View {
        Button(action: handler, label: {
            Text(title)
                //.frame(maxWidth: .infinity, maxHeight: 50)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
        })
        .background(background)
        .foregroundColor(foreground)
        .font(.system(size: 16, weight: .bold))
        .cornerRadius(cornerRadius)
        .shadow(radius: 5, x: 2, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border, lineWidth: 2)
        )
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "Primary") {}
    }
}
