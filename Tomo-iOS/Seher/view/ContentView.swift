//
//  ContentView.swift
//  Seher
//
//  Created by Dayem Saeed on 5/5/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginViewModel : LoginViewModel
    @EnvironmentObject var registerViewModel : RegisterViewModel
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            if !isLoggedIn {
                HomeView()
            } else {
                VStack {
                    LoginView()
                        .environmentObject(loginViewModel)
                        .environmentObject(registerViewModel)
                        .onChange(of: loginViewModel.isLoggedIn, {
                            isLoggedIn = loginViewModel.isLoggedIn
                        })
                        .onChange(of: registerViewModel.isLoggedIn, {
                            isLoggedIn = registerViewModel.isLoggedIn
                        })
                }
            }
        }
    }
}
