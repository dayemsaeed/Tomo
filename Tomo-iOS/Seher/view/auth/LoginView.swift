//
//  LoginView.swift
//  Seher
//
//  Created by Dayem Saeed on 12/15/20.
//

import SwiftUI
import FirebaseAuth

/// The `LoginView` handles the user interface for logging in using Firebase authentication.
struct LoginView: View {
    
    // MARK: - State Variables
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isEditing = false
    @State private var showPassword = false
    @State private var loginError: String?
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var registerViewModel: RegisterViewModel
    
    // Boolean indicating if the login button can be enabled
    private var canLogIn: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - UI Components
    var body: some View {
        
        VStack {
            Spacer().frame(height: 150)
            
            Text("TOMO")
                .foregroundColor(Color.seherText)
                .font(.system(size: 36))
                .padding()

            // Email input
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
            }

            // Password input
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
                    
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .onTapGesture {
                            showPassword.toggle()
                        }
                }
                
                Divider()
            }

            // Login button
            Button(action: {
                Task {
                    await handleLogin()
                }
            }) {
                Text("Log In")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle(disabled: !canLogIn))
            .disabled(!canLogIn)
            
            // Error message
            if let loginError = loginError {
                Text(loginError)
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    
    /// Handles the login action using Firebase Authentication.
    @MainActor
    private func handleLogin() async {
        do {
            let _ = try await loginViewModel.login(email: email, password: password)
        } catch {
            loginError = error.localizedDescription
            print(loginError ?? "")
        }
    }
}
