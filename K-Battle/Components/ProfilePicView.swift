//
//  ProfilePicView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfilePicView: View {
    let profilePic: String?
    let size: CGFloat
    let cornerRadius: CGFloat
    
    var body: some View {
        if let pic = profilePic {
            WebImage(url: URL(string: pic))
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(cornerRadius)
                .overlay(RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.gray, lineWidth: 0.1))
        } else {
            Image(systemName: "person.fill")
                .font(.system(size: size, weight: .light))
                .foregroundColor(.white)
        }
//        if profilePic == "minnie" {
//            Image("minnie")
////                .font(.system(size: size, weight: .light))
//            .resizable()
//            .scaledToFill()
//            .frame(width: 100, height: 100)
//            .cornerRadius(100)
//            .shadow(color: .gray, radius: 0.5, x: 0.25, y: 0.25)
//
//        } else if profilePic == "jin" {
//            Image("jin")
////                .font(.system(size: size, weight: .light))
//            .resizable()
//            .scaledToFill()
//            .frame(width: 100, height: 100)
//            .cornerRadius(100)
//
//            .shadow(color: .gray, radius: 0.5, x: 0.75, y: 0.75)
//        } else if profilePic == "mina" {
//            Image("mina")
////                .font(.system(size: size, weight: .light))
//            .resizable()
//            .scaledToFill()
//            .frame(width: 100, height: 100)
//            .cornerRadius(100)
//            .shadow(color: .gray, radius: 0.5, x: 0.75, y: 0.75)
//        } else {
//            Image("jihyo")
////                .font(.system(size: size, weight: .light))
//            .resizable()
//            .scaledToFill()
//            .frame(width: 100, height: 100)
//            .cornerRadius(100)
//            .shadow(color: .gray, radius: 0.5, x: 0.75, y: 0.75)
//        }
    }
}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(profilePic: "jihyo", size: 100, cornerRadius: 50)
    }
}
