//
//  ContentView.swift
//  PetSupport
//
//  Created by Dayem Saeed on 5/5/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var registerViewModel = RegisterViewModel()
    @StateObject var taskViewModel = TaskViewModel()
    
    var body: some View {
        NavigationView {
            if loginViewModel.isLoggedIn {
                if !registerViewModel.isRegistered {
                    RegisterView(registerView: registerViewModel, loginViewModel: loginViewModel)
                } else {
                    LoginView(userLoggedIn: loginViewModel, registerViewModel: registerViewModel)
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
