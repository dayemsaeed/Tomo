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
    
    @State private var isSecured: Bool = true
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var registerViewModel: RegisterViewModel
    
    // Boolean indicating if the login button can be enabled
    private var canLogIn: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    // Add this property to handle keyboard dismissal
    @FocusState private var focusedField: Field?
    
    // Define fields that can have focus
    enum Field {
        case email, password
    }
    
    // MARK: - UI Components
    var body: some View {
        VStack(spacing: 0) {
            // Logo Section
            VStack(spacing: 8) {
                Text("TOMO")
                    .foregroundColor(Color.seherText)
                    .font(.system(size: 42, weight: .bold))
                Text("Welcome back!")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.top, 100)
            .padding(.bottom, 60)
            
            // Form Section
            VStack(spacing: 24) {
                CustomTextField(
                    title: "EMAIL",
                    placeholder: "Enter your email",
                    text: $email
                )
                .focused($focusedField, equals: .email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                
                CustomTextField(
                    title: "PASSWORD",
                    placeholder: "Enter your password",
                    text: $password,
                    isSecure: isSecured,
                    toggleSecure: { isSecured.toggle() }
                )
                .focused($focusedField, equals: .password)
            }
            .padding(.horizontal, 24)
            
            // Error Message
            if let loginError = loginError {
                Text(loginError)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // Buttons Section
            VStack(spacing: 16) {
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
                
                NavigationLink {
                    RegisterView()
                        .navigationBarHidden(true)
                } label: {
                    Text("Create Account")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(SecondaryButtonStyle())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(uiColor: .systemBackground))
        .onTapGesture {
            focusedField = nil // Dismiss keyboard when tapping outside
        }
    }
    
    // MARK: - Helper Methods
    
    /// Handles the login action using Supabase Authentication.
    @MainActor
    private func handleLogin() async {
        // Dismiss keyboard
        focusedField = nil
        
        do {
            let _ = try await loginViewModel.login(email: email, password: password)
        } catch {
            loginError = error.localizedDescription
            print(loginError ?? "")
        }
    }
}

// Add a secondary button style
struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.seherCircle)
            .font(.system(size: 18))
            .padding(.horizontal, 20)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 70.0)
                    .stroke(Color.seherCircle, lineWidth: 2)
            )
    }
}
