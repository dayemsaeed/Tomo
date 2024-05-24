//
//  RegisterView.swift
//  Seher
//
//  Created by Dayem Saeed on 3/23/21.
//

import SwiftUI
import AVFoundation

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isEditing = false
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var registerError: String?
    @EnvironmentObject var registerViewModel: RegisterViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel

    private var canSignUp: Bool {
        return !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && password == confirmPassword
    }

    var body: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 150)
            
            Text("TOMO")
                .foregroundColor(Color.seherText)
                .font(.system(size: 36))

            InputField(title: "EMAIL", text: $email)
            PasswordField(title: "PASSWORD", text: $password, showPassword: $showPassword)
            PasswordField(title: "CONFIRM PASSWORD", text: $confirmPassword, showPassword: $showConfirmPassword)

            Spacer()

            AsyncButton {
                await handleRegister()
            } label: {
                Text("Register")
            }
            .buttonStyle(PrimaryButtonStyle(disabled: !canSignUp))

            if let registerError = registerError {
                Text(registerError)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

            NavigationLink(destination: LoginView(loginViewModel: _loginViewModel, registerViewModel: _registerViewModel)) {
                Text("LOGIN")
            }
            .buttonStyle(SecondaryButtonStyle())
            .navigationBarBackButtonHidden(true)

            Spacer()
        }
        .padding(.horizontal, 30)
    }
    
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

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.system(size: 18))
            .foregroundColor(Color.seherText)
    }
}

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
