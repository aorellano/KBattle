//
//  RegisterView.swift
//  K-Battle
//
//  Created by Alexis Orellano on 8/30/22.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var vm = RegistrationViewModelImpl(
        service: RegistrationServiceImpl()
    )
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    @State var showAlert = false
    @State var showingAlert2 = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Button {
                        shouldShowImagePicker.toggle()
                    } label: {
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 125, height: 125)
                                    .cornerRadius(75)
                                    .overlay(RoundedRectangle(cornerRadius: 75)
                                                .stroke(Color.gray, lineWidth: 1.5))
                            } else {
                                Image(systemName: "person.crop.circle.badge.plus")
                                    .font(.system(size: 125, weight: .light))
                                    .padding(.top, 25)
                                    .padding(.bottom, 20)
                                    .foregroundColor(Color.primaryColor)
                            }
                        }
                    }
                    VStack(spacing: 16) {
                        InputTextFieldView(text: $vm.userDetails.username,
                                       placeholder: "Username",
                                       keyboardType: .namePhonePad,
                                       sfSymbol: "person")
                        InputTextFieldView(text: $vm.userDetails.email,
                                       placeholder: "Email",
                                       keyboardType: .emailAddress,
                                       sfSymbol: "envelope")
                        InputPasswordView(password: $vm.userDetails.password,
                                       placeholder: "Password",
                                       sfSymbol: "lock")
                    
                    }
                    ButtonView(title: "Sign Up", background: Color.primaryColor) {
                        Task {
                            await vm.register()
                        }

                    }
                    Spacer()
                        .alert(vm.error?.errorDescription ?? "Damn", isPresented: $vm.hasError) {
                                Button("OK", role: .cancel) { }
                    }
                }
                .padding(.horizontal, 15)
                
            }
            .navigationTitle("Register")
            .applyClose()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.secondarySystemBackground))
            //.foregroundColor(Color.textColor)
        }.fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea(.keyboard)
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

