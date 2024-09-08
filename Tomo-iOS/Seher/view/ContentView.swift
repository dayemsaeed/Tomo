//
//  ContentView.swift
//  Seher
//
//  Created by Dayem Saeed on 5/5/21.
//

import SwiftUI

/// `ContentView` is the root view that manages navigation between the `HomeView` and the login flow.
/// It checks if the user is logged in and displays either the login or the home screen.
struct ContentView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel  // Environment object for login logic
    @EnvironmentObject var registerViewModel: RegisterViewModel  // Environment object for registration logic
    @State private var isLoggedIn = false  // State to track if the user is logged in

    var body: some View {
        NavigationView {
            if !isLoggedIn {
                HomeView()  // Show the home view when not logged in
            } else {
                VStack {
                    // Show the login view and monitor login changes
                    LoginView()
                        .environmentObject(loginViewModel)
                        .environmentObject(registerViewModel)
                        .onChange(of: loginViewModel.isLoggedIn) {
                            isLoggedIn = loginViewModel.isLoggedIn
                        }
                        .onChange(of: registerViewModel.isLoggedIn) {
                            isLoggedIn = registerViewModel.isLoggedIn
                        }
                }
            }
        }
    }
}
