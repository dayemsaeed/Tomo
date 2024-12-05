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
    @State private var showConfirmPassword = false
    @State private var registerError: String?
    
    @EnvironmentObject var registerViewModel: RegisterViewModel
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password, confirmPassword
    }
    
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
        .background(Color(uiColor: .systemBackground))
        .onTapGesture {
            focusedField = nil // Dismiss keyboard when tapping outside
        }
    }
    
    private var registrationForm: some View {
        VStack(spacing: 0) {
            // Back Button
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            // Logo Section
            VStack(spacing: 8) {
                Text("TOMO")
                    .foregroundColor(Color.seherText)
                    .font(.system(size: 42, weight: .bold))
                Text("Create your account")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.top, 60)
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
                    isSecure: !showPassword,
                    toggleSecure: { showPassword.toggle() }
                )
                .focused($focusedField, equals: .password)
                
                CustomTextField(
                    title: "CONFIRM PASSWORD",
                    placeholder: "Confirm your password",
                    text: $confirmPassword,
                    isSecure: !showConfirmPassword,
                    toggleSecure: { showConfirmPassword.toggle() }
                )
                .focused($focusedField, equals: .confirmPassword)
            }
            .padding(.horizontal, 24)
            
            // Error Message
            if let registerError = registerError {
                Text(registerError)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
            }
            
            Spacer()
            
            // Register Button
            Button(action: {
                Task {
                    await handleRegister()
                }
            }) {
                Text("Create Account")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle(disabled: !canRegister))
            .disabled(!canRegister)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Handles the register action using Firebase Authentication.
    @MainActor
    private func handleRegister() async {
        // Dismiss keyboard
        focusedField = nil
        
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
