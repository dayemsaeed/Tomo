//
//  LoginView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 12/15/20.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEditing = false
    @State private var showPassword = false
    @ObservedObject var userLoggedIn: LoginViewModel
    @ObservedObject var registerViewModel: RegisterViewModel
    
    private var canLogIn: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        
        return VStack(content: {
            Spacer()
                .frame(height: 150)
            
            Text("TOMO").foregroundColor(Color.petSupportText)
                .font(Font.custom("Permanent Marker", size: 36))
                .padding()

            Group {
                
                HStack {
                    
                    Text("EMAIL")
                        .font(Font.custom("Permanent Marker", size: 18))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                }
                
                TextField("Email", text: $email) {
                    isEditing in self.isEditing = isEditing
                }
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                    .foregroundColor(.black)
                
            }

            
            Group {
                
                HStack {
                    
                    Text("PASSWORD")
                        .font(Font.custom("Permanent Marker", size: 18))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                }

                ZStack {
                    if showPassword {
                        TextField("Password", text: $password)
                    }
                    else {
                        SecureField("Password", text: $password)
                    }
                }
                .frame(height: 20)
                .autocapitalization(.none)
                .overlay(Image(systemName: showPassword ? "eye.slash" : "eye")
                    .onTapGesture { showPassword.toggle() }, alignment: .trailing)
                .disableAutocorrection(true)
                .padding(.top, 20)
                
                Divider()
                    .foregroundColor(.black)
                
            }
            
            Spacer();
            
            VStack {
                
                Button(action: {
                        userLoggedIn.login(email: email, password: password)
                }, label: {
                    Text("Login")
                })
                    .foregroundColor(.white)
                    .font(Font.custom("Permanent Marker", size: 18.0))
                    .padding(.horizontal, 20)
                    .padding()
                    .background(Color.petSupportBlue)
                    .cornerRadius(70.0)
                    .disabled(!canLogIn)
                
                NavigationLink(destination: RegisterView(registerView: registerViewModel, loginViewModel: userLoggedIn)) {
                    Button(action: {}, label: {
                        Text("Register")
                            .padding()
                            .font(Font.custom("Permanent Marker", size: 18.0))
                            .foregroundColor(Color.petSupportText)
                    })
                }
                .navigationBarBackButtonHidden(true)
            }
            
            Spacer()
            
        })
        .padding(.horizontal, 30)
        
    }
}
