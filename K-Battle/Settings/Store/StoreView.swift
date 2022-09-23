//
//  StoreView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 9/21/22.
//

import SwiftUI

struct StoreView: View {
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    private let characters = ["Panda", "Grizz", "Dino"]
    private let lightSticks = ["Question Bomb", "Army Bomb"]
    private let backgroundColor = Color.primaryColor
    private let highligtedColor = Color.primaryColor
    @State private var type = 0
    var body: some View {
        ZStack {
            VStack {
                Picker("Choice a type", selection: $type) {
                    Text("Characters").tag(0)
                    Text("Light Sticks").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                if type == 0 {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(characters, id: \.self) { item in
                                VStack {
                                    ZStack {
                                        if item == "Panda" {
                                            RoundedRectangle(cornerRadius: 20)
                                                .frame(height:150)
                                                .foregroundColor(backgroundColor)
                                              
                                        } else {
                                            RoundedRectangle(cornerRadius: 20)
                                                .frame(height:150)
                                                .foregroundColor(backgroundColor)
                                        }
                                        Image(item)
                                            .resizable()
                                            .frame(width: 75, height: 110)
                                    }
                                    HStack {
                                        Text(item)
                                            .fontWeight(.regular)
                                            .font(.system(size: 12))
                                       Spacer()
                                        Image("Coin")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                        Text("100,000")
                                            .fontWeight(.bold)
                                            .font(.system(size: 12))
                                        
                                    }
                                }
                            }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(lightSticks, id: \.self) { item in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20)
                                            .frame(height:150)
                                            .foregroundColor(backgroundColor)
                                          
                                        Image(item)
                                            .resizable()
                                            .frame(width: 90, height: 100)
                                            .padding(.trailing, 10)
                                    }
                                    HStack {
                                        Text(item)
                                            .fontWeight(.regular)
                                            .font(.system(size: 12))
                                       Spacer()
                                        Image("Coin")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                        Text("100,000")
                                            .fontWeight(.bold)
                                            .font(.system(size: 12))
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .navigationTitle(Text("Store"))
        .background(Color(uiColor: UIColor.secondarySystemBackground))
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
