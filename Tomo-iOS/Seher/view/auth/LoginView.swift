//
//  LoginView.swift
//  Seher
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
    @State private var loginError: String?
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var registerViewModel: RegisterViewModel
    
    private var canLogIn: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        
        VStack {
            Spacer()
                .frame(height: 150)
            
            Text("TOMO")
                .foregroundColor(Color.seherText)
                .font(.system(size: 36))
                .padding()

            Group {
                
                HStack {
                    
                    Text("EMAIL")
                        .font(.system(size: 18))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                }
                
                TextField("Email", text: $email) { isEditing in
                    self.isEditing = isEditing
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
                        .font(.system(size: 18))
                        .padding(.top, 10)
                    
                    Spacer()
                    
                }

                ZStack {
                    if showPassword {
                        TextField("Password", text: $password)
                    } else {
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
            
            Spacer()
            
            VStack {
                AsyncButton {
                    await handleLogin()
                } label: {
                    Text("Login")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .padding(.horizontal, 20)
                        .padding()
                        .background(Color.seherCircle)
                        .cornerRadius(70.0)
                }
                .disabled(!canLogIn)
                
                if let loginError = loginError {
                    Text(loginError)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                NavigationLink(destination: RegisterView(registerViewModel: _registerViewModel, loginViewModel: _loginViewModel)) {
                    Text("Register")
                        .buttonStyle(SecondaryButtonStyle())
                        .padding()
                        .font(.system(size: 18))
                        .foregroundColor(Color.seherText)
                }
                .navigationBarBackButtonHidden(true)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
    @MainActor
    private func handleLogin() async {
        do {
            let _ = try await loginViewModel.login(email: email, password: password)
        } catch {
            loginError = error.localizedDescription
        }
    }
}
