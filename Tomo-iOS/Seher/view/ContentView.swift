//
//  ContentView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/5/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var registerViewModel: RegisterViewModel
    @EnvironmentObject var taskViewModel: TaskViewModel
    
    var body: some View {
        NavigationView {
            if loginViewModel.isLoggedIn {
                if !registerViewModel.isRegistered {
                    RegisterView(registerViewModel: _registerViewModel, loginViewModel: _loginViewModel)
                } else {
                    LoginView(loginViewModel: _loginViewModel, registerViewModel: _registerViewModel)
                }
            } else {
                MainView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
