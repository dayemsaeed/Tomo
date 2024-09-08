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
    
    // Boolean to determine if user can register
    private var canRegister: Bool {
        return !email.isEmpty && password == confirmPassword && password.count >= 6
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
                InputField(title: "EMAIL", text: $email)
            }
            
            // Password input
            Group {
                PasswordField(title: "PASSWORD", text: $password, showPassword: $showPassword)
                PasswordField(title: "CONFIRM PASSWORD", text: $confirmPassword, showPassword: $showPassword)
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

/// Input field component for user input (e.g., email).
struct InputField: View {
    var title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18))
            TextField("", text: $text)
            Divider().foregroundColor(.black)
        }
    }
}

/// Password field component with an option to toggle visibility.
struct PasswordField: View {
    var title: String
    @Binding var text: String
    @Binding var showPassword: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18))
            ZStack(alignment: .trailing) {
                if showPassword {
                    TextField("", text: $text)
                } else {
                    SecureField("", text: $text)
                }
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .onTapGesture { showPassword.toggle() }
            }
            Divider().foregroundColor(.black)
        }
    }
}
