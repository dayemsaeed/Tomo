//
//  RegisterView.swift
//  Seher
//
//  Created by Dayem Saeed on 12/15/20.
//

import SwiftUI
import FirebaseAuth

/// The `RegisterView` handles the UI for user registration using Firebase authentication.
struct RegisterView: View {
    
    // MARK: - State Variables
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword = false
    @State private var registerError: String?
    
    @EnvironmentObject var registerViewModel: RegisterViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Boolean to determine if user can register
    private var canRegister: Bool {
        return !email.isEmpty && password == confirmPassword && password.count >= 6
    }
    
    // MARK: - UI Components
    var body: some View {
        Group {
            if registerViewModel.isRegistered {
                EmailConfirmationView(email: email)
            } else {
                registrationForm
            }
        }
    }
    
    private var registrationForm: some View {
        VStack {
            // Back button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }
                Spacer()
            }
            .padding(.top)
            
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
                
                TextField("Email", text: $email)
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
                
                ZStack(alignment: .trailing) {
                    if showPassword {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .accentColor(.gray)
                    }
                }
                
                Divider()
            }
            
            // Confirm Password input
            Group {
                HStack {
                    Text("CONFIRM PASSWORD")
                        .font(.system(size: 18))
                        .padding(.top, 10)
                    Spacer()
                }
                
                ZStack(alignment: .trailing) {
                    if showPassword {
                        TextField("Confirm Password", text: $confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .accentColor(.gray)
                    }
                }
                
                Divider()
            }

            // Register button
            Button(action: {
                Task {
                    await handleRegister()
                }
            }) {
                Text("Register")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle(disabled: !canRegister))
            .disabled(!canRegister)
            
            // Error message
            if let registerError = registerError {
                Text(registerError)
                    .foregroundColor(.red)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    
    /// Handles the register action using Firebase Authentication.
    @MainActor
    private func handleRegister() async {
        do {
            let _ = try await registerViewModel.register(email: email, password: password)
        } catch {
            registerError = error.localizedDescription
            print(registerError ?? "")
        }
    }
}

/// Style for primary buttons in the registration and login forms.
struct PrimaryButtonStyle: ButtonStyle {
    var disabled: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.system(size: 18))
            .padding(.horizontal, 20)
            .padding()
            .background(Color.seherCircle)
            .cornerRadius(70.0)
            .disabled(disabled)
    }
}

struct EmailConfirmationView: View {
    let email: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "envelope.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.seherCircle)
            
            Text("Check your email")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("We sent a confirmation email to:\n\(email)")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Text("Click the link in the email to confirm your account")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            Button(action: {
                dismiss()
            }) {
                Text("Back to Login")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 30)
        }
        .padding()
    }
}
